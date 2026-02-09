import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/ligainsider_model.dart';
import '../models/ligainsider_match_model.dart';
import '../../domain/exceptions/kickbase_exceptions.dart';

/// Ligainsider Service
///
/// Scraped injury and lineup data from ligainsider.de
/// Provides player status information (starting XI, bench, injured, etc.)
///
/// Based on LigainsiderService.swift from iOS app
class LigainsiderService {
  static const String _baseUrl = 'https://www.ligainsider.de';
  static const String _overviewUrl = '$_baseUrl/bundesliga/spieltage/';
  static const Duration _cacheTimeout = Duration(hours: 1);
  static const String _cacheKey = 'ligainsider_cache';
  // Optional proxy URL used for web builds to avoid CORS issues. Set via
  // `--dart-define=LIGAINSIDER_PROXY_URL=https://your-proxy.example/ligainsider`.
  static const String _proxyUrl = String.fromEnvironment(
    'LIGAINSIDER_PROXY_URL',
    defaultValue: '',
  );
  static const String _cacheTimestampKey = 'ligainsider_cache_timestamp';

  // Matches-specific cache keys
  static const String _matchesCacheKey = 'ligainsider_cache_matches';
  static const String _matchesCacheTimestampKey =
      'ligainsider_cache_timestamp_matches';

  final http.Client _httpClient;
  final SharedPreferences _prefs;
  final Connectivity _connectivity;

  // In-memory cache for fast access
  final Map<String, LigainsiderPlayer> _playerCache = {};
  final Set<String> _alternativeNames = {};
  final Set<String> _startingLineupIds = {};

  // Matches cache (match-based lineups)
  final List<LigainsiderMatch> _matches = [];

  // Track last fetch to avoid noisy repeated requests (esp. on web reloads)
  DateTime? _lastFetch;

  bool _isReady = false;

  LigainsiderService({
    required http.Client httpClient,
    required SharedPreferences prefs,
    Connectivity? connectivity,
  }) : _httpClient = httpClient,
       _prefs = prefs,
       _connectivity = connectivity ?? Connectivity();

  /// Check if service is ready with data
  bool get isReady => _isReady;

  /// Get player cache size for debugging
  int get playerCacheCount => _playerCache.length;

  // MARK: - Public API

  /// Fetch lineups and populate cache
  Future<void> fetchLineups() async {
    print('🔄 Ligainsider: Starting lineup fetch...');

    // Avoid noisy repeated fetches
    if (_lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < const Duration(seconds: 15)) {
      print(
        '⚠️ Ligainsider: Recent fetch in last 15s detected, skipping redundant fetch',
      );
      return;
    }
    _lastFetch = DateTime.now();

    // Check connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      print('⚠️ Ligainsider: No internet connection, loading from cache');
      await _loadFromCache();
      return;
    }

    // On Web builds, browser CORS prevents scraping ligainsider.de directly.
    // If a proxy URL is provided via dart-define, try to fetch JSON from it.
    if (kIsWeb) {
      if (_proxyUrl.isNotEmpty) {
        try {
          print('ℹ️ Ligainsider: Running on Web - trying proxy: $_proxyUrl');
          final resp = await _httpClient.get(Uri.parse(_proxyUrl));
          if (resp.statusCode == 200) {
            final List<dynamic> data = jsonDecode(resp.body);
            final players = data
                .map(
                  (j) => LigainsiderPlayer.fromJson(j as Map<String, dynamic>),
                )
                .toList();

            // Populate caches
            _playerCache.clear();
            _alternativeNames.clear();
            _startingLineupIds.clear();

            for (final player in players) {
              if (player.ligainsiderId != null) {
                _playerCache[player.ligainsiderId!] = player;
                _startingLineupIds.add(player.ligainsiderId!);
                if (player.alternative != null) {
                  _alternativeNames.add(_normalize(player.alternative!));
                }
              }
            }

            print(
              '✅ Ligainsider: Loaded ${_playerCache.length} players from proxy',
            );
            _isReady = true;
            await _saveToCache(players);
            return;
          } else {
            print(
              '⚠️ Ligainsider: Proxy responded with ${resp.statusCode}, falling back to cache',
            );
            await _loadFromCache();
            return;
          }
        } catch (e) {
          print('⚠️ Ligainsider: Proxy fetch failed: $e');
          await _loadFromCache();
          return;
        }
      }

      print(
        '⚠️ Ligainsider: Running on Web platform — scraping blocked by CORS. Loading from cache only.',
      );
      await _loadFromCache();
      return;
    }

