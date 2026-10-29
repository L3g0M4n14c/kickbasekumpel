import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

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
  // Optional proxy URL used for web builds to avoid CORS issues. Set via
  // `--dart-define=LIGAINSIDER_PROXY_URL=https://your-proxy.example/ligainsider`.
  static const String _proxyUrl = String.fromEnvironment(
    'LIGAINSIDER_PROXY_URL',
    defaultValue: '',
  );
  static const String _cacheTimestampKey = 'ligainsider_cache_timestamp';

  /// Slugs der S11 (Startelf) – persistiert neben den Spielern, damit der
  /// Status nach einem Neustart sofort korrekt ist.
  static const String _s11CacheKey = 'ligainsider_cache_s11';

  /// Normalisierte Namen der Alternativen (2. Option) – persistiert.
  static const String _alternativeCacheKey = 'ligainsider_cache_alternatives';

  /// Frische-Fenster: Ist der persistente Aufstellungs-Cache jünger, wird
  /// gar kein Netzwerk-Request ausgelöst. Das macht App-Starts (und jeden
  /// erneuten Einstieg in die Aufstellung) sofort schnell.
  static const Duration _freshCacheTtl = Duration(minutes: 10);

  /// Maximal parallele Requests auf die Team-Aufstellungsseiten.
  /// Bewusst klein: schont Netzwerk/Akku und bleibt unter dem Limit, ab dem
  /// ligainsider.de drosselt.
  static const int _lineupFetchConcurrency = 6;

  /// Timeout für eine einzelne Team-Aufstellungsseite.
  static const Duration _lineupPageTimeout = Duration(seconds: 15);

  /// Timeout für die Spieltags-Übersicht (Haupt-Scrape).
  static const Duration _overviewTimeout = Duration(seconds: 20);

  /// Ligainsider-Slug eines Spielers: `{name-in-kebab-case}_{id}`.
  static final RegExp _slugPattern = RegExp(r'^[a-z0-9-]+_\d+$');

  /// Mindestanzahl an Startelf-Spielern im Cache, ab der die Abdeckung als
  /// vollständig gilt (Bundesliga: 18 Teams × 11 = 198).
  ///
  /// 170 ≈ 16 von 18 Teams: Ligainsider veröffentlicht die voraussichtlichen
  /// Aufstellungen Spiel für Spiel. Fehlen noch mehrere Teams, ist "Spieler
  /// nicht gefunden" eine Datenlücke und darf NICHT als "Fehlt" angezeigt
  /// werden – siehe [hasLineupCoverage].
  static const int minPlayersForFullCoverage = 170;

  final http.Client _httpClient;
  final SharedPreferences _prefs;
  final Connectivity _connectivity;
  final Logger _logger = Logger();

  // In-memory cache for fast access
  final Map<String, LigainsiderPlayer> _playerCache = {};
  final Set<String> _alternativeNames = {};
  final Set<String> _startingLineupIds = {};

  // Track last fetch to avoid noisy repeated requests (esp. on web reloads)
  DateTime? _lastFetch;

  // Single-flight: parallele Aufrufe teilen sich einen laufenden Scrape.
  Future<void>? _inFlightFetch;

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

  /// true, wenn die gecachten Daten den Großteil der Bundesliga-S11 abdecken.
  ///
  /// Nur dann ist "Spieler nicht gefunden" gleichbedeutend mit "kein
  /// S11-Platz" (Status [LigainsiderPlayerStatus.out] = "Fehlt"). Bei
  /// unvollständigen Daten (Aufstellungen noch nicht veröffentlicht) ist
  /// "nicht gefunden" dagegen eine Datenlücke und darf nicht als Ausfall
  /// dargestellt werden.
  bool get hasLineupCoverage =>
      _startingLineupIds.length >= minPlayersForFullCoverage;

  /// Alter des persistenten Aufstellungs-Caches (null = kein Cache).
  Duration? get _persistedCacheAge {
    final timestamp = _prefs.getInt(_cacheTimestampKey);
    if (timestamp == null) return null;
    return Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch - timestamp,
    );
  }

  /// true, wenn der persistente Cache jünger als [_freshCacheTtl] ist.
  bool get isCacheFresh {
    final age = _persistedCacheAge;
    return age != null && age <= _freshCacheTtl;
  }

  // MARK: - Public API

  /// Lädt die Aufstellungsdaten so früh und so günstig wie möglich.
  ///
  /// Reihenfolge (schnell → langsam):
  /// 1. In-Memory-Cache (schon geladen) → sofort fertig.
  /// 2. Persistenter Cache → sofort nutzbare Daten. Ist er älter als
  ///    [_freshCacheTtl], läuft die Aktualisierung im Hintergrund weiter,
  ///    ohne die UI zu blockieren.
  /// 3. Nur wenn gar keine Daten vorliegen: Netzwerk-Scrape (awaited).
  ///
  /// Wird beim App-Start (Hintergrund-Preload) und von der Aufstellungs-
  /// Empfehlung genutzt, damit dort nie auf einen kompletten Scrape gewartet
  /// werden muss.
  Future<void> ensureLoaded({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await fetchLineups(force: true);
      return;
    }
    if (_isReady) return;

    final age = _persistedCacheAge;
    if (age != null && age <= _freshCacheTtl) {
      // Frischer Cache: kein Netzwerk-Request nötig.
      if (await _loadFromCache()) return;
    } else if (age != null) {
      // Veralteter Cache: sofort nutzbare Daten ausliefern und im Hintergrund
      // aktualisieren – die Aufstellung ist damit direkt gefüllt.
      final loaded = await _loadFromCache(allowStale: true);
      if (loaded) {
        unawaited(fetchLineups(force: true));
        return;
      }
    }

    await fetchLineups(force: forceRefresh);
  }

  /// Fetch lineups and populate cache
  ///
  /// [force] erzwingt einen Netzwerk-Scrape, auch wenn der persistente Cache
  /// noch frisch ist (z. B. Pull-to-Refresh).
  Future<void> fetchLineups({bool force = false}) async {
    // Single-flight: App-Start-Preload und Aufstellungs-Screen teilen sich
    // einen laufenden Request, statt doppelt zu scrapen.
    final inFlight = _inFlightFetch;
    if (inFlight != null) {
      _logger.d('ℹ️ Ligainsider: Fetch already running – awaiting result');
      return inFlight;
    }

    final future = _fetchLineups(force: force);
    _inFlightFetch = future;
    try {
      await future;
    } finally {
      _inFlightFetch = null;
    }
  }

  Future<void> _fetchLineups({required bool force}) async {
    _logger.d('🔄 Ligainsider: Starting lineup fetch...');

    // Avoid noisy repeated fetches
    if (_isReady &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < const Duration(seconds: 15)) {
      _logger.w(
        '⚠️ Ligainsider: Recent fetch in last 15s detected, skipping redundant fetch',
      );
      return;
    }

    // Frischer persistenter Cache → Netzwerk sparen (App-Start!).
    if (!force && isCacheFresh) {
      if (_playerCache.isNotEmpty) {
        _logger.d('⚡ Ligainsider: Fresh cache in memory – skipping network');
        return;
      }
      if (await _loadFromCache()) {
        _logger.d('⚡ Ligainsider: Fresh cache loaded – skipping network');
        return;
      }
    }

    _lastFetch = DateTime.now();

    // Check connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _logger.w('⚠️ Ligainsider: No internet connection, loading from cache');
      await _loadFromCache(allowStale: true);
      return;
    }

    // On Web builds, browser CORS prevents scraping ligainsider.de directly.
    // If a proxy URL is provided via dart-define, try to fetch JSON from it.
    if (kIsWeb) {
      if (_proxyUrl.isNotEmpty) {
        try {
          _logger.i(
            'ℹ️ Ligainsider: Running on Web - trying proxy: $_proxyUrl',
          );
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

            _logger.d(
              '✅ Ligainsider: Loaded ${_playerCache.length} players from proxy',
            );
            _isReady = true;
            await _saveToCache(
              _ScrapeResult(
                players: players,
                startingIds: _startingLineupIds.toList(growable: false),
                alternativeNames: _alternativeNames.toList(growable: false),
              ),
            );
            return;
          } else {
            _logger.w(
              '⚠️ Ligainsider: Proxy responded with ${resp.statusCode}, falling back to cache',
            );
            await _loadFromCache();
            return;
          }
        } catch (e) {
          _logger.w('⚠️ Ligainsider: Proxy fetch failed: $e');
          await _loadFromCache();
          return;
        }
      }

      _logger.w(
        '⚠️ Ligainsider: Running on Web platform — scraping blocked by CORS. Loading from cache only.',
      );
      await _loadFromCache();
      return;
    }

    try {
      // Voraussichtliche Aufstellungen scrapen (Übersicht + Team-Seiten)
      final result = await _scrapeLigainsider();

      // Build cache
      _playerCache.clear();
      _alternativeNames.clear();
      _startingLineupIds.clear();

      for (final player in result.players) {
        final id = player.ligainsiderId;
        if (id != null) _playerCache[id] = player;
      }
      _startingLineupIds.addAll(result.startingIds);
      _alternativeNames.addAll(result.alternativeNames);

      if (_startingLineupIds.isEmpty) {
        _logger.w(
          '⚠️ Ligainsider: Keine Startelf gefunden – Cache bleibt leer',
        );
      }

      _logger.d(
        '✅ Ligainsider: Cache populated with ${_playerCache.length} players',
      );
      _logger.d('   - Starting lineup IDs: ${_startingLineupIds.length}');
      _logger.d('   - Alternative names: ${_alternativeNames.length}');

      _isReady = _startingLineupIds.isNotEmpty;

      // Save to persistent cache
      await _saveToCache(result);
    } catch (e) {
      _logger.e('❌ Ligainsider: Error fetching lineups: $e');
      // Try loading from cache (auch ein älterer Cache ist besser als keiner)
      await _loadFromCache(allowStale: true);
    }
  }

  /// Get Ligainsider player by first and last name
  LigainsiderPlayer? getLigainsiderPlayer(String firstName, String lastName) {
    if (_playerCache.isEmpty) {
      _logger.d(
        '[MATCHING] ❌ Cache EMPTY for $firstName $lastName — trigger background fetch',
      );
      // Trigger background fetch
      unawaited(fetchLineups());
      return null;
    }

    final normalizedLastName = _normalize(lastName);
    final normalizedFirstName = _normalize(firstName);

    _logger.d(
      "[MATCHING] 🔍 Searching: '$firstName' '$lastName' (normalized: '$normalizedFirstName' '$normalizedLastName') in cache of ${_playerCache.length} players",
    );

    // Step 1: Filter by last name
    var candidates = _playerCache.entries.where((entry) {
      final normalizedKey = _normalize(entry.key);
      final keyParts = normalizedKey.split(RegExp(r'[ _-]'));
      return keyParts.contains(normalizedLastName);
    }).toList();

    _logger.d(
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
        _logger.d(
          "   → Step 1b: Found ${candidates.length} candidates by first name '$normalizedFirstName'",
        );
      }
    }

    // Single match
    if (candidates.length == 1) {
      _logger.d(
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
          _logger.d(
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
        _logger.d(
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
        _logger.d(
          '[Ligainsider] FOUND (prefix): $firstName $lastName -> ${prefixMatch.key}',
        );
        return prefixMatch.value;
      }

      // Return first match
      _logger.d(
        '[Ligainsider] FOUND (first of many): $firstName $lastName -> ${candidates.first.key}',
      );
      return candidates.first.value;
    }

    // Step 2: Loose contains matching
    _logger.d(
      "[Ligainsider] Step 2: Trying loose contains matching for '$normalizedLastName'",
    );
    final looseCandidates = _playerCache.entries.where((entry) {
      final normalizedKey = _normalize(entry.key);
      return normalizedKey.contains(normalizedLastName);
    }).toList();

    _logger.d('[Ligainsider] Found ${looseCandidates.length} loose candidates');

    if (looseCandidates.length == 1) {
      _logger.d(
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
        _logger.d(
          '[Ligainsider] FOUND (loose firstName): $firstName $lastName -> ${bestMatch.key}',
        );
        return bestMatch.value;
      }

      _logger.d(
        '[Ligainsider] NOT FOUND: Multiple loose matches and no firstName match',
      );
    }

    _logger.d('[Ligainsider] NOT FOUND: $firstName $lastName');
    return null;
  }

  /// Get player status (starting XI, bench, alternative, out)
  LigainsiderPlayerStatus getPlayerStatus(String firstName, String lastName) {
    final lastNameSegments = _nameSegments(_normalize(lastName));
    final firstNameSegments = _nameSegments(_normalize(firstName));

    // Leere Namen dürfen nie matchen – Contains auf '' wäre immer wahr.
    if (lastNameSegments.isEmpty && firstNameSegments.isEmpty) {
      return LigainsiderPlayerStatus.out;
    }
    final querySegments = lastNameSegments.isNotEmpty
        ? lastNameSegments
        : firstNameSegments;

    // Check if player is an alternative. Segment-Match statt Contains:
    // 'Lang' darf nicht an 'Langkamp' matchen.
    final isAlternative = _alternativeNames.any(
      (altName) => _nameSegments(altName).containsAll(querySegments),
    );

    if (isAlternative) {
      return LigainsiderPlayerStatus.isAlternative;
    }

    // Search in cache (Segment-Match wie in getLigainsiderPlayer)
    var candidates = _playerCache.entries.where((entry) {
      return _nameSegments(_normalize(entry.key)).containsAll(querySegments);
    }).toList();

    // Fallback to first name
    if (candidates.isEmpty &&
        lastNameSegments.isNotEmpty &&
        firstNameSegments.isNotEmpty) {
      candidates = _playerCache.entries.where((entry) {
        return _nameSegments(_normalize(entry.key))
            .containsAll(firstNameSegments);
      }).toList();
    }

    MapEntry<String, LigainsiderPlayer>? foundEntry;

    if (candidates.length == 1) {
      foundEntry = candidates.first;
    } else if (candidates.length > 1) {
      // Prefer both names present
      foundEntry = candidates.where((entry) {
        final parts = _nameSegments(_normalize(entry.key));
        return parts.containsAll(lastNameSegments) &&
            parts.containsAll(firstNameSegments);
      }).firstOrNull;

      foundEntry ??= candidates.where((entry) {
        return _nameSegments(_normalize(entry.key))
            .containsAll(firstNameSegments);
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

  /// Scraped die voraussichtlichen Aufstellungen des aktuellen Spieltags.
  ///
  /// Ablauf:
  /// 1. Spieltags-Übersicht laden (1 Request).
  /// 2. Daraus die Team-Aufstellungsseiten extrahieren (2 Links pro Spiel,
  ///    also 18 Seiten) – dort steht die „VORAUSSICHTLICHE AUFSTELLUNG“
  ///    inklusive Spielerfotos und Alternativen.
  /// 3. Die Seiten **parallel** (max. [_lineupFetchConcurrency]) laden und die
  ///    Startelf-Slots parsen.
  ///
  /// Vorher wurde nur die Übersichtsseite geparst – die enthält allerdings
  /// keine Spieler-Links, sondern lediglich News. Ergebnis war ein Cache mit
  /// wenigen Pseudo-Spielern, wodurch jeder echte Spieler als „nicht in der
  /// Startelf“ („Fehlt“) galt.
  Future<_ScrapeResult> _scrapeLigainsider() async {
    _logger.d('🌐 Ligainsider: Fetching matchday overview from $_overviewUrl');

    final response = await _httpClient
        .get(Uri.parse(_overviewUrl))
        .timeout(_overviewTimeout);

    if (response.statusCode != 200) {
      throw ServerException(
        'Failed to fetch ligainsider.de',
        statusCode: response.statusCode,
      );
    }

    final document = html_parser.parse(response.body);
    final teamUrls = _extractTeamLineupUrls(document);

    if (teamUrls.isEmpty) {
      _logger.w(
        '⚠️ Ligainsider: Keine Team-Aufstellungs-Links auf der Übersicht gefunden',
      );
      return const _ScrapeResult.empty();
    }

    _logger.d(
      'ℹ️ Ligainsider: ${teamUrls.length} Team-Aufstellungsseiten gefunden',
    );

    final slots = await _fetchLineupSlots(teamUrls);
    _logger.d('✅ Ligainsider: ${slots.length} Startelf-Slots geparst');

    final players = <LigainsiderPlayer>[];
    final startingIds = <String>[];
    final alternativeNames = <String>[];
    final seenSlugs = <String>{};

    for (final slot in slots) {
      final starter = slot.starter;
      if (!seenSlugs.add(starter.slug)) continue;

      // Bereits bekannter Spieler (z. B. als Starter gelistet) wird nicht
      // doppelt geführt.
      var alternative = slot.alternative;
      if (alternative != null && !seenSlugs.add(alternative.slug)) {
        alternative = null;
      }

      startingIds.add(starter.slug);
      players.add(_toPlayer(starter, alternative: alternative?.name));

      if (alternative != null) {
        alternativeNames.add(_normalize(alternative.name));
        players.add(_toPlayer(alternative));
      }
    }

    return _ScrapeResult(
      players: players,
      startingIds: startingIds,
      alternativeNames: alternativeNames,
    );
  }

  LigainsiderPlayer _toPlayer(_SlotPlayer player, {String? alternative}) {
    return LigainsiderPlayer(
      id: player.slug,
      name: player.name,
      shortName: player.name,
      teamName: 'Unknown',
      teamId: 'unknown',
      position: 0,
      injuryStatus: InjuryStatus.fit,
      injuryDescription: null,
      formRating: null,
      lastUpdate: DateTime.now(),
      statusText: null,
      expectedReturn: null,
      ligainsiderId: player.slug, // Cache-Key
      alternative: alternative,
      imageUrl: player.imageUrl,
    );
  }

  /// Sammelt die Team-Aufstellungs-Links der Spieltags-Übersicht.
  ///
  /// Muster: `/bundesliga/team/{team-slug}/{team-id}/saison-{jahr}/{spiel-id}`
  /// – pro Spiel zwei Links (Heim- und Gastmannschaft).
  static List<String> _extractTeamLineupUrls(Document document) {
    final urls = <String>[];
    for (final anchor in document.querySelectorAll('a[href*="/bundesliga/team/"]')) {
      final href = anchor.attributes['href'];
      if (href == null || !href.contains('/saison-')) continue;
      final absolute = href.startsWith('http') ? href : '$_baseUrl$href';
      final normalized = absolute.endsWith('/') ? absolute : '$absolute/';
      if (!urls.contains(normalized)) urls.add(normalized);
    }
    return urls;
  }

  /// Lädt die Team-Seiten in Blöcken parallel und parst die Startelf-Slots.
  Future<List<_LineupSlot>> _fetchLineupSlots(List<String> urls) async {
    final slots = <_LineupSlot>[];
    for (var i = 0; i < urls.length; i += _lineupFetchConcurrency) {
      final chunk = urls
          .skip(i)
          .take(_lineupFetchConcurrency)
          .toList(growable: false);
      final results = await Future.wait(
        chunk.map(_fetchTeamLineupSlots),
      );
      for (final teamSlots in results) {
        slots.addAll(teamSlots);
      }
    }
    return slots;
  }

  /// Parst die „VORAUSSICHTLICHE AUFSTELLUNG“ einer Team-Seite.
  ///
  /// Pro Feldspieler-Position gibt es eine `player_position_column`; die erste
  /// Verlinkung ist der Startelf-Spieler, eine zweite (falls vorhanden) die
  /// Alternative (2. Option).
  Future<List<_LineupSlot>> _fetchTeamLineupSlots(String url) async {
    try {
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(_lineupPageTimeout);
      if (response.statusCode != 200) {
        _logger.w('⚠️ Ligainsider: HTTP ${response.statusCode} für $url');
        return const [];
      }

      final document = html_parser.parse(response.body);
      final slots = <_LineupSlot>[];

      for (final row in document.querySelectorAll('.player_position_row')) {
        for (final column in row.querySelectorAll('.player_position_column')) {
          final players = <_SlotPlayer>[];
          final seen = <String>{};

          for (final anchor in column.querySelectorAll('a[href*="_"]')) {
            final href = anchor.attributes['href'];
            if (href == null || !href.contains('_')) continue;
            final slug = href.replaceAll('/', '').trim();
            if (slug.isEmpty || !_slugPattern.hasMatch(slug)) continue;
            if (!seen.add(slug)) continue;

            final name = _nameFromSlug(slug);
            if (name == null || name.isEmpty) continue;

            players.add(
              _SlotPlayer(
                slug: slug,
                name: name,
                imageUrl: _absoluteImageUrl(
                  anchor.querySelector('img')?.attributes['src'],
                ),
              ),
            );
          }

          if (players.isEmpty) continue;
          slots.add(
            _LineupSlot(
              starter: players.first,
              alternative: players.length > 1 ? players[1] : null,
            ),
          );
        }
      }

      return slots;
    } catch (e) {
      _logger.w('⚠️ Ligainsider: Aufstellungsseite fehlgeschlagen ($url): $e');
      return const [];
    }
  }

  /// Leitet aus einem Ligainsider-Slug den vollen Spielernamen ab
  /// (`manuel-neuer_114` → `Manuel Neuer`).
  static String? _nameFromSlug(String slug) {
    final separator = slug.lastIndexOf('_');
    final namePart = separator > 0 ? slug.substring(0, separator) : slug;
    final words = namePart
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .toList(growable: false);
    return words.isEmpty ? null : words.join(' ');
  }

  /// Macht eine relative Bild-URL absolut und filtert Nicht-Bilder
  /// (z. B. verlinkte Spieltags-Seiten) heraus.
  String? _absoluteImageUrl(String? raw) {
    if (raw == null) return null;
    final value = raw.trim();
    if (value.isEmpty) return null;
    if (value.contains('spieltage')) return null;
    if (value.startsWith('//')) return 'https:$value';
    if (value.startsWith('/')) return '$_baseUrl$value';
    return value;
  }

  // MARK: - Name Normalization


  /// Namen-Segmente eines normalisierten Texts (z. B. "kevin bauer_123" →
  /// {kevin, bauer, 123}). Basis für exakten Segment-Match statt Contains –
  /// damit z. B. "Lang" nicht an "Langkamp" matched.
  static Set<String> _nameSegments(String normalized) => normalized
      .split(RegExp(r'[ _-]'))
      .where((segment) => segment.isNotEmpty)
      .toSet();

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

  Future<void> _saveToCache(_ScrapeResult result) async {
    try {
      final data = result.players.map((p) => p.toJson()).toList();
      await _prefs.setString(_cacheKey, jsonEncode(data));
      await _prefs.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      // Startelf + Alternativen separat ablegen: nur damit lässt sich der
      // Status nach einem Neustart ohne erneuten Scrape korrekt zuordnen.
      await _prefs.setString(_s11CacheKey, jsonEncode(result.startingIds));
      await _prefs.setString(
        _alternativeCacheKey,
        jsonEncode(result.alternativeNames),
      );
      _logger.d(
        '💾 Ligainsider: Saved ${result.players.length} players to cache '
        '(${result.startingIds.length} S11)',
      );
    } catch (e) {
      _logger.w('⚠️ Ligainsider: Failed to save cache: $e');
    }
  }

  /// Lädt den persistenten Aufstellungs-Cache in den Speicher.
  ///
  /// [allowStale] erlaubt auch einen abgelaufenen Cache (> [_cacheTimeout]).
  /// Das ist beim App-Start gewünscht: lieber sofort (leicht veraltete) Daten
  /// anzeigen und im Hintergrund aktualisieren, als einen leeren Screen.
  ///
  /// Returns: true, wenn Daten geladen wurden.
  Future<bool> _loadFromCache({bool allowStale = false}) async {
    try {
      final cachedData = _prefs.getString(_cacheKey);
      final timestamp = _prefs.getInt(_cacheTimestampKey);

      if (cachedData == null || timestamp == null) {
        _logger.i('ℹ️ Ligainsider: No cache available');
        return false;
      }

      // Check cache age
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (!allowStale && cacheAge > _cacheTimeout.inMilliseconds) {
        _logger.w(
          '⏰ Ligainsider: Cache expired (${Duration(milliseconds: cacheAge).inMinutes} min old)',
        );
        return false;
      }

      final List<dynamic> data = jsonDecode(cachedData);
      final players = data
          .map((json) => LigainsiderPlayer.fromJson(json))
          .toList();

      final s11 = _decodeStringList(_prefs.getString(_s11CacheKey));
      final alternatives = _decodeStringList(
        _prefs.getString(_alternativeCacheKey),
      );

      // Populate cache
      _playerCache.clear();
      _alternativeNames.clear();
      _startingLineupIds.clear();

      for (final player in players) {
        final id = player.ligainsiderId;
        if (id != null) _playerCache[id] = player;
      }
      _startingLineupIds.addAll(s11);
      _alternativeNames.addAll(alternatives);

      _isReady = _playerCache.isNotEmpty;
      _logger.d(
        '✅ Ligainsider: Loaded ${_playerCache.length} players from cache '
        '(${_startingLineupIds.length} S11)',
      );

      return _isReady;
    } catch (e) {
      _logger.e('⚠️ Ligainsider: Failed to load cache: $e');
      return false;
    }
  }

  static List<String> _decodeStringList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<String>().toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_cacheTimestampKey);
    await _prefs.remove(_s11CacheKey);
    await _prefs.remove(_alternativeCacheKey);
    _playerCache.clear();
    _alternativeNames.clear();
    _startingLineupIds.clear();
    _isReady = false;
    _logger.d('🗑️ Ligainsider: Cache cleared');
  }
}

/// Ergebnis eines Scraping-Laufs: Spieler, Startelf-Slugs und Alternativen.
class _ScrapeResult {
  const _ScrapeResult({
    required this.players,
    required this.startingIds,
    required this.alternativeNames,
  });

  const _ScrapeResult.empty()
    : players = const [],
      startingIds = const [],
      alternativeNames = const [];

  /// Alle erfassten Spieler (Startelf + Alternativen) inkl. Foto-URL.
  final List<LigainsiderPlayer> players;

  /// Slugs der Startelf-Spieler (S11).
  final List<String> startingIds;

  /// Normalisierte Namen der Alternativen (2. Option).
  final List<String> alternativeNames;
}

/// Eine Position der voraussichtlichen Aufstellung: Startelf + ggf. Alternative.
class _LineupSlot {
  const _LineupSlot({required this.starter, this.alternative});

  final _SlotPlayer starter;
  final _SlotPlayer? alternative;
}

/// Ein einzelner Spieler-Slot aus der Ligainsider-Aufstellung.
class _SlotPlayer {
  const _SlotPlayer({
    required this.slug,
    required this.name,
    required this.imageUrl,
  });

  /// Ligainsider-Slug inkl. ID (z. B. `max-mustermann_12345`) – Cache-Key.
  final String slug;

  /// Voller Name aus dem Slug (`Max Mustermann`) – Basis für das Matching.
  final String name;

  /// Foto-URL von cdn.ligainsider.de (kommt direkt mit der Aufstellungsseite).
  final String? imageUrl;
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
