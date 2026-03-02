import 'dart:convert';
import 'package:firebase_vertexai/firebase_vertexai.dart';
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

  const GeminiRecommendationResult({
    required this.score,
    required this.action,
    required this.reason,
    required this.confidence,
    required this.estimatedValue,
    required this.category,
  });

  factory GeminiRecommendationResult.fromJson(Map<String, dynamic> json) {
    return GeminiRecommendationResult(
      score: (json['score'] as num).toDouble().clamp(0.0, 100.0),
      action: json['action'] as String? ?? 'hold',
      reason: json['reason'] as String? ?? '',
      confidence: (json['confidence'] as num).toDouble().clamp(0.0, 1.0),
      estimatedValue: (json['estimatedValue'] as num).toInt(),
      category: json['category'] as String? ?? 'general',
    );
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
  static const _model = 'gemini-2.0-flash';

  /// JSON Schema für strukturierten Gemini-Output (einzelner Spieler)
  static Schema get _recommendationSchema => Schema.object(
    properties: {
      'score': Schema.number(
        description:
            'Gesamtbewertung des Spielers von 0 bis 100. '
            '0 = klarer Verkauf, 100 = klarer Kauf.',
      ),
      'action': Schema.enumString(
        enumValues: ['buy', 'strong-buy', 'sell', 'strong-sell', 'hold'],
        description: 'Empfohlene Aktion',
      ),
      'reason': Schema.string(
        description:
            'Begründung der Empfehlung in 2-3 Sätzen auf Deutsch. '
            'Konkret und auf Kickbase-Kontext bezogen.',
      ),
      'confidence': Schema.number(
        description:
            'Konfidenz der Empfehlung von 0.0 bis 1.0. '
            '1.0 = sehr sicher, 0.0 = sehr unsicher.',
      ),
      'estimatedValue': Schema.integer(
        description: 'Geschätzter fairer Marktwert in Euro (ganze Zahl).',
      ),
      'category': Schema.enumString(
        enumValues: ['strong-buy', 'buy', 'general', 'sell', 'strong-sell'],
        description: 'Kategorie der Empfehlung',
      ),
    },
    // Alle Properties sind Pflicht – optionalProperties leer lassen
    optionalProperties: const [],
  );

  late final GenerativeModel _generativeModel;

  GeminiRecommendationService() {
    _generativeModel = FirebaseVertexAI.instance.generativeModel(
      model: _model,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: _recommendationSchema,
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
  }) async {
    try {
      final prompt = _buildPrompt(
        player: player,
        marketValueHistory: marketValueHistory,
        recentPerformances: recentPerformances,
        ligainsiderData: ligainsiderData,
      );

      final response = await _generativeModel.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text;
      if (text == null || text.isEmpty) {
        return const Failure(
          'Gemini hat keine Antwort zurückgegeben.',
          code: 'empty_response',
        );
      }

      final Map<String, dynamic> json = jsonDecode(text);
      final result = GeminiRecommendationResult.fromJson(json);
      return Success(result);
    } on Exception catch (e) {
      return Failure(
        'KI-Analyse fehlgeschlagen: ${e.toString()}',
        code: 'gemini_error',
        exception: e,
      );
    } catch (e) {
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
        ),
      );

      final response = await batchModel.generateContent([Content.text(prompt)]);

      final text = response.text;
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
  }) {
    final buffer = StringBuffer();

    buffer.writeln(
      'Du bist ein Kickbase-Experte und analysierst Spieler für Fantasy-Football-Empfehlungen. '
      'Gib eine fundierte Kaufs- oder Verkaufsempfehlung für folgenden Spieler auf Basis der Daten.',
    );
    buffer.writeln();
    buffer.writeln('=== SPIELER-STAMMDATEN ===');
    buffer.writeln('Name: ${player.firstName} ${player.lastName}');
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
      buffer.writeln(
        'Verletzungsstatus: ${ligainsiderData.injuryStatus ?? "unbekannt"}',
      );
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
    buffer.writeln();

    buffer.writeln(
      'Antworte ausschließlich als JSON gemäß dem vorgegebenen Schema. '
      'score=0 bedeutet klarer Verkauf, score=100 klarer Kauf. '
      'Die reason-Begründung soll konkret, auf Kickbase bezogen und auf Deutsch sein.',
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

  const PlayerAnalysisInput({
    required this.player,
    this.marketValueHistory,
    this.recentPerformances,
    this.ligainsiderData,
  });
}
