import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ligainsider_model.dart';
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
  static const String _cacheTimestampKey = 'ligainsider_cache_timestamp';

  final http.Client _httpClient;
  final SharedPreferences _prefs;
  final Connectivity _connectivity;

  // In-memory cache for fast access
  final Map<String, LigainsiderPlayer> _playerCache = {};
  final Set<String> _alternativeNames = {};
  final Set<String> _startingLineupIds = {};

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

    // Check connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      print('⚠️ Ligainsider: No internet connection, loading from cache');
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
      final imageUrl = img?.attributes['src'];

      // Check for alternative player
      String? alternative;
      final parent = link.parent;
      if (parent != null) {
        final altLinks = parent.querySelectorAll('a[href*="_"]');
        if (altLinks.length > 1 && altLinks.indexOf(link) == 0) {
          alternative = altLinks[1].text.trim();
        }
      }

      // Skip duplicates
      if (players.any((p) => p.ligainsiderId == slug)) continue;

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
    } catch (e) {
      print('⚠️ Ligainsider: Failed to load cache: $e');
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
