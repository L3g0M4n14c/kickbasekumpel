import 'dart:math';

import '../models/player_model.dart';
import '../models/market_value_model.dart';
import '../models/performance_model.dart';
import '../models/ligainsider_model.dart';

/// Ein einzelnes kommendes Spiel für die Spielplan-Komponente.
class FixtureInfo {
  const FixtureInfo({
    required this.opponentName,
    this.opponentTablePosition,
    required this.isHomeGame,
  });

  final String opponentName;

  /// Tabellenposition des Gegners (0 = unbekannt).
  final int? opponentTablePosition;
  final bool isHomeGame;
}

/// Input-Datenstruktur für die deterministische Spieleranalyse.
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

  /// Kommende Spiele (bis [DeterministicRecommendationService.maxUpcomingFixtures]).
  /// Wenn gesetzt, fließt die Gegner-Stärke gemittelt über alle Spiele ein;
  /// sonst greift der Fallback auf den nächsten Gegner.
  final List<FixtureInfo>? upcomingFixtures;

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
    this.upcomingFixtures,
  });
}

/// Ergebnis der deterministischen Empfehlungsberechnung.
class PlayerRecommendationResult {
  static const defaultConfidence = 0.5;

  /// Score 0-100 (deterministisch berechnet, vollständig nachvollziehbar).
  final double score;
  final String action;
  final String reason;
  final double confidence;
  final int estimatedValue;
  final String category;
  final String? swapCandidateId;
  final String? swapCandidateName;

  /// Einzelkomponenten des Scores für Transparenz im UI/Debugging.
  final Map<String, double> components;

  const PlayerRecommendationResult({
    required this.score,
    required this.action,
    required this.reason,
    required this.confidence,
    required this.estimatedValue,
    required this.category,
    this.swapCandidateId,
    this.swapCandidateName,
    this.components = const {},
  });

  static String actionFromScore(double score) {
    if (score >= 80) return 'strong-buy';
    if (score >= 60) return 'buy';
    if (score >= 40) return 'hold';
    if (score >= 20) return 'sell';
    return 'strong-sell';
  }

  static String categoryFromScore(double score) {
    if (score >= 80) return 'strong-buy';
    if (score >= 60) return 'buy';
    if (score >= 40) return 'general';
    if (score >= 20) return 'sell';
    return 'strong-sell';
  }
}

/// Rein deterministische Empfehlungs-Engine (kein KI-Service mehr).
///
/// Berechnet Kauf-/Verkaufsempfehlungen ausschließlich aus Fakten:
/// - Form: gewichteter Punkteschnitt der letzten Spieltage
/// - Effizienz: Punkte pro Million Marktwert
/// - Verfügbarkeit: Status-Codes (verletzt/gesperrt/abwesend) als harte Regel
/// - Spielplan: Gegner-Tabellenposition + Heim/Auswärts
/// - Marktwert-Potenzial: kurzfristiger Trend (tfhmvt) + Historien-Steigung
///
/// Alle Gewichtungen sind dokumentierte Konstanten und damit testbar
/// und erklärbar. Der Score wird auf 0-100 geklemmt.
class DeterministicRecommendationService {
  /// Basis-Score, von dem aus die Komponenten addiert/subtrahiert werden.
  static const double baseScore = 50.0;

  /// Maximaler Beitrag der Form-Komponente.
  static const double maxFormDelta = 18.0;

  /// Maximaler Beitrag der Effizienz-Komponente (Punkte pro Mio. €).
  static const double maxEfficiencyDelta = 10.0;

  /// Effizienz-Referenz: 0.6 Punkte pro Mio. Marktwert gelten als fair.
  static const double efficiencyReference = 0.6;

  /// Halbe Bandbreite um die Referenz, ab der der maximale Effizienz-Bonus
  /// bzw. -Malus erreicht ist.
  static const double efficiencyBand = 0.3;

  /// Maximaler Beitrag der Spielplan-Komponente.
  static const double maxFixtureDelta = 6.0;

  /// Heimbonus innerhalb der Spielplan-Komponente.
  static const double homeBonus = 2.0;

  /// Maximaler Beitrag des Marktwert-Potenzials (Trend + Historie).
  static const double maxValueDelta = 8.0;

  /// Punkte-Referenz der Form-Skalierung (durchschnittliche Leistung).
  static const double formReference = 5.0;

