import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../domain/repositories/repository_interfaces.dart';
import '../models/player_model.dart';
import '../models/market_value_model.dart';
import '../models/performance_model.dart';
import '../models/ligainsider_model.dart';

/// Ergebnis einer KI-Empfehlung von Mistral
/// Identisch zum alten GeminiRecommendationResult für Kompatibilität
class MistralRecommendationResult {
  static const defaultConfidence = 0.5;

  final double score;
  final String action;
  final String reason;
  final double confidence;
  final int estimatedValue;
  final String category;
  final String? swapCandidateId;
  final String? swapCandidateName;

  const MistralRecommendationResult({
    required this.score,
    required this.action,
    required this.reason,
    required this.confidence,
    required this.estimatedValue,
    required this.category,
    this.swapCandidateId,
    this.swapCandidateName,
  });

  factory MistralRecommendationResult.fromJson(Map<String, dynamic> json) {
    final score = (json['score'] as num).toDouble().clamp(0.0, 100.0);
    return MistralRecommendationResult(
      score: score,
      action: _actionFromScore(score),
      reason: json['reason'] as String? ?? '',
      confidence:
          ((json['confidence'] as num?)?.toDouble() ?? defaultConfidence).clamp(
            0.0,
            1.0,
          ),
      estimatedValue: (json['estimatedValue'] as num).toInt(),
      category: _categoryFromScore(score),
      swapCandidateId: json['swapCandidateId'] as String?,
      swapCandidateName: json['swapCandidateName'] as String?,
    );
  }

  static String _actionFromScore(double score) {
    if (score >= 80) return 'strong-buy';
    if (score >= 60) return 'buy';
    if (score >= 40) return 'hold';
    if (score >= 20) return 'sell';
    return 'strong-sell';
  }

  static String _categoryFromScore(double score) {
    if (score >= 80) return 'strong-buy';
    if (score >= 60) return 'buy';
    if (score >= 40) return 'general';
    if (score >= 20) return 'sell';
    return 'strong-sell';
  }

  /// Konvertiert zu Map für JSON-Serialisierung
  Map<String, dynamic> toJson() => {
    'score': score,
    'action': action,
    'reason': reason,
    'confidence': confidence,
    'estimatedValue': estimatedValue,
    'category': category,
    if (swapCandidateId != null) 'swapCandidateId': swapCandidateId,
    if (swapCandidateName != null) 'swapCandidateName': swapCandidateName,
  };
}

/// Service für KI-gestützte Spielerempfehlungen via Firebase Cloud Function Proxy.
///
/// Analysiert Spielerdaten (Punkte, Marktwert-Verlauf, Status, Form) und
/// gibt strukturierte Kauf-/Verkaufsempfehlungen auf Deutsch zurück.
///
/// **Sicherheit:** Der Mistral API-Key bleibt serverseitig in der Cloud Function.
/// Die App ruft nur die Cloud Function auf, die dann Mistral kontaktiert.
///
/// Ergebnisse werden NICHT in Firestore gespeichert, sondern direkt
/// an den Client zurückgegeben.
///
/// Verwendung:
/// ```dart
/// final service = MistralRecommendationService();
/// final result = await service.generateRecommendation(
///   player: player,
///   marketValueHistory: history,
///   recentPerformances: performances,
///   ligainsiderData: ligainsiderPlayer,
/// );
/// ```
class MistralRecommendationService {
  static const _functionUrl =
      'https://us-central1-kickbasekumpel.cloudfunctions.net/callMistral';
  static const _cacheTtl = Duration(hours: 2);
  static const _maxPlayersPerBatchCall = 10;
  static const _injuryStatuses = {1, 2};
  static const _suspensionStatuses = {8, 32};
  static const _absenceStatuses = {256};
  static const _injuryKeywords = {
    'verletzt',
    'verletzung',
    'injury',
    'out',
    'ausfall',
  };
  static const _suspensionKeywords = {
    'gesperrt',
    'sperre',
    'gelbsperre',
    'suspended',
  };
  static const _absenceKeywords = {'abwesend', 'absence', 'absent'};

  // Mistral Agent Konfiguration
  static const _agentId = 'ag_019e09566ba573479511b072fd9efe1a';
  static const _agentVersion = 0;