    try {
      // Scrape ligainsider.de
      final players = await _scrapeLigainsider();

      // Build cache
      _playerCache.clear();
      _alternativeNames.clear();
      _startingLineupIds.clear();

      for (final player in players) {
        if (player.ligainsiderId != null) {
          _playerCache[player.ligainsiderId!] = player;
          _startingLineupIds.add(player.ligainsiderId!);

          // Track alternatives
          if (player.alternative != null) {
            _alternativeNames.add(_normalize(player.alternative!));
          }
        }
      }

      print(
        '✅ Ligainsider: Cache populated with ${_playerCache.length} players',
      );
      print('   - Starting lineup IDs: ${_startingLineupIds.length}');
      print('   - Alternative names: ${_alternativeNames.length}');

      // Debug: Dump cached players with image URLs
      for (final entry in _playerCache.entries) {
        final p = entry.value;
        print(
          '🔎 Ligainsider: CacheEntry - id=${entry.key}, name=${p.name}, imageUrl=${p.imageUrl ?? 'null'}',
        );
      }

      _isReady = true;

      // Save to persistent cache
      await _saveToCache(players);
    } catch (e) {
      print('❌ Ligainsider: Error fetching lineups: $e');
      // Try loading from cache
      await _loadFromCache();
    }
  }

  /// Get Ligainsider player by first and last name
  LigainsiderPlayer? getLigainsiderPlayer(String firstName, String lastName) {
    if (_playerCache.isEmpty) {
      print(
        '[MATCHING] ❌ Cache EMPTY for $firstName $lastName — trigger background fetch',
      );
      // Trigger background fetch
      unawaited(fetchLineups());
      return null;
    }

    final normalizedLastName = _normalize(lastName);
    final normalizedFirstName = _normalize(firstName);

    print(
      "[MATCHING] 🔍 Searching: '$firstName' '$lastName' (normalized: '$normalizedFirstName' '$normalizedLastName') in cache of ${_playerCache.length} players",
    );

    // Step 1: Filter by last name
    var candidates = _playerCache.entries.where((entry) {
      final normalizedKey = _normalize(entry.key);
      final keyParts = normalizedKey.split(RegExp(r'[ _-]'));
      return keyParts.contains(normalizedLastName);
    }).toList();

    print(
      "   → Step 1: Found ${candidates.length} candidates by last name '$normalizedLastName'",
    );

    // Fallback: Try first name if no last name matches
    if (candidates.isEmpty && normalizedFirstName.isNotEmpty) {
      candidates = _playerCache.entries.where((entry) {
        final normalizedKey = _normalize(entry.key);
        final keyParts = normalizedKey.split(RegExp(r'[ _-]'));
        return keyParts.contains(normalizedFirstName);
      }).toList();

      if (candidates.isNotEmpty) {
        print(
          "   → Step 1b: Found ${candidates.length} candidates by first name '$normalizedFirstName'",
        );
      }
    }

    // Single match
    if (candidates.length == 1) {
      print(
        '[Ligainsider] FOUND (exact): $firstName $lastName -> ${candidates.first.key}',
      );
      return candidates.first.value;
    }

    // Multiple matches: disambiguate
    if (candidates.length > 1) {
      // Try both names present
      if (normalizedFirstName.isNotEmpty) {
        final bothMatch = candidates.where((entry) {
          final normalizedKey = _normalize(entry.key);
          final keyParts = normalizedKey.split(RegExp(r'[ _-]'));
          return keyParts.contains(normalizedFirstName) &&
              keyParts.contains(normalizedLastName);
        }).firstOrNull;

        if (bothMatch != null) {
          print(
            '[Ligainsider] FOUND (both names): $firstName $lastName -> ${bothMatch.key}',
          );
          return bothMatch.value;
        }
      }

      // Try firstName disambiguation
      final firstNameMatch = candidates.where((entry) {
        final normalizedKey = _normalize(entry.key);
        final keyParts = normalizedKey.split(RegExp(r'[ _-]'));
        return keyParts.contains(normalizedFirstName);
      }).firstOrNull;

      if (firstNameMatch != null) {
        print(
          '[Ligainsider] FOUND (firstName disamb): $firstName $lastName -> ${firstNameMatch.key}',
        );
        return firstNameMatch.value;
      }

      // Try prefix match
      final prefixMatch = candidates.where((entry) {
        final normalizedKey = _normalize(entry.key);
        return normalizedKey.startsWith(normalizedLastName) ||
            normalizedKey.startsWith(normalizedFirstName);
      }).firstOrNull;

      if (prefixMatch != null) {
        print(
          '[Ligainsider] FOUND (prefix): $firstName $lastName -> ${prefixMatch.key}',
        );
        return prefixMatch.value;
      }

      // Return first match
      print(
        '[Ligainsider] FOUND (first of many): $firstName $lastName -> ${candidates.first.key}',
      );
      return candidates.first.value;
    }

    // Step 2: Loose contains matching
    print(
      "[Ligainsider] Step 2: Trying loose contains matching for '$normalizedLastName'",
    );
    final looseCandidates = _playerCache.entries.where((entry) {
      final normalizedKey = _normalize(entry.key);
      return normalizedKey.contains(normalizedLastName);
    }).toList();

    print('[Ligainsider] Found ${looseCandidates.length} loose candidates');

    if (looseCandidates.length == 1) {
      print(
        '[Ligainsider] FOUND (loose exact): $firstName $lastName -> ${looseCandidates.first.key}',
      );
      return looseCandidates.first.value;
    }

    if (looseCandidates.length > 1) {
      final bestMatch = looseCandidates.where((entry) {
        final normalizedKey = _normalize(entry.key);
        return normalizedKey.contains(normalizedFirstName);
      }).firstOrNull;

      if (bestMatch != null) {
        print(
          '[Ligainsider] FOUND (loose firstName): $firstName $lastName -> ${bestMatch.key}',
        );
        return bestMatch.value;
      }

      print(
        '[Ligainsider] NOT FOUND: Multiple loose matches and no firstName match',
      );
    }

    print('[Ligainsider] NOT FOUND: $firstName $lastName');
    return null;
  }

  /// Public access to parsed matches (may be empty until `fetchMatchLineups` is called)
  List<LigainsiderMatch> get matches => List.unmodifiable(_matches);

  /// Fetch match-based lineups and populate matches cache
  ///
  /// This uses the same overview page as player scraping and attempts to
  /// parse match pages for home/away lineups. If parsing fails it will leave
  /// the `_matches` list empty and fall back to player-based logic elsewhere.
  Future<void> fetchMatchLineups() async {
    print(
      '🔄 Ligainsider: Fetching match lineups (overview + detail pages)...',
    );

    try {
      // Try to fetch overview and parse basic match list
      final response = await _httpClient.get(Uri.parse(_overviewUrl));
      if (response.statusCode != 200) {
        print('⚠️ Ligainsider: Failed to fetch overview for matches');
        return;
      }

      final document = html_parser.parse(response.body);

      // Simple heuristic: find match containers or links that look like matches
      final matchLinks = <String>{};

      // Common patterns: links that contain 'spiel' or '/spiel/' or '/spiele/'
      final anchors = document.querySelectorAll('a[href]');
      for (final a in anchors) {
        final href = a.attributes['href'] ?? '';
        if (href.contains('/spiel') || href.contains('/spiele')) {
          var absolute = href;
          if (!href.startsWith('http')) {
            absolute = _baseUrl + (href.startsWith('/') ? href : '/$href');
          }
          matchLinks.add(absolute);
        }
      }

      // If no links found, keep matches empty and return
      if (matchLinks.isEmpty) {
        print('ℹ️ Ligainsider: No match links found in overview');
        return;
      }

      final parsedMatches = <LigainsiderMatch>[];

      for (final link in matchLinks) {
        try {
          final detailResp = await _httpClient.get(Uri.parse(link));
          if (detailResp.statusCode != 200) continue;

          final detailDoc = html_parser.parse(detailResp.body);

          // Heuristics to extract team names
          String home =
              detailDoc.querySelector('.team-home')?.text.trim() ??
              detailDoc.querySelector('.home-team')?.text.trim() ??
              detailDoc.querySelector('h1')?.text.trim() ??
              'Heim';
          String away =
              detailDoc.querySelector('.team-away')?.text.trim() ??
              detailDoc.querySelector('.away-team')?.text.trim() ??
              'Gast';

          // Logos (if present)
          String? homeLogo = detailDoc
              .querySelector('.team-home img')
              ?.attributes['src'];
          String? awayLogo = detailDoc
              .querySelector('.team-away img')
              ?.attributes['src'];

          // Parse simple lineup rows: look for elements with class containing "aufstellung" or "lineup"
          List<LineupRow> parseRows(String selectorRoot) {
            final rows = <LineupRow>[];
            final container = detailDoc.querySelector(selectorRoot);
            if (container == null) return rows;

            final rowElements = container.querySelectorAll(
              '.row, .lineup-row, li',
            );
            if (rowElements.isEmpty) return rows;

            for (final r in rowElements) {
              final playerAnchors = r.querySelectorAll('a[href*="_"]');
              if (playerAnchors.isEmpty) continue;
              final players = <LineupPlayer>[];
              for (final pa in playerAnchors) {
                final name = pa.text.trim();
                if (name.isEmpty) continue;
                final img = pa.querySelector('img')?.attributes['src'];
                String? alternative;
                // detect alternative naming nearby
                final siblings = pa.parent?.querySelectorAll('a[href*="_"]');
                if (siblings != null && siblings.length > 1) {
                  final idx = siblings.indexOf(pa);
                  if (idx == 0 && siblings.length > 1) {
                    alternative = siblings[1].text.trim();
                  }
                }
                players.add(
                  LineupPlayer(
                    name: name,
                    imageUrl: img,
                    alternative: alternative,
                  ),
                );
              }

              if (players.isNotEmpty) {
                rows.add(LineupRow(rowName: 'Row', players: players));
              }
            }
            return rows;
          }

          // Try several selectors
          final homeRows = parseRows('.aufstellung.home').isNotEmpty
              ? parseRows('.aufstellung.home')
              : parseRows('.lineup.home');
          final awayRows = parseRows('.aufstellung.away').isNotEmpty
              ? parseRows('.aufstellung.away')
              : parseRows('.lineup.away');

          // If still empty, try generic selectors per side
          final genericHome = homeRows.isEmpty ? parseRows('.home') : homeRows;
          final genericAway = awayRows.isEmpty ? parseRows('.away') : awayRows;

          final matchId = link;

          parsedMatches.add(
            LigainsiderMatch(
              id: matchId,
              homeTeam: home,
              awayTeam: away,
              homeLogo: homeLogo,
              awayLogo: awayLogo,
              homeLineup: genericHome.isEmpty ? [] : genericHome,
              awayLineup: genericAway.isEmpty ? [] : genericAway,
            ),
          );
        } catch (e) {
          // skip failures per match
          continue;
        }
      }

      _matches.clear();
      _matches.addAll(parsedMatches);

      // Save to cache
      await _saveMatchesToCache(parsedMatches);

      print('✅ Ligainsider: Parsed ${_matches.length} matches from HTML');
    } catch (e) {
      print('⚠️ Ligainsider: Failed to fetch match lineups: $e');
    }
  }

  /// Get player status (starting XI, bench, alternative, out)
  LigainsiderPlayerStatus getPlayerStatus(String firstName, String lastName) {
    final normalizedLastName = _normalize(lastName);
    final normalizedFirstName = _normalize(firstName);

    // Check if player is an alternative
    final isAlternative = _alternativeNames.any((altName) {
      final normalizedAlt = _normalize(altName);
      return normalizedLastName == normalizedAlt ||
          normalizedAlt.contains(normalizedLastName);
    });

    if (isAlternative) {
      return LigainsiderPlayerStatus.isAlternative;
    }

    // Search in cache
    var candidates = _playerCache.entries.where((entry) {
      final normalizedKey = _normalize(entry.key);
      return normalizedKey.contains(normalizedLastName);
    }).toList();

    // Fallback to first name
    if (candidates.isEmpty && normalizedFirstName.isNotEmpty) {
      candidates = _playerCache.entries.where((entry) {
        final normalizedKey = _normalize(entry.key);
        return normalizedKey.contains(normalizedFirstName);
      }).toList();
    }

    MapEntry<String, LigainsiderPlayer>? foundEntry;

    if (candidates.length == 1) {
      foundEntry = candidates.first;
    } else if (candidates.length > 1) {
      // Prefer both names present
      foundEntry = candidates.where((entry) {
        final normalizedKey = _normalize(entry.key);
        final parts = normalizedKey.split(RegExp(r'[ _-]'));
        return parts.contains(normalizedFirstName) &&
            parts.contains(normalizedLastName);
      }).firstOrNull;

      foundEntry ??= candidates.where((entry) {
        final normalizedKey = _normalize(entry.key);
        return normalizedKey.contains(normalizedFirstName);
      }).firstOrNull;

      foundEntry ??= candidates.firstOrNull;
    }

    if (foundEntry != null) {
      final player = foundEntry.value;
      final id = foundEntry.key;

      // Check if in starting lineup
      if (_startingLineupIds.contains(id)) {
        if (player.alternative != null) {
          return LigainsiderPlayerStatus.startWithAlternative;
        }
        return LigainsiderPlayerStatus.likelyStart;
      } else {
        // In squad but not starting
        return LigainsiderPlayerStatus.bench;
      }
    }

    return LigainsiderPlayerStatus.out;
  }

  // MARK: - HTML Scraping

  Future<List<LigainsiderPlayer>> _scrapeLigainsider() async {
    print('🌐 Ligainsider: Fetching overview from $_overviewUrl');

    final response = await _httpClient.get(Uri.parse(_overviewUrl));

    if (response.statusCode != 200) {
      throw ServerException(
        'Failed to fetch ligainsider.de',
        statusCode: response.statusCode,
      );
    }

    final document = html_parser.parse(response.body);
    final players = <LigainsiderPlayer>[];

    // Parse player links from lineup sections
    // Target: <a href="/player-name_id/">Player Name</a>
    final links = document.querySelectorAll('a[href*="_"]');

    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null || !href.contains('_')) continue;

      // Extract slug (e.g., "player-name_12345")
      final slug = href.replaceAll('/', '').trim();
      if (slug.isEmpty || !RegExp(r'\d$').hasMatch(slug)) continue;

      // Extract name
      final name = link.text.trim();
      if (name.isEmpty || name.length > 50) continue;

      // Extract image URL if available
      final img = link.querySelector('img');
      String? imageUrl = img?.attributes['src'];

      // Discard accidental overview URLs being used as images
      if (imageUrl != null && imageUrl.contains('spieltage')) {
        print(
          '⚠️ Ligainsider: Ignoring non-image URL found in anchor for $name: $imageUrl',
        );
        imageUrl = null;
      }

      // If no image found in the anchor, try the player detail page as fallback
      if (imageUrl == null) {
        try {
          final detailHref = href.startsWith('http')
              ? href
              : (_baseUrl + (href.startsWith('/') ? href : '/$href'));
          final detailResp = await _httpClient.get(Uri.parse(detailHref));
          if (detailResp.statusCode == 200) {
            final detailDoc = html_parser.parse(detailResp.body);

            // Try several selectors in order of preference
            final metaOg = detailDoc
                .querySelector('meta[property="og:image"]')
                ?.attributes['content'];
            final playerImg = detailDoc
                .querySelector('img[class*="player"]')
                ?.attributes['src'];
            final spielerImg = detailDoc
                .querySelector('img[class*="spieler"]')
                ?.attributes['src'];
            final genericImg =
                detailDoc.querySelector('.player img')?.attributes['src'] ??
                detailDoc.querySelector('.person img')?.attributes['src'] ??
                detailDoc
                    .querySelector('img[src*="/player/"]')
                    ?.attributes['src'];

            final candidate = metaOg ?? playerImg ?? spielerImg ?? genericImg;
            if (candidate != null && candidate.isNotEmpty) {
              if (candidate.contains('spieltage')) {
                print(
                  '⚠️ Ligainsider: Ignoring non-image URL from detail page for $name: $candidate',
                );
              } else {
                imageUrl = candidate;
                print(
                  'ℹ️ Ligainsider: Found detail image for $name -> $imageUrl',
                );
              }
            }
          }
        } catch (e) {
          print('⚠️ Ligainsider: Failed to fetch detail page for $href: $e');
        }
      }

      // Check for alternative player
      String? alternative;
      final parent = link.parent;
      if (parent != null) {
        final altLinks = parent.querySelectorAll('a[href*="_"]');
        if (altLinks.length > 1 && altLinks.indexOf(link) == 0) {
          alternative = altLinks[1].text.trim();
        }
      }

      // Normalize image URL (make absolute if needed)
      if (imageUrl != null && imageUrl.isNotEmpty) {
        if (imageUrl.startsWith('//')) {
          imageUrl = 'https:$imageUrl';
        } else if (imageUrl.startsWith('/')) {
          imageUrl = '$_baseUrl$imageUrl';
        }
      }

      // Skip duplicates
      if (players.any((p) => p.ligainsiderId == slug)) continue;

      // Debug log for each parsed player
      print(
        '🔍 Ligainsider: Parsed player -> name: $name, id: $slug, imageUrl: ${imageUrl ?? 'null'}',
      );

      players.add(
        LigainsiderPlayer(
          id: slug,
          name: name,
          shortName: name,
          teamName: 'Unknown',
          teamId: 'unknown',
          position: 0,
          injury_status: InjuryStatus.fit,
          injury_description: null,
          form_rating: null,
          last_update: DateTime.now(),
          status_text: null,
          expected_return: null,
          ligainsiderId: slug, // Set ligainsiderId for cache key
          alternative: alternative,
          imageUrl: imageUrl,
        ),
      );
    }

    print('✅ Ligainsider: Parsed ${players.length} players from HTML');
    return players;
  }

  // MARK: - Name Normalization

  /// Normalize text for matching (remove accents, convert umlauts, etc.)
  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('ß', 'ss')
        .replaceAll('ć', 'c')
        .replaceAll('č', 'c')
        .replaceAll('š', 's')
        .replaceAll('ž', 'z')
        .replaceAll('đ', 'd')
        .replaceAll('-', ' ')
        .trim();
  }

  // MARK: - Caching

  Future<void> _saveToCache(List<LigainsiderPlayer> players) async {
    try {
      final data = players.map((p) => p.toJson()).toList();
      await _prefs.setString(_cacheKey, jsonEncode(data));
      await _prefs.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      print('💾 Ligainsider: Saved ${players.length} players to cache');
    } catch (e) {
      print('⚠️ Ligainsider: Failed to save cache: $e');
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final cachedData = _prefs.getString(_cacheKey);
      final timestamp = _prefs.getInt(_cacheTimestampKey);

      if (cachedData == null || timestamp == null) {
        print('ℹ️ Ligainsider: No cache available');
        return;
      }

      // Check cache age
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (cacheAge > _cacheTimeout.inMilliseconds) {
        print(
          '⏰ Ligainsider: Cache expired (${Duration(milliseconds: cacheAge).inMinutes} min old)',
        );
        return;
      }

      final List<dynamic> data = jsonDecode(cachedData);
      final players = data
          .map((json) => LigainsiderPlayer.fromJson(json))
          .toList();

      // Populate cache
      _playerCache.clear();
      _alternativeNames.clear();
      _startingLineupIds.clear();

      for (final player in players) {
        if (player.ligainsiderId != null) {
          _playerCache[player.ligainsiderId!] = player;
          _startingLineupIds.add(player.ligainsiderId!);

          if (player.alternative != null) {
            _alternativeNames.add(_normalize(player.alternative!));
          }
        }
      }

      _isReady = true;
      print('✅ Ligainsider: Loaded ${_playerCache.length} players from cache');

      // Debug: Dump cache entries loaded from persistent cache
      for (final entry in _playerCache.entries) {
        final p = entry.value;
        print(
          '🔎 Ligainsider (cache load): id=${entry.key}, name=${p.name}, imageUrl=${p.imageUrl ?? 'null'}',
        );
      }

      // Also try to load matches from cache
      await _loadMatchesFromCache();
    } catch (e) {
      print('⚠️ Ligainsider: Failed to load cache: $e');
    }
  }

  // Matches caching
  Future<void> _saveMatchesToCache(List<LigainsiderMatch> matches) async {
    try {
      final data = matches.map((m) => m.toJson()).toList();
      await _prefs.setString(_matchesCacheKey, jsonEncode(data));
      await _prefs.setInt(
        _matchesCacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      print('💾 Ligainsider: Saved ${matches.length} matches to cache');
    } catch (e) {
      print('⚠️ Ligainsider: Failed to save matches cache: $e');
    }
  }

  Future<void> _loadMatchesFromCache() async {
    try {
      final cached = _prefs.getString(_matchesCacheKey);
      final ts = _prefs.getInt(_matchesCacheTimestampKey);
      if (cached == null || ts == null) return;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > _cacheTimeout.inMilliseconds) {
        print('⏰ Ligainsider: Matches cache expired');
        return;
      }

      final List<dynamic> data = jsonDecode(cached);
      final matches = data.map((j) => LigainsiderMatch.fromJson(j)).toList();
      _matches.clear();
      _matches.addAll(matches);
      print('✅ Ligainsider: Loaded ${_matches.length} matches from cache');
    } catch (e) {
      print('⚠️ Ligainsider: Failed to load matches cache: $e');
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_cacheTimestampKey);
    _playerCache.clear();
    _alternativeNames.clear();
    _startingLineupIds.clear();
    _isReady = false;
    print('🗑️ Ligainsider: Cache cleared');
  }
}

/// Helper for unawaited futures
void unawaited(Future<void> future) {
  // Intentionally empty - just to silence linter warnings
}

/// Extension for firstOrNull
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