  /// Halbe Bandbreite der Form-Skalierung (Punkte über/unter Referenz,
  /// ab denen der maximale Form-Bonus/-Malus erreicht ist).
  static const double formBand = 5.0;

  /// Status-Codes für Verletzung.
  static const Set<int> injuryStatuses = {1, 2};

  /// Status-Codes für Sperre (3 = gesperrt, 8 = Sperre, 32 = Gelbsperre).
  static const Set<int> suspensionStatuses = {3, 8, 32};

  /// Status-Codes für Aufbautraining (Comeback nach Verletzung).
  static const Set<int> recoveryStatuses = {4};

  /// Status-Codes für Abwesenheit.
  static const Set<int> absenceStatuses = {256};

  /// true, wenn der Spieler nicht voll verfügbar ist (verletzt/angeschlagen,
  /// gesperrt, im Aufbautraining oder abwesend).
  static bool isUnavailable(int status) =>
      injuryStatuses.contains(status) ||
      suspensionStatuses.contains(status) ||
      recoveryStatuses.contains(status) ||
      absenceStatuses.contains(status);

  /// Wie viele Spieltage maximal in die Form einfließen.
  static const int maxFormMatchdays = 5;

  /// Wie viele Marktwert-Einträge maximal in die Historien-Steigung einfließen.
  static const int maxValueHistoryEntries = 10;

  /// Wie viele kommende Spiele maximal in die Spielplan-Bewertung einfließen.
  static const int maxUpcomingFixtures = 3;

  const DeterministicRecommendationService();

  /// Analysiert einen einzelnen Spieler.
  PlayerRecommendationResult analyze(PlayerAnalysisInput input) {
    final player = input.player;
    final components = <String, double>{};

    // 1. Verfügbarkeit als harte Regel (überschreibt alle anderen Signale).
    final availabilityLabel = _availabilityLabel(player.status);
    if (availabilityLabel != null) {
      final isOwned = player.userOwnsPlayer;
      final score = isOwned ? 8.0 : 25.0;
      final reason = StringBuffer('Verfügbarkeitsrisiko: $availabilityLabel. ');
      if (isOwned) {
        reason.write('Abgeben, solange der Marktwert noch hält.');
      } else {
        reason.write('Momentan kein Kauf empfehlenswert.');
      }
      components['availability'] = score - baseScore;
      return PlayerRecommendationResult(
        score: score,
        action: PlayerRecommendationResult.actionFromScore(score),
        reason: reason.toString(),
        confidence: _confidence(
          hasForm: false,
          hasHistory: false,
          hasFixture: false,
        ),
        estimatedValue: max(0, player.marketValue),
        category: PlayerRecommendationResult.categoryFromScore(score),
        components: components,
      );
    }

    // 2. Form (gewichteter Schnitt der letzten Spieltage, neuere zählen mehr).
    final form = _weightedForm(input.recentPerformances);
    double formDelta;
    String formSummary;
    if (form != null) {
      formDelta = _formDelta(form);
      final matchdaysUsed = _performedMatches(
        input.recentPerformances,
      ).length.clamp(0, maxFormMatchdays);
      formSummary =
          'Form: ${form.toStringAsFixed(1)} Pkt Ø letzte $matchdaysUsed Spiele';
    } else {
      formDelta = _formDelta(player.averagePoints);
      formSummary =
          'Form: ${player.averagePoints.toStringAsFixed(1)} Pkt '
          '(Saison-Schnitt, keine aktuellen Spiele)';
    }
    components['form'] = formDelta;

    // 3. Effizienz (Punkte pro Mio. € Marktwert).
    final efficiency = _efficiency(player);
    final efficiencyDelta = _efficiencyDelta(efficiency);
    components['efficiency'] = efficiencyDelta;

    // 4. Spielplan (Gegner-Stärke + Heim/Auswärts).
    final fixture = _fixtureDelta(input);
    components['fixture'] = fixture.delta;

    // 5. Marktwert-Potenzial (kurzfristiger Trend + Historien-Steigung).
    final valueDelta = _valueDelta(player, input.marketValueHistory);
    components['value'] = valueDelta;

    var score =
        (baseScore + formDelta + efficiencyDelta + fixture.delta + valueDelta)
            .clamp(0.0, 100.0);

    // 6. Tausch-Empfehlung: bester gleichpositionierter Kandidat mit
    //    deutlich besserem Saison-Schnitt.
    final swap = _bestSwapCandidate(input);
    if (swap != null) {
      score = min(100.0, score + 5.0);
      components['swap'] = 5.0;
    }

    final parts = <String>[
      formSummary,
      'Effizienz: ${efficiency.toStringAsFixed(2)} Pkt/Mio. €',
      if (fixture.summary != null) fixture.summary!,
      _valueSummary(player),
      if (swap != null)
        'Alternative: ${swap.firstName} ${swap.lastName} '
            '(${swap.averagePoints.toStringAsFixed(1)} Pkt)',
    ];

    return PlayerRecommendationResult(
      score: score,
      action: PlayerRecommendationResult.actionFromScore(score),
      reason: parts.join('. '),
      confidence: _confidence(
        hasForm: form != null,
        hasHistory: _historyEntries(input.marketValueHistory).length >= 5,
        hasFixture: fixture.summary != null,
      ),
      estimatedValue: _estimatedValue(player),
      category: PlayerRecommendationResult.categoryFromScore(score),
      swapCandidateId: swap?.id,
      swapCandidateName: swap == null
          ? null
          : '${swap.firstName} ${swap.lastName}'.trim(),
      components: components,
    );
  }