  final String _resolvedFunctionUrl;
  final Future<http.Response> Function(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  })
  _postRequest;
  final void Function(String message) _debugLogger;
  final Map<String, _CacheEntry> _cache = {};

  MistralRecommendationService({
    String functionUrl = _functionUrl,
    Future<http.Response> Function(
      Uri uri, {
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
    })?
    postRequest,
    void Function(String message)? debugLogger,
  }) : _resolvedFunctionUrl = functionUrl,
       _postRequest = postRequest ?? http.post,
       _debugLogger = debugLogger ?? debugPrint;

  /// Prüft, ob ein Spieler lokal als Verkaufskandidat behandelt werden soll.
  static bool shouldUseLocalRecommendation({
    required Player player,
    LigainsiderPlayer? ligainsiderData,
  }) {
    return _resolveAvailabilityIssue(
          player: player,
          ligainsiderData: ligainsiderData,
        ) !=
        null;
  }

  /// Generiert eine KI-Empfehlung für einen Spieler.
  ///
  /// [player] Die Stammdaten des Spielers.
  /// [marketValueHistory] Die Marktwert-Zeitreihe (optional, verbessert Analyse).
  /// [recentPerformances] Die letzten Spieltag-Leistungen (optional).
  /// [ligainsiderData] Ligainsider-Verletzungs- und Formstatus (optional).
  /// [fixtureContext] Kontext zu den nächsten Spielen (optional).
  /// [lineupContext] Team-Analyse Kontext (optional).
  /// [swapCandidates] Liste der Tauschkandidaten (optional).
  ///
  /// Returns [Result<MistralRecommendationResult>] – niemals Exceptions.
  Future<Result<MistralRecommendationResult>> generateRecommendation({
    required Player player,
    List<MarketValueEntry>? marketValueHistory,
    List<MatchPerformance>? recentPerformances,
    LigainsiderPlayer? ligainsiderData,
    String? fixtureContext,
    String? lineupContext,
    List<Player>? swapCandidates,
  }) async {
    final cacheKey = _generateCacheKey(
      playerId: player.id,
      marketValue: player.marketValue,
      status: player.status,
      averagePoints: player.averagePoints,
      marketValueTrend: player.marketValueTrend,
      stl: player.stl,
      userOwnsPlayer: player.userOwnsPlayer,
      recentPerformances: recentPerformances,
      ligainsiderData: ligainsiderData,
    );

    _pruneExpiredCache();

    // Cache prüfen
    if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      _logDebug('✅ MISTRAL CACHE HIT: ${player.firstName} ${player.lastName}');
      return Success(_cache[cacheKey]!.result);
    }

    final shortcutRecommendation = _buildLocalShortcutRecommendation(
      player: player,
      ligainsiderData: ligainsiderData,
    );
    if (shortcutRecommendation != null) {
      _cache[cacheKey] = _CacheEntry(
        shortcutRecommendation,
        DateTime.now().add(_cacheTtl),
      );
      return Success(shortcutRecommendation);
    }

    try {
      final prompt = _buildPrompt(
        player: player,
        marketValueHistory: marketValueHistory,
        recentPerformances: recentPerformances,
        ligainsiderData: ligainsiderData,
        fixtureContext: fixtureContext,
        lineupContext: lineupContext,
        swapCandidates: swapCandidates,
      );
      _logDebug(
        '📤 MISTRAL REQUEST: ${player.firstName} ${player.lastName} (single)',
      );
      _logPrompt(
        prompt,
        label: 'single ${player.firstName} ${player.lastName}'.trim(),
      );

      final response = await _callMistralApi(prompt);

      if (response == null || response.isEmpty) {
        return const Failure(
          'Mistral hat keine Antwort zurückgegeben.',
          code: 'empty_response',
        );
      }

      final normalizedResponse = _normalizeJsonResponse(response);

      // Mistral gibt JSON zurück, gelegentlich aber noch in Markdown-Fences.
      final Map<String, dynamic> json = jsonDecode(normalizedResponse);

      // Validierung der Antwort
      final validationError = _validateRecommendationJson(json);
      if (validationError != null) {
        _logDebug('❌ MISTRAL VALIDATION ERROR: $validationError');
        return Failure(
          'Mistral-Antwort hat ungültiges Format: $validationError',
          code: 'validation_error',
        );
      }

      final result = MistralRecommendationResult.fromJson(json);
      _logDebug(
        '✅ MISTRAL PARSED (${player.firstName} ${player.lastName}): '
        '${result.action} @ ${result.score}',
      );

      // In Cache speichern
      _cache[cacheKey] = _CacheEntry(result, DateTime.now().add(_cacheTtl));

      return Success(result);
    } on FormatException catch (e) {
      _logDebug('❌ MISTRAL JSON PARSE ERROR: $e');
      return Failure(
        'Mistral-Antwort konnte nicht geparst werden: $e',
        code: 'parse_error',
      );
    } on Exception catch (e) {
      _logDebug('❌ MISTRAL EXCEPTION: $e');
      return Failure(
        'KI-Analyse fehlgeschlagen: ${e.toString()}',
        code: 'mistral_error',
        exception: e,
      );
    } catch (e) {
      _logDebug('❌ MISTRAL UNKNOWN ERROR: $e');
      return Failure(
        'Unerwarteter Fehler bei der KI-Analyse: $e',
        code: 'unknown_error',
      );
    }
  }

  /// Generiert Empfehlungen für mehrere Spieler in einem oder mehreren API-Aufrufen.
  ///
  /// [players] Liste der Spieler mit jeweils optionalen Zusatzdaten.
  /// Returns [Result<Map<String, MistralRecommendationResult>>].
  Future<Result<Map<String, MistralRecommendationResult>>>
  generateBatchRecommendations({
    required List<PlayerAnalysisInput> players,
  }) async {
    _pruneExpiredCache();

    // Für Batch: Cache pro Spieler prüfen
    final uncachedPlayers = <PlayerAnalysisInput>[];
    final results = <String, MistralRecommendationResult>{};
    final uncachedCacheKeys = <String, String>{};

    for (final input in players) {
      final cacheKey = _generateCacheKey(
        playerId: input.player.id,
        marketValue: input.player.marketValue,
        status: input.player.status,
        averagePoints: input.player.averagePoints,
        marketValueTrend: input.player.marketValueTrend,
        stl: input.player.stl,
        userOwnsPlayer: input.player.userOwnsPlayer,
        recentPerformances: input.recentPerformances,
        ligainsiderData: input.ligainsiderData,
      );

      if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
        results[input.player.id] = _cache[cacheKey]!.result;
        continue;
      }

      final shortcutRecommendation = _buildLocalShortcutRecommendation(
        player: input.player,
        ligainsiderData: input.ligainsiderData,
      );
      if (shortcutRecommendation != null) {
        results[input.player.id] = shortcutRecommendation;
        _cache[cacheKey] = _CacheEntry(
          shortcutRecommendation,
          DateTime.now().add(_cacheTtl),
        );
      } else {
        uncachedPlayers.add(input);
        uncachedCacheKeys[input.player.id] = cacheKey;
      }
    }

    // Nur nicht-gecachte Spieler verarbeiten
    if (uncachedPlayers.isNotEmpty) {
      final uncachedPlayerChunks = _chunkPlayerInputs(
        uncachedPlayers,
        _maxPlayersPerBatchCall,
      );

      try {
        for (var index = 0; index < uncachedPlayerChunks.length; index++) {
          final chunk = uncachedPlayerChunks[index];
          final prompt = _buildBatchPrompt(chunk);
          _logDebug(
            '📤 MISTRAL REQUEST: batch ${index + 1}/${uncachedPlayerChunks.length} '
            'for ${chunk.length} Spieler',
          );
          _logPrompt(
            prompt,
            label:
                'batch ${index + 1}/${uncachedPlayerChunks.length} (${chunk.length} Spieler)',
          );

          final response = await _callMistralApi(prompt);

          if (response == null || response.isEmpty) {
            return Failure(
              'Mistral hat keine Antwort zurückgegeben.',
              code: 'empty_response',
            );
          }

          final normalizedResponse = _normalizeJsonResponse(response);

          // Mistral gibt JSON-Objekt mit Spieler-IDs als Keys zurück
          final rawJson = _decodeBatchJsonResponse(normalizedResponse);

          // Validierung der Batch-Antwort
          if (rawJson.isEmpty) {
            return Failure(
              'Mistral hat leere Batch-Antwort zurückgegeben.',
              code: 'empty_batch_response',
            );
          }

          for (final entry in rawJson.entries) {
            final playerId = entry.key;
            final rawPlayerJson = entry.value;
            if (rawPlayerJson is! Map<String, dynamic>) {
              _logDebug(
                '⚠️  Überspringe Batch-Eintrag mit ungültigem Format für $playerId',
              );
              continue;
            }
            final playerJson = rawPlayerJson;

            // Einzelne Empfehlung validieren
            final validationError = _validateRecommendationJson(playerJson);
            if (validationError != null) {
              _logDebug(
                '❌ MISTRAL BATCH VALIDATION ERROR für $playerId: $validationError',
              );
              _logDebug('⚠️  Überspringe ungültige Empfehlung für $playerId');
              continue;
            }

            final result = MistralRecommendationResult.fromJson(playerJson);
            results[playerId] = result;

            // In Cache speichern
            final cacheKey = uncachedCacheKeys[playerId];
            if (cacheKey != null) {
              _cache[cacheKey] = _CacheEntry(
                result,
                DateTime.now().add(_cacheTtl),
              );
            }
          }
        }
      } on Exception catch (e) {
        _logDebug('❌ MISTRAL BATCH EXCEPTION: $e');
        return Failure(
          'Batch-KI-Analyse fehlgeschlagen: ${e.toString()}',
          code: 'mistral_batch_error',
          exception: e,
        );
      } catch (e) {
        _logDebug('❌ MISTRAL BATCH UNKNOWN ERROR: $e');
        return Failure(
          'Unerwarteter Fehler bei der Batch-Analyse: $e',
          code: 'unknown_error',
        );
      }
    }

    return Success(results);
  }

  List<List<PlayerAnalysisInput>> _chunkPlayerInputs(
    List<PlayerAnalysisInput> players,
    int chunkSize,
  ) {
    if (players.isEmpty) {
      return const [];
    }

    final chunks = <List<PlayerAnalysisInput>>[];
    for (var index = 0; index < players.length; index += chunkSize) {
      final end = (index + chunkSize < players.length)
          ? index + chunkSize
          : players.length;
      chunks.add(players.sublist(index, end));
    }
    return chunks;
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Cloud Function Proxy Aufruf
  // ---------------------------------------------------------------------------

  /// Ruft die Firebase Cloud Function auf, die als Proxy zu Mistral dient.
  /// Funktion ist öffentlich (invoker: 'public') - keine Authentifizierung nötig.
  /// Verwendet die Conversations API mit Agenten.
  Future<String?> _callMistralApi(String prompt) async {
    try {
      _logDebug('🔐 MISTRAL PROXY: Rufe Cloud Function auf...');

      final response = await _postRequest(
        Uri.parse(_resolvedFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'agent_id': _agentId,
          'agent_version': _agentVersion,
          'temperature': 0.2,
          'top_p': 0.9,
        }),
      );

      if (response.statusCode == 200) {
        // Die Cloud Function gibt direkt den JSON-Content zurück
        return response.body;
      } else if (response.statusCode == 429) {
        _logDebug('❌ MISTRAL PROXY: Rate Limit erreicht (429)');
        throw Exception('Cloud Function: Rate Limit erreicht');
      } else {
        _logDebug('❌ MISTRAL PROXY: Fehler ${response.statusCode}');
        throw Exception(
          'Cloud Function Fehler: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      _logDebug('❌ MISTRAL PROXY: Fehler: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Output Validierung
  // ---------------------------------------------------------------------------

  String _normalizeJsonResponse(String response) {
    final trimmedResponse = response.trim();

    final normalizedMarkdownResponse = trimmedResponse.startsWith('```')
        ? trimmedResponse
              .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
              .replaceFirst(RegExp(r'\s*```$'), '')
              .trim()
        : trimmedResponse;

    final normalizedControlCharacters = _escapeControlCharactersInJsonStrings(
      normalizedMarkdownResponse,
    );

    return _normalizeEstimatedValueShorthand(normalizedControlCharacters);
  }

  String _normalizeEstimatedValueShorthand(String response) {
    return response.replaceAllMapped(
      RegExp(r'("estimatedValue"\s*:\s*)(-?\d+(?:[\.,]\d+)?)\s*([kKmMbB])\b'),
      (match) {
        final prefix = match.group(1)!;
        final numberPart = match.group(2)!.replaceAll(',', '.');
        final suffix = match.group(3)!.toUpperCase();
        final numericValue = double.tryParse(numberPart);

        if (numericValue == null) {
          return match.group(0)!;
        }

        final multiplier = switch (suffix) {
          'K' => 1000,
          'M' => 1000000,
          'B' => 1000000000,
          _ => 1,
        };

        final normalizedValue = (numericValue * multiplier).round();
        return '$prefix$normalizedValue';
      },
    );
  }

  Map<String, dynamic> _decodeBatchJsonResponse(String response) {
    try {
      return Map<String, dynamic>.from(jsonDecode(response) as Map);
    } on FormatException catch (error, stackTrace) {
      final salvagedResponse = _salvageBatchJsonResponse(response);
      if (salvagedResponse == null) {
        Error.throwWithStackTrace(error, stackTrace);
      }

      try {
        final salvagedJson = jsonDecode(salvagedResponse);
        if (salvagedJson is! Map) {
          Error.throwWithStackTrace(error, stackTrace);
        }

        final salvagedMap = Map<String, dynamic>.from(salvagedJson);
        if (salvagedMap.isEmpty) {
          Error.throwWithStackTrace(error, stackTrace);
        }

        _logDebug(
          '⚠️  MISTRAL BATCH RESPONSE war unvollständig - '
          '${salvagedMap.length} vollständige Einträge übernommen.',
        );
        return salvagedMap;
      } on FormatException {
        Error.throwWithStackTrace(error, stackTrace);
      }
    }
  }

  String? _salvageBatchJsonResponse(String response) {
    final startIndex = response.indexOf('{');
    if (startIndex == -1) {
      return null;
    }

    final entries = <String>[];
    var depth = 0;
    var isInsideString = false;
    var isEscaped = false;
    var currentEntryStart = -1;
    var lastNonWhitespaceIndex = -1;

    for (var index = startIndex; index < response.length; index++) {
      final char = response[index];

      if (char.trim().isNotEmpty) {
        lastNonWhitespaceIndex = index;
      }

      if (isEscaped) {
        isEscaped = false;
        continue;
      }

      if (char == r'\') {
        if (isInsideString) {
          isEscaped = true;
        }
        continue;
      }

      if (char == '"') {
        if (!isInsideString && depth == 1 && currentEntryStart == -1) {
          currentEntryStart = index;
        }
        isInsideString = !isInsideString;
        continue;
      }

      if (isInsideString) {
        continue;
      }

      if (char == '{' || char == '[') {
        depth++;
        continue;
      }

      if (char == '}' || char == ']') {
        if (char == '}' && depth == 1) {
          final entry = _extractCompleteBatchEntry(
            response,
            start: currentEntryStart,
            endExclusive: index,
          );
          if (entry != null) {
            entries.add(entry);
          }
          return entries.isEmpty ? null : '{${entries.join(',')}}';
        }

        if (depth > 0) {
          depth--;
        }
        continue;
      }

      if (depth != 1) {
        continue;
      }

      if (char == ',') {
        final entry = _extractCompleteBatchEntry(
          response,
          start: currentEntryStart,
          endExclusive: index,
        );
        if (entry != null) {
          entries.add(entry);
        }
        currentEntryStart = -1;
        continue;
      }

      if (currentEntryStart == -1 && char.trim().isNotEmpty) {
        currentEntryStart = index;
      }
    }

    if (!isInsideString && depth == 1 && lastNonWhitespaceIndex >= 0) {
      final entry = _extractCompleteBatchEntry(
        response,
        start: currentEntryStart,
        endExclusive: lastNonWhitespaceIndex + 1,
      );
      if (entry != null) {
        entries.add(entry);
      }
    }

    return entries.isEmpty ? null : '{${entries.join(',')}}';
  }

  String? _extractCompleteBatchEntry(
    String response, {
    required int start,
    required int endExclusive,
  }) {
    if (start < 0 || endExclusive <= start) {
      return null;
    }

    final entry = response.substring(start, endExclusive).trim();
    if (entry.isEmpty || !entry.contains(':')) {
      return null;
    }

    final lastChar = entry[entry.length - 1];
    if (lastChar != '}' && lastChar != ']') {
      return null;
    }

    return entry.endsWith(',')
        ? entry.substring(0, entry.length - 1).trim()
        : entry;
  }

  String _escapeControlCharactersInJsonStrings(String response) {
    final buffer = StringBuffer();
    var isInsideString = false;
    var isEscaped = false;

    for (var index = 0; index < response.length; index++) {
      final char = response[index];

      if (isEscaped) {
        buffer.write(char);
        isEscaped = false;
        continue;
      }

      if (char == r'\') {
        buffer.write(char);
        if (isInsideString) {
          isEscaped = true;
        }
        continue;
      }

      if (char == '"') {
        if (isInsideString &&
            !_isLikelyStringTerminator(response, quoteIndex: index)) {
          buffer.write(r'\"');
          continue;
        }

        buffer.write(char);
        isInsideString = !isInsideString;
        continue;
      }

      if (isInsideString) {
        switch (char) {
          case '\n':
            buffer.write(r'\n');
            continue;
          case '\r':
            buffer.write(r'\r');
            continue;
          case '\t':
            buffer.write(r'\t');
            continue;
        }
      }

      buffer.write(char);
    }

    return buffer.toString();
  }

  bool _isLikelyStringTerminator(String response, {required int quoteIndex}) {
    for (var index = quoteIndex + 1; index < response.length; index++) {
      final char = response[index];
      if (char.trim().isEmpty) {
        continue;
      }

      return char == ',' || char == '}' || char == ']' || char == ':';
    }

    return true;
  }

  /// Validiert die JSON-Antwort von Mistral
  String? _validateRecommendationJson(Map<String, dynamic> json) {
    // Pflichtfelder prüfen
    final requiredFields = [
      'score',
      'action',
      'reason',
      'estimatedValue',
      'category',
    ];
    for (final field in requiredFields) {
      if (!json.containsKey(field)) {
        return 'Fehlendes Pflichtfeld: $field';
      }
    }

    // Typen prüfen
    try {
      final score = json['score'] as num?;
      if (score == null || score.isNaN) {
        return 'score muss eine gültige Zahl sein';
      }
      if (score < 0 || score > 100) {
        return 'score muss zwischen 0 und 100 liegen (ist: $score)';
      }

      final confidence = json['confidence'] as num?;
      if (confidence != null) {
        if (confidence.isNaN) {
          return 'confidence muss eine gültige Zahl sein';
        }
        if (confidence < 0 || confidence > 1) {
          return 'confidence muss zwischen 0 und 1 liegen (ist: $confidence)';
        }
      }

      final estimatedValue = json['estimatedValue'] as num?;
      if (estimatedValue == null || estimatedValue.isNaN) {
        return 'estimatedValue muss eine gültige Zahl sein';
      }

      final action = json['action'] as String?;
      if (action == null || !action.isNotEmpty) {
        return 'action muss ein nicht-leerer String sein';
      }
      if (![
        'strong-buy',
        'buy',
        'hold',
        'sell',
        'strong-sell',
      ].contains(action)) {
        return 'action muss einer der Werte sein: strong-buy, buy, hold, sell, strong-sell (ist: $action)';
      }

      final reason = json['reason'] as String?;
      if (reason == null || reason.isEmpty) {
        return 'reason muss ein nicht-leerer String sein';
      }

      final category = json['category'] as String?;
      if (category == null || category.isEmpty) {
        return 'category muss ein nicht-leerer String sein';
      }
    } catch (e) {
      return 'Ungültiger Typ: $e';
    }

    return null; // Kein Fehler
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Cache
  // ---------------------------------------------------------------------------

  String _generateCacheKey({
    required String playerId,
    required int marketValue,
    required int status,
    required double averagePoints,
    required int marketValueTrend,
    required int stl,
    required bool userOwnsPlayer,
    List<MatchPerformance>? recentPerformances,
    LigainsiderPlayer? ligainsiderData,
  }) {
    // Einfacher Hash aus den relevanten Parametern
    // Ändert sich nur, wenn sich die Input-Daten ändern
    final ligainsiderHash = ligainsiderData != null
        ? ligainsiderData.injuryStatus.hashCode
        : 0;

    return 'mistral_${playerId}_${marketValue}_${status}_${averagePoints.toStringAsFixed(1)}_'
        '${marketValueTrend}_${stl}_${userOwnsPlayer}_${recentPerformances?.length ?? 0}_$ligainsiderHash';
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Prompt-Aufbau (identisch zu Gemini für Konsistenz)
  // ---------------------------------------------------------------------------

  String _buildPrompt({
    required Player player,
    List<MarketValueEntry>? marketValueHistory,
    List<MatchPerformance>? recentPerformances,
    LigainsiderPlayer? ligainsiderData,
    String? fixtureContext,
    String? lineupContext,
    List<Player>? swapCandidates,
  }) {
    final buffer = StringBuffer();
    final compactFixtureContext = _compactContext(
      fixtureContext,
      maxLines: 2,
      maxLength: 180,
    );
    final compactLineupContext = _compactContext(
      lineupContext,
      maxLines: 2,
      maxLength: 180,
    );
    final limitedSwapCandidates = swapCandidates?.take(2).toList();

    // Positionsspezifische Erwartungswerte für bessere Differenzierung
    final position = player.position;
    final positionName = _positionName(position);

    buffer.writeln(
      'Analysiere den folgenden Spieler für eine Kickbase-Fantasy-Football-Empfehlung. '
      'Jeder Spieler muss INDIVIDUELL und UNTERSCHIEDLICH bewertet werden. '
      'Nutze die Position ($positionName) als Kontext für die Erwartungswerte.',
    );
    buffer.writeln();
    buffer.writeln('=== KONTEXT ===');
    buffer.writeln(
      'Spielerbesitz: ${player.userOwnsPlayer ? "Du besitzt diesen Spieler bereits." : "Du besitzt diesen Spieler NICHT."}',
    );
    buffer.writeln();
    buffer.writeln('=== SPIELER-STAMMDATEN ===');
    buffer.writeln('Name: ${player.firstName} ${player.lastName}'.trim());
    buffer.writeln('Position: ${_positionName(player.position)}');
    buffer.writeln('Team: ${player.teamName}');
    buffer.writeln('Trikotnummer: ${player.number}');
    buffer.writeln();

    buffer.writeln('=== LEISTUNG ===');
    buffer.writeln(
      'Durchschnittspunkte: ${player.averagePoints.toStringAsFixed(1)}',
    );
    buffer.writeln('Gesamtpunkte: ${player.totalPoints}');
    if (recentPerformances != null && recentPerformances.isNotEmpty) {
      final lastGames = recentPerformances.take(3).toList();
      buffer.writeln('Letzte ${lastGames.length} Spieltage:');
      for (final perf in lastGames) {
        buffer.writeln(
          '  - Spieltag ${perf.day}: ${perf.p} Punkte '
          '(${perf.t1} vs ${perf.t2}, ${perf.t1g}:${perf.t2g})'
          '${perf.k != null && perf.k!.isNotEmpty ? ", ${perf.k!.length} Karte(n)" : ""}',
        );
      }

      if (player.teamName.isNotEmpty) {
        final homeGames = recentPerformances
            .where((p) => p.t1 == player.teamName)
            .toList();
        final awayGames = recentPerformances
            .where((p) => p.t2 == player.teamName)
            .toList();
        if (homeGames.isNotEmpty || awayGames.isNotEmpty) {
          buffer.writeln();
          buffer.writeln('=== HEIM/AUSWÄRTS-BILANZ (aktuelle Saison) ===');
          if (homeGames.isNotEmpty) {
            final homeAvg =
                homeGames.fold<double>(0.0, (s, p) => s + (p.p ?? 0)) /
                homeGames.length;
            buffer.writeln(
              'Heimspiele (${homeGames.length}): ${homeAvg.toStringAsFixed(1)} Ø Punkte',
            );
          }
          if (awayGames.isNotEmpty) {
            final awayAvg =
                awayGames.fold<double>(0.0, (s, p) => s + (p.p ?? 0)) /
                awayGames.length;
            buffer.writeln(
              'Auswärtsspiele (${awayGames.length}): ${awayAvg.toStringAsFixed(1)} Ø Punkte',
            );
          }

          if (fixtureContext != null && fixtureContext.isNotEmpty) {
            final isNextHome = fixtureContext.contains('Heimspiel');
            final isNextAway = fixtureContext.contains('Auswärtsspiel');
            if (isNextHome) {
              buffer.writeln('Nächstes Spiel: HEIMSPIEL');
            } else if (isNextAway) {
              buffer.writeln('Nächstes Spiel: AUSWÄRTSSPIEL');
            }
          }
        }
      }
    }
    buffer.writeln();

    buffer.writeln('=== MARKTWERT ===');
    buffer.writeln('Aktueller Marktwert: ${_formatEuro(player.marketValue)}');
    buffer.writeln(
      'Trend (kurzfristig): ${_trendName(player.marketValueTrend)}',
    );
    buffer.writeln('24h-Veränderung: ${_formatEuro(player.tfhmvt)}');
    if (marketValueHistory != null && marketValueHistory.isNotEmpty) {
      final sorted = [...marketValueHistory]
        ..sort((a, b) => b.dt.compareTo(a.dt));
      final last30 = sorted.take(30).toList();
      if (last30.length >= 2) {
        final oldest = last30.last.mv;
        final newest = last30.first.mv;
        final change = newest - oldest;
        final pct = oldest > 0 ? (change / oldest * 100.0) : 0.0;
        buffer.writeln(
          'Marktwert letzte 30 Einträge: ${_formatEuro(oldest)} → ${_formatEuro(newest)} '
          '(${change >= 0 ? '+' : ''}${_formatEuro(change)}, ${pct.toStringAsFixed(1)}%)',
        );
      }
    }
    buffer.writeln();

    buffer.writeln('=== STATUS ===');
    buffer.writeln('Spielerstatus: ${_statusName(player.status)}');
    buffer.writeln('Stammspieler-Indikator (stl): ${player.stl}');
    if (ligainsiderData != null) {
      buffer.writeln();
      buffer.writeln('=== LIGAINSIDER-DATEN ===');
      buffer.writeln('Verletzungsstatus: ${ligainsiderData.injuryStatus}');
      if (ligainsiderData.injuryDescription != null) {
        buffer.writeln('Details: ${ligainsiderData.injuryDescription}');
      }
      if (ligainsiderData.formRating != null) {
        buffer.writeln('Formrating: ${ligainsiderData.formRating}/5');
      }
      if (ligainsiderData.expectedReturn != null) {
        buffer.writeln('Erwartete Rückkehr: ${ligainsiderData.expectedReturn}');
      }
      if (ligainsiderData.statusText != null) {
        buffer.writeln('Statustext: ${ligainsiderData.statusText}');
      }
    }

    if (compactFixtureContext != null) {
      buffer.writeln();
      buffer.writeln('=== NÄCHSTE 3 SPIELE ===');
      buffer.writeln(
        'Je niedriger der Tabellenplatz des Gegners, desto schwerer das Spiel:',
      );
      buffer.writeln(compactFixtureContext);
    }

    if (compactLineupContext != null) {
      buffer.writeln();
      buffer.writeln('=== TEAM-ANALYSE ===');
      buffer.writeln(compactLineupContext);
    }

    if (limitedSwapCandidates != null &&
        limitedSwapCandidates.isNotEmpty &&
        player.userOwnsPlayer) {
      buffer.writeln();
      buffer.writeln('=== TAUSCHKANDIDATEN (gleiche Position, verfügbar) ===');
      buffer.writeln(
        'Überlege, ob ein Tausch von ${player.firstName} ${player.lastName} '
        'gegen einen der folgenden Spieler sinnvoll wäre. '
        'Falls ja, setze swapCandidateId und swapCandidateName. '
        'Falls kein Tausch empfehlenswert ist, lass beide Felder weg.',
      );
      for (final c in limitedSwapCandidates) {
        buffer.writeln(
          '  - ID:${c.id} | ${c.firstName} ${c.lastName} | '
          '${c.teamName} | Ø ${c.averagePoints.toStringAsFixed(1)} Pkt | '
          '${_formatEuro(c.marketValue)} | Status: ${_statusName(c.status)}',
        );
      }
    }

    buffer.writeln();
    buffer.writeln(
      'Antworte AUSSCHLIESSLICH als JSON gemäß dem Schema: '
      '{"score": <0-100>, "action": "strong-buy"|"buy"|"hold"|"sell"|"strong-sell", '
      '"reason": "<detaillierte Begründung mit konkreten Zahlen>", "confidence": <0-1>, '
      '"estimatedValue": <geschätzter Marktwert>, "category": "...", '
      '"swapCandidateId": "..." (optional), "swapCandidateName": "..." (optional)}',
    );
    buffer.writeln();
    buffer.writeln('SCORE-BERECHNUNG (Positionsspezifisch, Basisscore = 50):');
    buffer.writeln();

    // Positionsspezifische Form-Bewertung
    buffer.writeln('--- FORM (letzte 5 Spiele, Ø Punkte) ---');
    if (position == 1) {
      buffer.writeln(
        '  Torwart: Ø > 7 Pkt → +18 | Ø 5-7 → +8 | Ø 3-5 → 0 | Ø < 3 → -15',
      );
    } else if (position == 2) {
      buffer.writeln(
        '  Abwehr:   Ø > 8 Pkt → +18 | Ø 6-8 → +8 | Ø 4-6 → 0 | Ø < 4 → -15',
      );
    } else if (position == 3) {
      buffer.writeln(
        '  Mittelfeld: Ø > 9 Pkt → +18 | Ø 7-9 → +8 | Ø 5-7 → 0 | Ø < 5 → -15',
      );
    } else if (position == 4) {
      buffer.writeln(
        '  Sturm:    Ø > 10 Pkt → +18 | Ø 8-10 → +8 | Ø 6-8 → 0 | Ø < 6 → -15',
      );
    } else {
      buffer.writeln(
        '  Unbekannt: Ø > 8 Pkt → +15 | Ø 6-8 → +5 | Ø 4-6 → 0 | Ø < 4 → -10',
      );
    }

    buffer.writeln('--- NÄCHSTER GEGNER (Tabellenplatz) ---');
    buffer.writeln(
      '  Platz 1-4 (Top-Team) → -15 | Platz 5-8 → -8 | Platz 9-13 → +5 | Platz 14-18 → +15',
    );

    buffer.writeln('--- MARKTWERT-TREND (letzte 30 Einträge) ---');
    buffer.writeln(
      '  > +15% → +12 | +10-15% → +8 | +5-10% → +5 | +0-5% → +2 | ±0% → 0',
    );
    buffer.writeln('  -0-5% → -3 | -5-10% → -8 | -10-15% → -12 | < -15% → -20');

    buffer.writeln('--- STATUS & VERFÜGBARKEIT ---');
    buffer.writeln(
      '  Fit → +10 | Fraglich/ Aufbautraining → -8 | Verletzt → -35 | Gesperrt → -40 | Krank → -30',
    );

    buffer.writeln('--- STAMMSPIELER-INDIKATOR (stl) ---');
    buffer.writeln(
      '  stl = 3 → +10 | stl = 2 → +5 | stl = 1 → 0 | stl = 0 → -15',
    );

    buffer.writeln('--- HEIM/AUSWÄRTS-LEISTUNG ---');
    buffer.writeln(
      '  Heim-Ø > Auswärts-Ø → +5 | Heim-Ø = Auswärts-Ø → 0 | Heim-Ø < Auswärts-Ø → -5',
    );

    buffer.writeln();
    buffer.writeln('WICHTIG:');
    buffer.writeln(
      '  • score = 0-20 = strong-sell, 21-40 = sell, 41-60 = hold, 61-80 = buy, 81-100 = strong-buy',
    );
    buffer.writeln(
      '  • reason MUSS konkrete Zahlen aus den Daten enthalten (z.B. "Ø 9,2 Pkt in letzten 5 Spielen")',
    );
    buffer.writeln(
      '  • Vergleiche den Spieler mit typischen Werten für seine Position',
    );
    buffer.writeln(
      '  • Sehr gute Spieler einer Position müssen score > 75 erreichen',
    );
    buffer.writeln(
      '  • Sehr schlechte Spieler einer Position müssen score < 25 erreichen',
    );
    buffer.writeln(
      '  • Nutze alle verfügbaren Daten für eine differenzierte Bewertung',
    );
    buffer.writeln(
      '  • JEDER Spieler muss einen UNTERSCHIEDLICHEN Score erhalten - keine Duplikate!',
    );
    buffer.writeln();
    buffer.writeln(
      player.userOwnsPlayer
          ? "Analyse als BESITZER: Lohnt sich Halten oder Verkauf? Begründe mit Marktchancen."
          : "Analyse als KÄUFER: Lohnt sich die Investition? Begründe mit Potenzial.",
    );

    return buffer.toString();
  }

  String _buildBatchPrompt(List<PlayerAnalysisInput> players) {
    final buffer = StringBuffer();

    buffer.writeln(
      'Du bist ein Kickbase-Experte. Analysiere die folgende LISTE von Spielern und gib '
      'für JEDEN eine INDIVIDUELLE, UNTERSCHIEDLICHE Empfehlung zurück.',
    );
    buffer.writeln();
    buffer.writeln(
      'WICHTIG: Vergleiche die Spieler untereinander und differenziere die Scores deutlich. '
      'Spieler mit besseren Daten müssen deutlich höhere Scores erhalten. '
      'Nutze die Position jedes Spielers für die Bewertung.',
    );
    buffer.writeln();
    buffer.writeln(
      'Antworte AUSSCHLIESSLICH als JSON-Objekt mit Spieler-ID als Key:',
    );
    buffer.writeln(
      '{"playerId1": {"score": X, "action": "...", "reason": "...", "confidence": 0.0-1.0, "estimatedValue": 12345678, "category": "..."}, "playerId2": {...}, ...}',
    );
    buffer.writeln(
      'Jeder Spieler-Eintrag soll score, action, reason, confidence, estimatedValue und category enthalten.',
    );
    buffer.writeln();
    buffer.writeln('SCORE-BERECHNUNG (Positionsspezifisch, Basisscore = 50):');
    buffer.writeln(
      '  Torwart:   Ø > 7 → +18 | Ø 5-7 → +8 | Ø 3-5 → 0 | Ø < 3 → -15',
    );
    buffer.writeln(
      '  Abwehr:    Ø > 8 → +18 | Ø 6-8 → +8 | Ø 4-6 → 0 | Ø < 4 → -15',
    );
    buffer.writeln(
      '  Mittelfeld: Ø > 9 → +18 | Ø 7-9 → +8 | Ø 5-7 → 0 | Ø < 5 → -15',
    );
    buffer.writeln(
      '  Sturm:     Ø > 10 → +18 | Ø 8-10 → +8 | Ø 6-8 → 0 | Ø < 6 → -15',
    );
    buffer.writeln(
      '  Gegner:    Platz 1-4 → -15 | Platz 5-8 → -8 | Platz 9-13 → +5 | Platz 14-18 → +15',
    );
    buffer.writeln(
      '  MW-Trend:  > +15% → +12 | +10-15% → +8 | +5-10% → +5 | -5-10% → -8 | < -15% → -20',
    );
    buffer.writeln(
      '  Status:    Fit → +10 | Fraglich → -8 | Verletzt → -35 | Gesperrt → -40',
    );
    buffer.writeln('  stl:       3 → +10 | 2 → +5 | 1 → 0 | 0 → -15');
    buffer.writeln();
    buffer.writeln(
      ' score = 0-20 = strong-sell, 21-40 = sell, 41-60 = hold, 61-80 = buy, 81-100 = strong-buy',
    );
    buffer.writeln(
      ' reason MUSS konkrete Zahlen enthalten. Keine generischen Floskeln.',
    );
    buffer.writeln(
      ' JEDER Spieler muss einen UNTERSCHIEDLICHEN Score erhalten!',
    );
    buffer.writeln();
    buffer.writeln('=== SPIELER-DATEN (als Objekt nach Spieler-ID) ===');
    buffer.writeln();

    // Strukturierte Daten als JSON-Objekt mit Spieler-ID als Key
    final playersData = <String, Map<String, dynamic>>{};
    for (final input in players) {
      final p = input.player;
      final playerData = <String, dynamic>{
        'name': '${p.firstName} ${p.lastName}'.trim(),
        'positionName': _positionName(p.position),
        'team': p.teamName,
        'userOwnsPlayer': p.userOwnsPlayer,
        'averagePoints': p.averagePoints,
        'totalPoints': p.totalPoints,
        'marketValue': p.marketValue,
        'statusName': _statusName(p.status),
      };

      if (input.nextOpponent != null && input.nextOpponent!.isNotEmpty) {
        playerData['nextOpponent'] = input.nextOpponent;
      }
      if (input.nextOpponentTablePosition != null) {
        playerData['nextOpponentTablePosition'] =
            input.nextOpponentTablePosition;
      }
      if (input.ownTeamTablePosition != null) {
        playerData['ownTeamTablePosition'] = input.ownTeamTablePosition;
      }
      if (input.nextMatchLocation != null &&
          input.nextMatchLocation!.isNotEmpty) {
        playerData['nextMatchLocation'] = input.nextMatchLocation;
      }

      // Recent performances
      if (input.recentPerformances != null &&
          input.recentPerformances!.isNotEmpty) {
        final lastGames = input.recentPerformances!.take(3).toList();
        playerData['recentPerformances'] = lastGames
            .map(
              (perf) => {
                'day': perf.day,
                'points': perf.p,
                'match': '${perf.t1} vs ${perf.t2}',
                'score': '${perf.t1g}:${perf.t2g}',
                'cards': perf.k?.length ?? 0,
              },
            )
            .toList();

        // Calculate home/away averages
        final playerTeam = p.teamName;
        final homeGames = lastGames
            .where((perf) => perf.t1 == playerTeam)
            .toList();
        final awayGames = lastGames
            .where((perf) => perf.t2 == playerTeam)
            .toList();
        if (homeGames.isNotEmpty) {
          final homeAvg =
              homeGames.fold<double>(0.0, (s, perf) => s + (perf.p ?? 0)) /
              homeGames.length;
          playerData['homeAvg'] = homeAvg;
        }
        if (awayGames.isNotEmpty) {
          final awayAvg =
              awayGames.fold<double>(0.0, (s, perf) => s + (perf.p ?? 0)) /
              awayGames.length;
          playerData['awayAvg'] = awayAvg;
        }
      }

      // Market value history
      if (input.marketValueHistory != null &&
          input.marketValueHistory!.isNotEmpty) {
        final sorted = [...input.marketValueHistory!]
          ..sort((a, b) => b.dt.compareTo(a.dt));
        final last30 = sorted.take(30).toList();
        if (last30.length >= 2) {
          final oldest = last30.last.mv;
          final newest = last30.first.mv;
          final change = newest - oldest;
          final pct = oldest > 0 ? (change / oldest * 100.0) : 0.0;
          playerData['marketValueChange'] = {
            'absolute': change,
            'percentage': pct,
            'oldValue': oldest,
            'newValue': newest,
          };
        }
      }

      // Ligainsider data
      if (input.ligainsiderData != null) {
        final li = input.ligainsiderData!;
        playerData['ligainsider'] = {
          'injuryStatus': li.injuryStatus,
          'formRating': li.formRating,
          'expectedReturn': li.expectedReturn?.toIso8601String(),
          'statusText': li.statusText,
        };
      }

      // Fixture context
      if (input.fixtureContext != null && input.fixtureContext!.isNotEmpty) {
        playerData['nextFixtures'] = _compactContext(
          input.fixtureContext,
          maxLines: 2,
          maxLength: 180,
        );
      }

      // Swap candidates
      if (input.swapCandidates != null &&
          input.swapCandidates!.isNotEmpty &&
          p.userOwnsPlayer) {
        playerData['swapCandidates'] = input.swapCandidates!
            .take(2)
            .map(
              (c) => {
                'id': c.id,
                'name': '${c.firstName} ${c.lastName}'.trim(),
                'team': c.teamName,
                'averagePoints': c.averagePoints,
                'marketValue': c.marketValue,
                'status': _statusName(c.status),
              },
            )
            .toList();
      }

      playersData[p.id] = playerData;
    }

    buffer.writeln(jsonEncode(playersData));
    buffer.writeln();
    buffer.writeln(
      'Analysiere JEDEN Spieler individuell und gib unterschiedliche Scores zurück.',
    );

    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Formatierungen
  // ---------------------------------------------------------------------------

  String _positionName(int position) => switch (position) {
    1 => 'Torwart',
    2 => 'Abwehr',
    3 => 'Mittelfeld',
    4 => 'Sturm',
    _ => 'Unbekannt',
  };

  String _statusName(int status) => switch (status) {
    0 => 'Fit',
    1 => 'Verletzt',
    2 => 'Angeschlagen',
    4 => 'Aufbautraining',
    8 => 'Gesperrt',
    16 => 'Krank',
    32 => 'Gelbsperre',
    256 => 'Abwesend',
    _ => 'Status $status',
  };

  String _trendName(int trend) => switch (trend) {
    1 => 'steigend ↑',
    0 => 'neutral →',
    -1 => 'fallend ↓',
    _ => 'unbekannt',
  };

  String _formatEuro(int value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M €';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K €';
    }
    return '$value €';
  }

  static _PlayerAvailabilityIssue? _resolveAvailabilityIssue({
    required Player player,
    LigainsiderPlayer? ligainsiderData,
  }) {
    final statusText = [
      ligainsiderData?.injuryStatus,
      ligainsiderData?.statusText,
      ligainsiderData?.injuryDescription,
    ].whereType<String>().join(' ').toLowerCase();

    if (_absenceStatuses.contains(player.status) ||
        _containsAny(statusText, _absenceKeywords)) {
      return const _PlayerAvailabilityIssue(
        label: 'abwesend',
        summary: 'Abwesenheit',
      );
    }

    if (_suspensionStatuses.contains(player.status) ||
        _containsAny(statusText, _suspensionKeywords)) {
      return const _PlayerAvailabilityIssue(
        label: 'gesperrt',
        summary: 'Sperre',
      );
    }

    if (_injuryStatuses.contains(player.status) ||
        _containsAny(statusText, _injuryKeywords)) {
      return const _PlayerAvailabilityIssue(
        label: 'verletzt',
        summary: 'Verletzung',
      );
    }

    return null;
  }

  static bool _containsAny(String value, Set<String> keywords) {
    if (value.isEmpty) {
      return false;
    }
    return keywords.any(value.contains);
  }

  MistralRecommendationResult? _buildLocalShortcutRecommendation({
    required Player player,
    LigainsiderPlayer? ligainsiderData,
  }) {
    final issue = _resolveAvailabilityIssue(
      player: player,
      ligainsiderData: ligainsiderData,
    );
    if (issue == null) {
      return null;
    }

    final detail =
        ligainsiderData?.injuryDescription ??
        ligainsiderData?.statusText ??
        ligainsiderData?.injuryStatus;
    final detailSuffix = detail == null || detail.isEmpty
        ? ''
        : ' Hinweis: $detail.';
    final playerName = '${player.firstName} ${player.lastName}'.trim();

    return MistralRecommendationResult(
      score: 5,
      action: 'strong-sell',
      reason:
          '$playerName ist aktuell ${issue.label} und wird lokal ohne Mistral direkt '
          'als Verkaufskandidat eingestuft.'
          '$detailSuffix ${issue.summary} senkt die kurzfristige '
          'Einsetzbarkeit deutlich.',
      confidence: 0.98,
      estimatedValue: player.marketValue,
      category: 'strong-sell',
    );
  }

  String? _compactContext(
    String? value, {
    required int maxLines,
    required int maxLength,
  }) {
    if (value == null) {
      return null;
    }

    final normalized = value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .take(maxLines)
        .join(' | ');
    if (normalized.isEmpty) {
      return null;
    }
    if (normalized.length <= maxLength) {
      return normalized;
    }
    return '${normalized.substring(0, maxLength - 1)}…';
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      _debugLogger(message);
    }
  }

  void _logPrompt(String prompt, {required String label}) {
    _logDebug('📝 MISTRAL PROMPT [$label] START');
    _logDebug(prompt);
    _logDebug('📝 MISTRAL PROMPT [$label] END');
  }

  void _pruneExpiredCache() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }
}

/// Cache-Eintrag für Empfehlungen
class _CacheEntry {
  final MistralRecommendationResult result;
  final DateTime expiry;

  _CacheEntry(this.result, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}

class _PlayerAvailabilityIssue {
  final String label;
  final String summary;

  const _PlayerAvailabilityIssue({required this.label, required this.summary});
}

/// Input-Datenstruktur für Batch-Analyse.
class PlayerAnalysisInput {
  final Player player;
  final List<MarketValueEntry>? marketValueHistory;
  final List<MatchPerformance>? recentPerformances;
  final LigainsiderPlayer? ligainsiderData;
  final String? fixtureContext;
  final String? lineupContext;
  final List<Player>? swapCandidates;
  final String? nextOpponent;
  final int? nextOpponentTablePosition;
  final int? ownTeamTablePosition;
  final String? nextMatchLocation;

  const PlayerAnalysisInput({
    required this.player,
    this.marketValueHistory,
    this.recentPerformances,
    this.ligainsiderData,
    this.fixtureContext,
    this.lineupContext,
    this.swapCandidates,
    this.nextOpponent,
    this.nextOpponentTablePosition,
    this.ownTeamTablePosition,
    this.nextMatchLocation,
  });
}

// Result, Success, Failure Typen werden aus repository_interfaces.dart importiert
