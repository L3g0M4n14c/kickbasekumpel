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
      confidence: (json['confidence'] as num).toDouble().clamp(0.0, 1.0),
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

/// Service für KI-gestützte Spielerempfehlungen via Mistral API.
///
/// Analysiert Spielerdaten (Punkte, Marktwert-Verlauf, Status, Form) und
/// gibt strukturierte Kauf-/Verkaufsempfehlungen auf Deutsch zurück.
///
/// Ergebnisse werden NICHT in Firestore gespeichert, sondern direkt
/// an den Client zurückgegeben.
///
/// Verwendung:
/// ```dart
/// final service = MistralRecommendationService(apiKey: 'YOUR_KEY');
/// final result = await service.generateRecommendation(
///   player: player,
///   marketValueHistory: history,
///   recentPerformances: performances,
///   ligainsiderData: ligainsiderPlayer,
/// );
/// ```
class MistralRecommendationService {
  static const _model = 'mistral-small-latest';
  static const _baseUrl = 'https://api.mistral.ai/v1';
  static const _cacheTtl = Duration(hours: 2);

  final String _apiKey;
  final Map<String, _CacheEntry> _cache = {};

  MistralRecommendationService({required String apiKey}) : _apiKey = apiKey;

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

    // Cache prüfen
    if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      debugPrint('✅ MISTRAL CACHE HIT: ${player.firstName} ${player.lastName}');
      return Success(_cache[cacheKey]!.result);
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

      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('📤 MISTRAL REQUEST (Einzelspieler)');
      debugPrint('══════════════════════════════════════════════════');
      debugPrint(prompt);
      debugPrint('══════════════════════════════════════════════════\n');

      final response = await _callMistralApi(prompt);

      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('📥 MISTRAL RESPONSE (Einzelspieler)');
      debugPrint('══════════════════════════════════════════════════');
      debugPrint(response ?? '(null)');
      debugPrint('══════════════════════════════════════════════════\n');

      if (response == null || response.isEmpty) {
        return const Failure(
          'Mistral hat keine Antwort zurückgegeben.',
          code: 'empty_response',
        );
      }

      // Mistral gibt direkt JSON zurück (mit response_format: json_object)
      final Map<String, dynamic> json = jsonDecode(response);
      final result = MistralRecommendationResult.fromJson(json);

      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('✅ MISTRAL PARSED (${player.firstName} ${player.lastName})');
      debugPrint('  score      : ${result.score}');
      debugPrint('  action     : ${result.action}');
      debugPrint('  category   : ${result.category}');
      debugPrint('  confidence : ${result.confidence}');
      debugPrint('  estValue   : ${result.estimatedValue}');
      debugPrint('  swap       : ${result.swapCandidateName ?? "-"}');
      debugPrint('  reason     : ${result.reason}');
      debugPrint('══════════════════════════════════════════════════\n');

      // In Cache speichern
      _cache[cacheKey] = _CacheEntry(result, DateTime.now().add(_cacheTtl));

