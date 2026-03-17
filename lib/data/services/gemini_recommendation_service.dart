import 'dart:convert';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/repository_interfaces.dart';
import '../models/player_model.dart';
import '../models/market_value_model.dart';
import '../models/performance_model.dart';
import '../models/ligainsider_model.dart';

/// Ergebnis einer KI-Empfehlung von Gemini
class GeminiRecommendationResult {
  final double score;
  final String action;
  final String reason;
  final double confidence;
  final int estimatedValue;
  final String category;
  final String? swapCandidateId;
  final String? swapCandidateName;

  const GeminiRecommendationResult({
    required this.score,
    required this.action,
    required this.reason,
    required this.confidence,
    required this.estimatedValue,
    required this.category,
    this.swapCandidateId,
    this.swapCandidateName,
  });

  factory GeminiRecommendationResult.fromJson(Map<String, dynamic> json) {
    final score = (json['score'] as num).toDouble().clamp(0.0, 100.0);
    return GeminiRecommendationResult(
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
}

/// Service für KI-gestützte Spielerempfehlungen via Firebase Vertex AI (Gemini).
///
/// Analysiert Spielerdaten (Punkte, Marktwert-Verlauf, Status, Form) und
/// gibt strukturierte Kauf-/Verkaufsempfehlungen auf Deutsch zurück.
///
/// Verwendung:
/// ```dart
/// final service = GeminiRecommendationService();
/// final result = await service.generateRecommendation(
///   player: player,
///   marketValueHistory: history,
///   recentPerformances: performances,
///   ligainsiderData: ligainsiderPlayer,
/// );
/// ```
class GeminiRecommendationService {
  static const _model = 'gemini-2.5-flash';

  /// JSON Schema für strukturierten Gemini-Output (einzelner Spieler)
  static Schema get _recommendationSchema => Schema.object(
    properties: {
      'score': Schema.number(
        description:
            'Gesamtbewertung des Spielers von 0 bis 100. '
            '0 = klar schlechte Option, 100 = klar beste Option.',
      ),
      'reason': Schema.string(
        description:
            'Begründung in 2-3 Sätzen auf Deutsch. '
            'Konkret mit Zahlen aus den Datensektionen.',
      ),
      'confidence': Schema.number(
        description:
            'Konfidenz der Empfehlung von 0.0 bis 1.0. '
            '1.0 = sehr sicher, 0.0 = sehr unsicher.',
      ),
      'estimatedValue': Schema.integer(
        description: 'Geschätzter fairer Marktwert in Euro (ganze Zahl).',
      ),
      'swapCandidateId': Schema.string(
        description:
            'ID des empfohlenen Tauschspielers. '
            'Nur setzen wenn ein Tausch klar empfehlenswert ist.',
      ),
      'swapCandidateName': Schema.string(
        description: 'Name des empfohlenen Tauschspielers.',
      ),
    },
    optionalProperties: const ['swapCandidateId', 'swapCandidateName'],
  );

  late final GenerativeModel _generativeModel;

  GeminiRecommendationService() {
    _generativeModel = FirebaseVertexAI.instance.generativeModel(
      model: _model,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: _recommendationSchema,
        temperature: 0.7,
      ),
    );
  }

  /// Generiert eine KI-Empfehlung für einen Spieler.
  ///
  /// [player] Die Stammdaten des Spielers.
  /// [marketValueHistory] Die Marktwert-Zeitreihe (optional, verbessert Analyse).
  /// [recentPerformances] Die letzten Spieltag-Leistungen (optional).
  /// [ligainsiderData] Ligainsider-Verletzungs- und Formstatus (optional).
  ///
  /// Returns [Result<GeminiRecommendationResult>] – niemals Exceptions.
  Future<Result<GeminiRecommendationResult>> generateRecommendation({
    required Player player,
    List<MarketValueEntry>? marketValueHistory,
    List<MatchPerformance>? recentPerformances,
    LigainsiderPlayer? ligainsiderData,
    String? fixtureContext,
    String? lineupContext,
    List<Player>? swapCandidates,
  }) async {
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
      debugPrint('📤 GEMINI REQUEST (Einzelspieler)');
      debugPrint('══════════════════════════════════════════════════');
      debugPrint(prompt);
      debugPrint('══════════════════════════════════════════════════\n');

      final response = await _generativeModel.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text;
      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('📥 GEMINI RESPONSE (Einzelspieler)');
      debugPrint('══════════════════════════════════════════════════');
      debugPrint(text ?? '(null)');
      debugPrint('══════════════════════════════════════════════════\n');

      if (text == null || text.isEmpty) {
        return const Failure(
          'Gemini hat keine Antwort zurückgegeben.',
          code: 'empty_response',
        );
      }

      final Map<String, dynamic> json = jsonDecode(text);
      final result = GeminiRecommendationResult.fromJson(json);

      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('✅ GEMINI PARSED (${player.firstName} ${player.lastName})');
      debugPrint('  score      : ${result.score}');
      debugPrint('  action     : ${result.action}');
      debugPrint('  category   : ${result.category}');
      debugPrint('  confidence : ${result.confidence}');
      debugPrint('  estValue   : ${result.estimatedValue}');
      debugPrint('  swap       : ${result.swapCandidateName ?? "-"}');
      debugPrint('  reason     : ${result.reason}');
      debugPrint('══════════════════════════════════════════════════\n');

      return Success(result);
    } on FormatException catch (e) {
      debugPrint('❌ GEMINI JSON PARSE ERROR: $e');
      return Failure(
        'Gemini-Antwort konnte nicht geparst werden: $e',
        code: 'parse_error',
      );
    } on Exception catch (e) {
      debugPrint('❌ GEMINI EXCEPTION: $e');
      return Failure(
        'KI-Analyse fehlgeschlagen: ${e.toString()}',
        code: 'gemini_error',
        exception: e,
      );
    } catch (e) {
      debugPrint('❌ GEMINI UNKNOWN ERROR: $e');
      return Failure(
        'Unerwarteter Fehler bei der KI-Analyse: $e',
        code: 'unknown_error',
      );
    }
  }