  /// Analysiert eine Liste von Spielern, keyed nach Spieler-ID.
  Map<String, PlayerRecommendationResult> analyzeBatch(
    List<PlayerAnalysisInput> players,
  ) => {for (final input in players) input.player.id: analyze(input)};

  // ---------------------------------------------------------------------------
  // Komponenten
  // ---------------------------------------------------------------------------

  /// Label der Verfügbarkeits-Einschränkung oder null wenn verfügbar.
  String? _availabilityLabel(int status) {
    if (injuryStatuses.contains(status)) return 'verletzt / angeschlagen';
    if (suspensionStatuses.contains(status)) return 'gesperrt';
    if (recoveryStatuses.contains(status)) return 'im Aufbautraining';
    if (absenceStatuses.contains(status)) return 'abwesend';
    return null;
  }

  /// Gespielte Spieltage mit Punktwertung, aufsteigend nach Spieltag.
  List<MatchPerformance> _performedMatches(
    List<MatchPerformance>? performances,
  ) {
    if (performances == null) return const [];
    return performances.where((p) => p.p != null).toList()
      ..sort((a, b) => a.day.compareTo(b.day));
  }

  /// Exponentiell gewichteter Form-Schnitt der letzten Spieltage.
  double? _weightedForm(List<MatchPerformance>? performances) {
    final matches = _performedMatches(performances);
    if (matches.isEmpty) return null;
    final recent = matches.length <= maxFormMatchdays
        ? matches
        : matches.sublist(matches.length - maxFormMatchdays);

    var weightedSum = 0.0;
    var weightSum = 0.0;
    for (var i = 0; i < recent.length; i++) {
      // Neuestes Spiel hat das höchste Gewicht.
      final weight = (i + 1).toDouble();
      weightedSum += (recent[i].p ?? 0) * weight;
      weightSum += weight;
    }
    return weightedSum / weightSum;
  }

  double _formDelta(double form) =>
      ((form - formReference) / formBand).clamp(-1.0, 1.0) * maxFormDelta;

  double _efficiency(Player player) {
    final valueInMillions = player.marketValue / 1000000.0;
    if (valueInMillions <= 0) return 0;
    return player.averagePoints / valueInMillions;
  }

  double _efficiencyDelta(double efficiency) =>
      ((efficiency - efficiencyReference) / efficiencyBand).clamp(-1.0, 1.0) *
      maxEfficiencyDelta;

  ({double delta, String? summary}) _fixtureDelta(PlayerAnalysisInput input) {
    // Bevorzugt: bis zu drei kommende Spiele, gemittelt wie in der
    // Vorgänger-App (Fixture-Analyse über die nächsten Gegner).
    final upcoming = input.upcomingFixtures;
    if (upcoming != null && upcoming.isNotEmpty) {
      final fixtures = upcoming.take(maxUpcomingFixtures).toList();
      var total = 0.0;
      for (final fixture in fixtures) {
        total += _singleFixtureDelta(
          fixture.opponentTablePosition ?? 0,
          fixture.isHomeGame,
        ).delta;
      }
      final details = fixtures
          .map(
            (f) =>
                '${f.opponentName} (Platz ${f.opponentTablePosition ?? 0}, '
                '${_singleFixtureDelta(f.opponentTablePosition ?? 0, false).difficulty}'
                '${f.isHomeGame ? ', Heimspiel' : ', Auswärts'})',
          )
          .join('; ');
      return (
        delta: total / fixtures.length,
        summary: 'Nächste Gegner: $details',
      );
    }

    // Fallback: nur der nächste Gegner.
    final opponentPosition = input.nextOpponentTablePosition ?? 0;
    if (opponentPosition <= 0) {
      return (delta: 0.0, summary: null);
    }
    final isHome = input.nextMatchLocation == 'Heimspiel';
    final single = _singleFixtureDelta(opponentPosition, isHome);
    final opponent = input.nextOpponent ?? 'Gegner';
    final summary =
        'Nächster Gegner: $opponent (Platz $opponentPosition, '
        '${single.difficulty}${isHome ? ', Heimspiel' : ', Auswärts'})';
    return (delta: single.delta, summary: summary);
  }