      return Success(result);
    } on FormatException catch (e) {
      debugPrint('❌ MISTRAL JSON PARSE ERROR: $e');
      return Failure(
        'Mistral-Antwort konnte nicht geparst werden: $e',
        code: 'parse_error',
      );
    } on Exception catch (e) {
      debugPrint('❌ MISTRAL EXCEPTION: $e');
      return Failure(
        'KI-Analyse fehlgeschlagen: ${e.toString()}',
        code: 'mistral_error',
        exception: e,
      );
    } catch (e) {
      debugPrint('❌ MISTRAL UNKNOWN ERROR: $e');
      return Failure(
        'Unerwarteter Fehler bei der KI-Analyse: $e',
        code: 'unknown_error',
      );
    }
  }

  /// Generiert Empfehlungen für mehrere Spieler in einem einzigen API-Aufruf.
  ///
  /// [players] Liste der Spieler mit jeweils optionalen Zusatzdaten.
  /// Returns [Result<Map<String, MistralRecommendationResult>>].
  Future<Result<Map<String, MistralRecommendationResult>>> generateBatchRecommendations({
    required List<PlayerAnalysisInput> players,
  }) async {
    // Für Batch: Cache pro Spieler prüfen
    final uncachedPlayers = <PlayerAnalysisInput>[];
    final cachedResults = <String, MistralRecommendationResult>{};

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
        cachedResults[input.player.id] = _cache[cacheKey]!.result;
      } else {
        uncachedPlayers.add(input);
      }
    }

    // Alle gecachten Ergebnisse bereits hinzufügen
    final results = Map<String, MistralRecommendationResult>.from(cachedResults);

    // Nur nicht-gecachte Spieler verarbeiten
    if (uncachedPlayers.isNotEmpty) {
      try {
        final prompt = _buildBatchPrompt(uncachedPlayers);

        debugPrint('\n══════════════════════════════════════════════════');
        debugPrint('📤 MISTRAL REQUEST (Batch – ${uncachedPlayers.length} Spieler)');
        debugPrint('══════════════════════════════════════════════════');
        debugPrint(prompt);
        debugPrint('══════════════════════════════════════════════════\n');

        final response = await _callMistralApi(prompt);

        debugPrint('\n══════════════════════════════════════════════════');
        debugPrint('📥 MISTRAL RESPONSE (Batch)');
        debugPrint('══════════════════════════════════════════════════');
        debugPrint(response ?? '(null)');
        debugPrint('══════════════════════════════════════════════════\n');

        if (response == null || response.isEmpty) {
          return Failure(
            'Mistral hat keine Antwort zurückgegeben.',
            code: 'empty_response',
          );
        }

        // Mistral gibt JSON-Objekt mit Spieler-IDs als Keys zurück
        final Map<String, dynamic> rawJson = jsonDecode(response);

        for (final entry in rawJson.entries) {
          final playerId = entry.key;
          final result = MistralRecommendationResult.fromJson(
            entry.value as Map<String, dynamic>,
          );
          results[playerId] = result;

          // In Cache speichern
          final uncachedInput = uncachedPlayers.firstWhere(
            (p) => p.player.id == playerId,
            orElse: () => uncachedPlayers.first,
          );
          final cacheKey = _generateCacheKey(
            playerId: uncachedInput.player.id,
            marketValue: uncachedInput.player.marketValue,
            status: uncachedInput.player.status,
            averagePoints: uncachedInput.player.averagePoints,
            marketValueTrend: uncachedInput.player.marketValueTrend,
            stl: uncachedInput.player.stl,
            userOwnsPlayer: uncachedInput.player.userOwnsPlayer,
            recentPerformances: uncachedInput.recentPerformances,
            ligainsiderData: uncachedInput.ligainsiderData,
          );
          _cache[cacheKey] = _CacheEntry(result, DateTime.now().add(_cacheTtl));
        }
      } on Exception catch (e) {
        debugPrint('❌ MISTRAL BATCH EXCEPTION: $e');
        return Failure(
          'Batch-KI-Analyse fehlgeschlagen: ${e.toString()}',
          code: 'mistral_batch_error',
          exception: e,
        );
      } catch (e) {
        debugPrint('❌ MISTRAL BATCH UNKNOWN ERROR: $e');
        return Failure(
          'Unerwarteter Fehler bei der Batch-Analyse: $e',
          code: 'unknown_error',
        );
      }
    }

    return Success(results);
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Mistral API Aufruf
  // ---------------------------------------------------------------------------

  Future<String?> _callMistralApi(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'response_format': {'type': 'json_object'},
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = json['choices'] as List<dynamic>?;
        if (choices != null && choices.isNotEmpty) {
          final message = choices.first as Map<String, dynamic>?;
          return message?['message']?['content'] as String?;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Mistral API: Ungültiger API-Key (401 Unauthorized)');
      } else if (response.statusCode == 429) {
        throw Exception('Mistral API: Rate Limit erreicht (429 Too Many Requests)');
      } else {
        throw Exception(
          'Mistral API Fehler: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ MISTRAL API CALL ERROR: $e');
      rethrow;
    }
    return null;
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

    buffer.writeln(
      'Du bist ein Kickbase-Experte und analysierst Spieler für Fantasy-Football-Empfehlungen. '
      'Gib eine fundierte Kaufs- oder Verkaufsempfehlung für folgenden Spieler auf Basis der Daten.',
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
      final last5 = recentPerformances.take(5).toList();
      buffer.writeln('Letzte ${last5.length} Spieltage:');
      for (final perf in last5) {
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
      final sorted = [...marketValueHistory]..sort((a, b) => b.dt.compareTo(a.dt));
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

    if (fixtureContext != null && fixtureContext.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('=== NÄCHSTE 3 SPIELE ===');
      buffer.writeln(
        'Je niedriger der Tabellenplatz des Gegners, desto schwerer das Spiel:',
      );
      buffer.writeln(fixtureContext);
    }

    if (lineupContext != null && lineupContext.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('=== TEAM-ANALYSE ===');
      buffer.writeln(lineupContext);
    }

    if (swapCandidates != null &&
        swapCandidates.isNotEmpty &&
        player.userOwnsPlayer) {
      buffer.writeln();
      buffer.writeln('=== TAUSCHKANDIDATEN (gleiche Position, verfügbar) ===');
      buffer.writeln(
        'Überlege, ob ein Tausch von ${player.firstName} ${player.lastName} '
        'gegen einen der folgenden Spieler sinnvoll wäre. '
        'Falls ja, setze swapCandidateId und swapCandidateName. '
        'Falls kein Tausch empfehlenswert ist, lass beide Felder weg.',
      );
      for (final c in swapCandidates) {
        buffer.writeln(
          '  - ID:${c.id} | ${c.firstName} ${c.lastName} | '
          '${c.teamName} | Ø ${c.averagePoints.toStringAsFixed(1)} Pkt | '
          '${_formatEuro(c.marketValue)} | Status: ${_statusName(c.status)}',
        );
      }
    }

    buffer.writeln();
    buffer.writeln(
      'Antworte ausschließlich als JSON gemäß dem vorgegebenen Schema. '
      'score=0 = eindeutig schlechte Option, score=100 = eindeutig beste Option. '
      'Berechne den Score ausgehend von 50 mit diesen konkreten Anpassungen:\n'
      '  Form (letzte 5 Spiele): Ø > 8 Pkt → +20 | Ø 6-8 Pkt → +8 | Ø 4-6 Pkt → 0 | Ø < 4 Pkt → -20\n'
      '  Nächster Gegner: Tabellenplatz 1-4 → -15 | Platz 5-8 → -5 | Platz 9-13 → +5 | Platz 14+ → +15\n'
      '  Marktwert (letzte 30 Einträge): > +10% → +10 | +3-10% → +3 | ±3% → 0 | -3 bis -10% → -8 | < -10% → -15\n'
      '  Status: Fit → +5 | Fraglich → -10 | Verletzt/Gesperrt → -40\n'
      '  Stammspieler (stl): ≥ 2 → +8 | 1 → 0 | 0 → -10\n'
      '${player.userOwnsPlayer ? "Halte-/Verkaufsanalyse: Wann lohnt sich ein Verkauf?" : "Kaufanalyse: Lohnt sich die Investition?"}\n'
      'reason muss auf Deutsch mit konkreten Zahlen aus den obigen Sektionen begründet sein. Keine generischen Floskeln.',
    );

    return buffer.toString();
  }

  String _buildBatchPrompt(List<PlayerAnalysisInput> players) {
    final buffer = StringBuffer();
    buffer.writeln(
      'Du bist ein Kickbase-Experte. Analysiere die folgenden Spieler und gib für jeden '
      'eine Empfehlung zurück. Antworte als JSON-Objekt mit Spieler-ID als Key.',
    );
    buffer.writeln();

    for (final input in players) {
      buffer.writeln('--- Spieler-ID: ${input.player.id} ---');
      buffer.writeln(
        _buildPrompt(
          player: input.player,
          marketValueHistory: input.marketValueHistory,
          recentPerformances: input.recentPerformances,
          ligainsiderData: input.ligainsiderData,
          fixtureContext: input.fixtureContext,
          lineupContext: input.lineupContext,
          swapCandidates: input.swapCandidates,
        ),
      );
      buffer.writeln();
    }

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
    0 => 'Unbekannt',
    1 => 'Fit',
    2 => 'Verletzt',
    4 => 'Krank',
    8 => 'Gesperrt',
    16 => 'Aufbautraining',
    32 => 'Fraglich',
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
}

/// Cache-Eintrag für Empfehlungen
class _CacheEntry {
  final MistralRecommendationResult result;
  final DateTime expiry;

  _CacheEntry(this.result, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
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

  const PlayerAnalysisInput({
    required this.player,
    this.marketValueHistory,
    this.recentPerformances,
    this.ligainsiderData,
    this.fixtureContext,
    this.lineupContext,
    this.swapCandidates,
  });
}

// Result, Success, Failure Typen werden aus repository_interfaces.dart importiert