  /// Generiert Empfehlungen für mehrere Spieler in einem einzigen API-Aufruf.
  ///
  /// Schickt alle Spielerdaten in einem Prompt und erwartet eine JSON-Map
  /// von Spieler-ID → Empfehlung zurück.
  ///
  /// [players] Liste der Spieler mit jeweils optionalen Zusatzdaten.
  /// Returns [Result<Map<String, GeminiRecommendationResult>>].
  Future<Result<Map<String, GeminiRecommendationResult>>>
  generateBatchRecommendations({
    required List<PlayerAnalysisInput> players,
  }) async {
    try {
      final prompt = _buildBatchPrompt(players);

      // Für Batch: freies JSON ohne streng erzwungenes Schema,
      // da Gemini bei variablen Map-Keys besser ohne responseSchema arbeitet.
      final batchModel = FirebaseVertexAI.instance.generativeModel(
        model: _model,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.7,
        ),
      );

      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('📤 GEMINI REQUEST (Batch – ${players.length} Spieler)');
      debugPrint('══════════════════════════════════════════════════');
      debugPrint(prompt);
      debugPrint('══════════════════════════════════════════════════\n');

      final response = await batchModel.generateContent([Content.text(prompt)]);

      final text = response.text;
      debugPrint('\n══════════════════════════════════════════════════');
      debugPrint('📥 GEMINI RESPONSE (Batch)');
      debugPrint('══════════════════════════════════════════════════');
      debugPrint(text ?? '(null)');
      debugPrint('══════════════════════════════════════════════════\n');

      if (text == null || text.isEmpty) {
        return const Failure(
          'Gemini hat keine Antwort zurückgegeben.',
          code: 'empty_response',
        );
      }

      final Map<String, dynamic> rawJson = jsonDecode(text);
      final results = <String, GeminiRecommendationResult>{};
      for (final entry in rawJson.entries) {
        results[entry.key] = GeminiRecommendationResult.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return Success(results);
    } on Exception catch (e) {
      return Failure(
        'Batch-KI-Analyse fehlgeschlagen: ${e.toString()}',
        code: 'gemini_batch_error',
        exception: e,
      );
    } catch (e) {
      return Failure(
        'Unerwarteter Fehler bei der Batch-Analyse: $e',
        code: 'unknown_error',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Private Helper: Prompt-Aufbau
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
          '${perf.k != null && perf.k!.isNotEmpty ? ', ${perf.k!.length} Karte(n)' : ''}',
        );
      }

      // Heim/Auswärts-Bilanz aus den Performance-Daten ableiten
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

          // Nächstes Spiel Heim oder Auswärts?
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