  /// Schwierigkeit eines einzelnen Spiels anhand der Gegner-Tabellenposition.
  ({double delta, String difficulty}) _singleFixtureDelta(
    int opponentPosition,
    bool isHome,
  ) {
    if (opponentPosition <= 0) {
      return (delta: 0.0, difficulty: 'Schwierigkeit unbekannt');
    }
    double delta;
    String difficulty;
    if (opponentPosition <= 4) {
      delta = -maxFixtureDelta;
      difficulty = 'Top-4-Team';
    } else if (opponentPosition <= 8) {
      delta = -maxFixtureDelta / 2;
      difficulty = 'stark';
    } else if (opponentPosition <= 12) {
      delta = 0.0;
      difficulty = 'mittelmäßig';
    } else {
      delta = maxFixtureDelta * 2 / 3;
      difficulty = 'schwach';
    }
    if (isHome) delta += homeBonus;
    return (delta: delta, difficulty: difficulty);
  }

  List<MarketValueEntry> _historyEntries(List<MarketValueEntry>? history) {
    if (history == null || history.isEmpty) return const [];
    final entries = [...history]..sort((a, b) => a.dt.compareTo(b.dt));
    return entries.length <= maxValueHistoryEntries
        ? entries
        : entries.sublist(entries.length - maxValueHistoryEntries);
  }

  double _valueDelta(Player player, List<MarketValueEntry>? history) {
    // Kurzfristiger Trend (erwartete nächste Marktwert-Änderung).
    final trendDelta =
        (player.tfhmvt / 100000.0).clamp(-1.0, 1.0) * maxValueDelta / 2;

    // Historien-Steigung: relative Änderung über das Beobachtungsfenster.
    final entries = _historyEntries(history);
    var historyDelta = 0.0;
    if (entries.length >= 2) {
      final first = entries.first.mv;
      final last = entries.last.mv;
      if (first > 0) {
        final relativeChange = (last - first) / first;
        historyDelta = relativeChange.clamp(-0.1, 0.1) * maxValueDelta * 4;
      }
    }
    return (trendDelta + historyDelta).clamp(-maxValueDelta, maxValueDelta);
  }

  String _valueSummary(Player player) {
    if (player.tfhmvt == 0) return 'Marktwert-Trend: stabil';
    final sign = player.tfhmvt > 0 ? '+' : '';
    return 'Marktwert-Trend: $sign${player.tfhmvt} €';
  }

  /// Bester gleichpositionierter Tausch-Kandidat mit deutlich besserem
  /// Saison-Schnitt (mindestens +1 Punkt) und ohne Verfügbarkeitsproblem.
  Player? _bestSwapCandidate(PlayerAnalysisInput input) {
    final player = input.player;
    Player? best;
    for (final candidate in input.swapCandidates ?? const <Player>[]) {
      if (candidate.id == player.id) continue;
      if (candidate.position != player.position) continue;
      if (candidate.averagePoints <= player.averagePoints + 1.0) continue;
      if (_availabilityLabel(candidate.status) != null) continue;
      if (best == null || candidate.averagePoints > best.averagePoints) {
        best = candidate;
      }
    }
    return best;
  }

  int _estimatedValue(Player player) =>
      max(0, player.marketValue + player.tfhmvt);

  double _confidence({
    required bool hasForm,
    required bool hasHistory,
    required bool hasFixture,
  }) {
    var confidence = 0.4;
    if (hasForm) confidence += 0.2;
    if (hasHistory) confidence += 0.2;
    if (hasFixture) confidence += 0.2;
    return confidence.clamp(0.0, 1.0);
  }
}
