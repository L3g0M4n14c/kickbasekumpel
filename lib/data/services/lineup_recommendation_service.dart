import 'dart:math';

import '../models/ligainsider_model.dart';
import '../models/lineup_model.dart';
import '../models/optimal_lineup_model.dart';
import 'deterministic_recommendation_service.dart';

/// Bewertung eines Kader-Spielers für die empfohlene Aufstellung.
class LineupPlayerScore {
  const LineupPlayerScore({
    required this.player,
    required this.score,
    required this.summary,
    required this.expectedPoints,
    required this.opponentFactor,
    this.form,
    this.availabilityLabel,
    this.startProbability,
  });

  final LineupPlayer player;

  /// Score 0-100 (deterministisch, Komponenten siehe [LineupRecommendationService]).
  final double score;

  /// Gewichteter Form-Schnitt der letzten Spieltage (null ohne Daten).
  final double? form;

  /// Label der Verfügbarkeits-Einschränkung (null = voll verfügbar).
  final String? availabilityLabel;

  /// Aufstellungs-Wahrscheinlichkeit 0..1 aus dem Ligainsider-Startelf-Status.
  /// null = keine verlässlichen Daten → Fallback: reine Ø-Punkte (Faktor 1).
  final double? startProbability;

  /// Gegner-Stärke-Multiplikator des nächsten Spieltags (1.0 = neutral).
  final double opponentFactor;

  /// Erwartete Punkte für den nächsten Spieltag:
  /// Ø-Punkte × [startProbability] × [opponentFactor].
  final double expectedPoints;

  /// Kurzbegründung (Form, nächster Gegner, S11-Status).
  final String summary;

  bool get isAvailable => availabilityLabel == null;
}

/// Ein Tauschvorschlag gegenüber der aktuellen Aufstellung.
class LineupSwap {
  const LineupSwap({
    required this.inPlayer,
    required this.outPlayer,
    required this.gain,
    required this.expectedGain,
    required this.reason,
  });

  final LineupPlayer inPlayer;
  final LineupPlayer outPlayer;

  /// Score-Differenz im 0-100-Score (positiv = Zugewinn).
  final double gain;

  /// Erwartete Punkt-Differenz in Kickbase-Punkten
  /// ([LineupPlayerScore.expectedPoints] des Zugangs minus des Abgangs).
  final double expectedGain;

  /// Begründung des Ersatzspielers.
  final String reason;
}

/// Ergebnis der Aufstellungs-Empfehlung.
class LineupRecommendation {
  const LineupRecommendation({
    required this.starters,
    required this.bench,
    required this.scores,
    required this.swaps,
    required this.formationName,
    required this.isLegalFormation,
    required this.usesLigainsiderData,
  });

  /// Empfohlene Startelf (TW, ABW, MF, ST – je nach Score sortiert).
  final List<LineupPlayer> starters;

  /// Restlicher Kader, sortiert nach Score (absteigend).
  final List<LineupPlayer> bench;

  /// Bewertung je Spieler-ID.
  final Map<String, LineupPlayerScore> scores;

  /// Wechsel-Vorschläge gegenüber der aktuellen Aufstellung
  /// (größte erwartete Punkt-Differenz zuerst).
  final List<LineupSwap> swaps;

  /// Name der gewählten Formation (z. B. '4-4-2') oder 'Freie Auswahl'.
  final String formationName;

  /// false, wenn keine legale Formation möglich war (Top-11 ohne Positions-Regel).
  final bool isLegalFormation;

  /// true, wenn verlässliche Ligainsider-Daten in die Aufstellungs-
  /// Wahrscheinlichkeiten eingeflossen sind. false = Fallback auf reine
  /// Ø-Punkte (leere/unvollständige Ligainsider-Daten).
  final bool usesLigainsiderData;
}

/// Punkte-Skala des Kaders – normalisiert Form- und Stärke-Bewertung
/// relativ zum Kader, damit sie auf JEDER realen Punkte-Skala
/// differenzieren (fixe Referenzen sättigen bei ap ≫ 5 auf Maximum).
class LineupPointsScale {
  const LineupPointsScale({required this.reference, required this.spread});

  /// Fallback für direkte Aufrufe ohne Kader-Kontext (kleine Punkte-Skala).
  static const fallback = LineupPointsScale(reference: 5.0, spread: 5.0);

  /// Referenz = Ø-Punkte des Kaders; Spannweite = halbe Wertespanne über
  /// Ø-Punkte und Form (min. 1 Punkt).
  factory LineupPointsScale.fromSquad(List<LineupPlayer> squad) {
    final averages = [for (final p in squad) p.averagePoints.toDouble()];
    if (averages.isEmpty) return fallback;
    final forms = [
      for (final p in squad)
        ?LineupRecommendationService.weightedForm(p.performanceHistory),
    ];
    final reference = averages.reduce((a, b) => a + b) / averages.length;
    final values = [...averages, ...forms];
    final range = values.reduce(max) - values.reduce(min);
    return LineupPointsScale(reference: reference, spread: max(1.0, range / 2));
  }

  /// Zentrum der Skala (Kader-Ø der Saison-Punkte).
  final double reference;

  /// Halbe Spannweite – Abstände davon ergeben die normalisierten Deltas.
  final double spread;

  /// Normalisiert einen Punktwert auf -1..1 relativ zur Kader-Skala.
  double normalize(double points) =>
      ((points - reference) / spread).clamp(-1.0, 1.0);
}

/// Deterministische Empfehlung für die eigene Aufstellung aus dem Kader.
///
/// Bewertet jeden Spieler mit denselben Konstanten wie der
/// [DeterministicRecommendationService]:
/// - Form: exponentiell gewichteter Schnitt der letzten Spieltage
/// - Saison-Durchschnitt: Baseline-Qualität
/// - Spielplan: Gegner-Tabellenposition + Heim/Auswärts der nächsten Spiele
/// - Verfügbarkeit: harte Regel (matchDayStatus != 0 → nie empfohlen)
/// - Ligainsider-Startelf: S11 = Bonus; ohne S11-Platz (Bank/out) =
///   Ausschluss-Kriterium; nur ohne Daten bleibt es neutral
///
/// Zusätzlich bewertet der Service jeden Tausch mit einer erwarteten
/// Punkt-Differenz (Story #13):
/// `erwartete Punkte = Ø-Punkte × Aufstellungs-Wahrscheinlichkeit (Ligainsider)
/// × Gegner-Stärke`. Ohne verlässliche Ligainsider-Daten bleibt die
/// Wahrscheinlichkeit neutral (Fallback: reine Ø-Punkte).
///
/// Die Startelf wird formation-legal aus `Formation.allFormations` gewählt
/// (genau ein Torwart), Fallback ist die freie Top-11 (ebenfalls genau ein
/// Torwart).
class LineupRecommendationService {
  const LineupRecommendationService();

  /// Basis-Score, von dem aus die Komponenten addiert/subtrahiert werden.
  static const double baseScore = 50.0;

  /// Maximaler Beitrag des Saison-Durchschnitts.
  static const double maxAverageDelta = 12.0;

  /// Maximaler Beitrag des Ligainsider-Startelf-Status.
  static const double maxLigainsiderDelta = 8.0;

  /// Score ausgeschlossener Spieler (verletzt/gesperrt oder ohne S11-Platz).
  /// Wird nur als Lückenbüßer aufgefüllt, wenn zu wenig andere da sind.
  static const double unavailableScore = 8.0;

  /// Minimaler Anteil bestätigter S11-Status, ab dem "nicht gefunden" (out)
  /// als Ausschluss-Beweis gilt. Darunter ist die Ligainsider-Abdeckung
  /// offensichtlich unvollständig (Datenlücke, alte Aufstellungen) – dann
  /// bleibt out neutral, damit nicht alle Spieler k. o. gehen.
  static const double minS11Coverage = 0.3;

  /// Aufstellungs-Wahrscheinlichkeit je Ligainsider-Startelf-Status
  /// (Story #13: erwartete Punkte = Ø-Punkte × Wahrscheinlichkeit × Gegner).
  static const double startProbabilityLikelyStart = 0.9;
  static const double startProbabilityWithAlternative = 0.7;
  static const double startProbabilityIsAlternative = 0.4;
  static const double startProbabilityBench = 0.1;
  static const double startProbabilityOut = 0.05;

  /// Einsatz unwahrscheinlich (verletzt/gesperrt/nicht einsatzbereit) –
  /// unabhängig vom Ligainsider-Status.
  static const double startProbabilityUnavailable = 0.1;

  /// Maximaler Ausschlag der Gegner-Stärke auf die erwarteten Punkte (±20 %).
  static const double maxOpponentSwing = 0.2;

  LineupRecommendation recommend({
    required List<LineupPlayer> squad,
    Map<String, List<FixtureInfo>> fixturesByTeamKey = const {},
    Map<String, LigainsiderPlayerStatus> ligainsiderStatusByPlayerId = const {},
    List<Formation>? formations,
  }) {
    final scale = LineupPointsScale.fromSquad(squad);
    final ligainsiderStatuses = _reliableLigainsiderStatuses(
      ligainsiderStatusByPlayerId,
      squad,
    );
    // Aufstellungs-Wahrscheinlichkeiten nur bei zuverlässiger Abdeckung –
    // bei leeren/unvollständigen Ligainsider-Daten greift der Fallback auf
    // reine Ø-Punkte (Story #13).
    final ligainsiderReliable = _hasReliableCoverage(
      ligainsiderStatusByPlayerId,
      squad,
    );
    final scores = <String, LineupPlayerScore>{};
    for (final player in squad) {
      scores[player.id] = scoreFor(
        player,
        fixturesByTeamKey[player.teamId] ?? const [],
        ligainsiderStatuses[player.id],
        scale: scale,
        ligainsiderProbabilityAvailable: ligainsiderReliable,
      );
    }

    double scoreOf(LineupPlayer p) => scores[p.id]!.score;
    int byScoreDesc(LineupPlayer a, LineupPlayer b) {
      final byScore = scoreOf(b).compareTo(scoreOf(a));
      if (byScore != 0) return byScore;
      final byName = a.name.compareTo(b.name);
      return byName != 0 ? byName : a.id.compareTo(b.id);
    }

    // Verfügbare zuerst; nur wenn zu wenige, werden Verletzte aufgefüllt.
    final available = squad.where((p) => scores[p.id]!.isAvailable).toList()
      ..sort(byScoreDesc);
    final unavailable = squad.where((p) => !scores[p.id]!.isAvailable).toList()
      ..sort(byScoreDesc);
    final pool = [...available, ...unavailable];

    final goalkeepers = pool.where((p) => p.position == 1).toList();
    final defenders = pool.where((p) => p.position == 2).toList();
    final midfielders = pool.where((p) => p.position == 3).toList();
    final forwards = pool.where((p) => p.position == 4).toList();

    List<LineupPlayer>? bestStarters;
    var bestTotal = -1.0;
    var bestName = 'Freie Auswahl';
    var bestIsLegal = false;

    if (goalkeepers.isNotEmpty) {
      for (final formation in formations ?? Formation.allFormations) {
        if (defenders.length < formation.defenders ||
            midfielders.length < formation.midfielders ||
            forwards.length < formation.forwards) {
          continue;
        }
        final starters = <LineupPlayer>[
          goalkeepers.first,
          ...defenders.take(formation.defenders),
          ...midfielders.take(formation.midfielders),
          ...forwards.take(formation.forwards),
        ];
        final total = starters.fold<double>(0.0, (sum, p) => sum + scoreOf(p));
        if (total > bestTotal ||
            (total == bestTotal && formation.name.compareTo(bestName) < 0)) {
          bestTotal = total;
          bestName = formation.name;
          bestStarters = starters;
          bestIsLegal = true;
        }
      }
    }

    // Fallback: freie Top-11 ohne Positions-Regel (z. B. ohne Torwart im Kader).
    // Auch hier gilt die Kickbase-Regel „genau ein Torwart": Der beste TW wird
    // gesetzt, der Rest sind die besten Feldspieler – niemals zwei Torhüter.
    final List<LineupPlayer> selected;
    if (bestStarters != null) {
      selected = bestStarters;
    } else if (goalkeepers.isNotEmpty) {
      final fieldPlayers = pool.where((p) => p.position != 1).toList();
      selected = [
        goalkeepers.first,
        ...fieldPlayers.take(min(10, fieldPlayers.length)),
      ];
    } else {
      selected = pool.take(min(11, pool.length)).toList();
    }
    final starters = [...selected]
      ..sort((a, b) {
        final byPosition = a.position.compareTo(b.position);
        return byPosition != 0 ? byPosition : byScoreDesc(a, b);
      });
    final starterIds = starters.map((p) => p.id).toSet();
    // pool ist bereits nach Score sortiert → Bank automatisch auch.
    final bench = pool.where((p) => !starterIds.contains(p.id)).toList();

    return LineupRecommendation(
      starters: starters,
      bench: bench,
      scores: scores,
      swaps: _swaps(
        squad: squad,
        starters: starters,
        scores: scores,
        byScoreDesc: byScoreDesc,
      ),
      formationName: bestName,
      isLegalFormation: bestIsLegal,
      usesLigainsiderData: ligainsiderReliable,
    );
  }

  /// Wirft `out`-Einträge raus, wenn die Daten den Kader nicht sinnvoll
  /// abdecken (zu wenige S11-Bestätigungen): Dann ist "nicht gefunden" kein
  /// Ausschluss-Beweis, sondern eine Datenlücke.
  Map<String, LigainsiderPlayerStatus> _reliableLigainsiderStatuses(
    Map<String, LigainsiderPlayerStatus> statuses,
    List<LineupPlayer> squad,
  ) {
    var checked = 0;
    var confirmed = 0;
    for (final player in squad) {
      final status = statuses[player.id];
      if (status == null) continue;
      checked++;
      if (status != LigainsiderPlayerStatus.out) confirmed++;
    }
    if (checked == 0 || confirmed / checked >= minS11Coverage) {
      return statuses;
    }
    return {
      for (final entry in statuses.entries)
        if (entry.value != LigainsiderPlayerStatus.out) entry.key: entry.value,
    };
  }

  /// true, wenn die Ligainsider-Daten den Kader zuverlässig abdecken
  /// (mindestens [minS11Coverage] bestätigte S11-Status). Nur dann taugen
  /// die Status-Werte als Aufstellungs-Wahrscheinlichkeit – sonst greift
  /// der Fallback auf reine Ø-Punkte (Story #13).
  bool _hasReliableCoverage(
    Map<String, LigainsiderPlayerStatus> statuses,
    List<LineupPlayer> squad,
  ) {
    var checked = 0;
    var confirmed = 0;
    for (final player in squad) {
      final status = statuses[player.id];
      if (status == null) continue;
      checked++;
      if (status != LigainsiderPlayerStatus.out) confirmed++;
    }
    return checked > 0 && confirmed / checked >= minS11Coverage;
  }

  /// Bewertet einen einzelnen Spieler (0-100) inkl. Kurzbegründung.
  ///
  /// [scale] normaliert Form und Saison-Ø relativ zum Kader – nur so
  /// differenzieren beide Komponenten auch auf realer Punkte-Skala.
  ///
  /// [ligainsiderProbabilityAvailable] steuert, ob der Ligainsider-Status als
  /// Aufstellungs-Wahrscheinlichkeit einfließt (false = Fallback auf reine
  /// Ø-Punkte, Story #13).
  LineupPlayerScore scoreFor(
    LineupPlayer player,
    List<FixtureInfo> fixtures,
    LigainsiderPlayerStatus? ligainsiderStatus, {
    LineupPointsScale scale = LineupPointsScale.fallback,
    bool ligainsiderProbabilityAvailable = true,
  }) {
    final form = weightedForm(player.performanceHistory);

    // Erwartete Punkte für den nächsten Spieltag (Story #13):
    // Ø-Punkte × Aufstellungs-Wahrscheinlichkeit × Gegner-Stärke.
    // Ohne verlässliche Ligainsider-Daten bleibt die Wahrscheinlichkeit
    // neutral (Fallback: reine Ø-Punkte).
    final startProbability = player.matchDayStatus != 0
        ? startProbabilityUnavailable
        : ligainsiderProbabilityAvailable
        ? startProbabilityFor(ligainsiderStatus)
        : null;
    final opponentFactor = opponentFactorFor(fixtures);
    final expectedPoints =
        player.averagePoints.toDouble() *
        (startProbability ?? 1.0) *
        opponentFactor;

    // Ausschlusskriterien: nicht verfügbar ODER ohne S11-Platz (Ligainsider
    // liefert nur S11 + Alternativen → Bank/nicht gefunden = quasi K.O.).
    final exclusionLabel =
        _availabilityLabel(player.matchDayStatus) ??
        _ligainsiderExclusion(ligainsiderStatus);
    if (exclusionLabel != null) {
      return LineupPlayerScore(
        player: player,
        score: unavailableScore,
        form: form,
        availabilityLabel: exclusionLabel,
        startProbability: startProbability,
        opponentFactor: opponentFactor,
        expectedPoints: expectedPoints,
        summary: exclusionLabel,
      );
    }

    final formDelta = form == null
        ? 0.0
        : scale.normalize(form) *
              DeterministicRecommendationService.maxFormDelta;
    final averageDelta =
        scale.normalize(player.averagePoints.toDouble()) * maxAverageDelta;
    final fixtureDelta = _fixtureDelta(fixtures);
    final ligainsiderDelta = _ligainsiderDelta(ligainsiderStatus);

    final score =
        (baseScore + formDelta + averageDelta + fixtureDelta + ligainsiderDelta)
            .clamp(0.0, 100.0);

    return LineupPlayerScore(
      player: player,
      score: score,
      form: form,
      startProbability: startProbability,
      opponentFactor: opponentFactor,
      expectedPoints: expectedPoints,
      summary: [
        form == null ? 'Form: keine Daten' : 'Form: ${_fmt(form)}',
        _fixtureSummary(fixtures),
        ?_ligainsiderLabel(ligainsiderStatus),
      ].join(' · '),
    );
  }

  /// Exponentiell gewichteter Form-Schnitt der letzten Spieltage.
  static double? weightedForm(List<PerformanceHistory>? history) {
    if (history == null) return null;
    final matches = history.where((e) => e.hasPlayed).toList();
    if (matches.isEmpty) return null;
    final maxMatchdays = DeterministicRecommendationService.maxFormMatchdays;
    final recent = matches.length <= maxMatchdays
        ? matches
        : matches.sublist(matches.length - maxMatchdays);

    var weightedSum = 0.0;
    var weightSum = 0.0;
    for (var i = 0; i < recent.length; i++) {
      // Neuestes Spiel hat das höchste Gewicht.
      final weight = (i + 1).toDouble();
      weightedSum += recent[i].points * weight;
      weightSum += weight;
    }
    return weightedSum / weightSum;
  }

  /// Aufstellungs-Wahrscheinlichkeit 0..1 aus dem Ligainsider-Startelf-Status
  /// (Story #13). null ohne Status → neutraler Faktor 1 (Fallback: Ø-Punkte).
  static double? startProbabilityFor(LigainsiderPlayerStatus? status) =>
      switch (status) {
        LigainsiderPlayerStatus.likelyStart => startProbabilityLikelyStart,
        LigainsiderPlayerStatus.startWithAlternative =>
          startProbabilityWithAlternative,
        LigainsiderPlayerStatus.isAlternative => startProbabilityIsAlternative,
        LigainsiderPlayerStatus.bench => startProbabilityBench,
        LigainsiderPlayerStatus.out => startProbabilityOut,
        null => null,
      };

  /// Gegner-Stärke-Multiplikator aus dem Spielplan (1.0 = neutral, Story #13).
  ///
  /// Der mittlere Fixture-Delta-Bereich
  /// (±[DeterministicRecommendationService.maxFixtureDelta]) skaliert linear
  /// auf ±[maxOpponentSwing]: leichter Heim-Gegner → +20 %, Top-4 auswärts
  /// → −20 % erwartete Punkte. Ohne Spielplan-Daten bleibt der Faktor 1.
  double opponentFactorFor(List<FixtureInfo> fixtures) {
    final delta = _fixtureDelta(fixtures);
    return (1.0 +
            delta /
                DeterministicRecommendationService.maxFixtureDelta *
                maxOpponentSwing)
        .clamp(1.0 - maxOpponentSwing, 1.0 + maxOpponentSwing);
  }

  double _fixtureDelta(List<FixtureInfo> fixtures) {
    final upcoming = fixtures
        .take(DeterministicRecommendationService.maxUpcomingFixtures)
        .toList();
    if (upcoming.isEmpty) return 0.0;
    var total = 0.0;
    for (final fixture in upcoming) {
      total += DeterministicRecommendationService.singleFixtureDelta(
        fixture.opponentTablePosition ?? 0,
        fixture.isHomeGame,
      ).delta;
    }
    return total / upcoming.length;
  }

  String _fixtureSummary(List<FixtureInfo> fixtures) {
    if (fixtures.isEmpty) return 'Kein Spielplan';
    final fixture = fixtures.first;
    final position = fixture.opponentTablePosition;
    final location = fixture.isHomeGame ? 'Heimspiel' : 'Auswärts';
    return 'Nächstes Spiel: vs. ${fixture.opponentName} '
        '($location${position != null && position > 0 ? ', Platz $position' : ''})';
  }

  double _ligainsiderDelta(LigainsiderPlayerStatus? status) => switch (status) {
    LigainsiderPlayerStatus.likelyStart => maxLigainsiderDelta,
    LigainsiderPlayerStatus.startWithAlternative => maxLigainsiderDelta / 2,
    LigainsiderPlayerStatus.isAlternative => -maxLigainsiderDelta / 2,
    // Bank/out werden vorher ausgeschlossen (Ausschluss-Kriterium).
    LigainsiderPlayerStatus.bench || LigainsiderPlayerStatus.out || null => 0.0,
  };

  String? _ligainsiderLabel(LigainsiderPlayerStatus? status) =>
      switch (status) {
        LigainsiderPlayerStatus.likelyStart => 'S11',
        LigainsiderPlayerStatus.startWithAlternative => 'S11 (mit Alternative)',
        LigainsiderPlayerStatus.isAlternative => 'Alternative',
        // Bank/out werden vorher ausgeschlossen (Ausschluss-Kriterium).
        LigainsiderPlayerStatus.bench ||
        LigainsiderPlayerStatus.out ||
        null => null,
      };

  /// Ausschluss-Label für Spieler ohne S11-Platz oder null.
  ///
  /// Pinned: Ligainsider liefert nur S11 + Alternativen – wer dort fehlt (out)
  /// oder nur Bank ist, hat keinen Startelf-Platz in Aussicht.
  String? _ligainsiderExclusion(LigainsiderPlayerStatus? status) =>
      switch (status) {
        LigainsiderPlayerStatus.bench => 'Ligainsider: Bank (kein S11-Platz)',
        LigainsiderPlayerStatus.out =>
          'Ligainsider: nicht in der erwarteten Startelf',
        LigainsiderPlayerStatus.likelyStart ||
        LigainsiderPlayerStatus.startWithAlternative ||
        LigainsiderPlayerStatus.isAlternative ||
        null => null,
      };

  String? _availabilityLabel(int matchDayStatus) {
    if (matchDayStatus == 0) return null;
    return switch (matchDayStatus) {
      1 => 'Verfügbarkeitsrisiko: verletzt / angeschlagen',
      2 => 'Verfügbarkeitsrisiko: gesperrt',
      _ => 'Verfügbarkeitsrisiko: nicht einsatzbereit',
    };
  }

  /// Startelf-Konvention aus der Kickbase-API: `lo` ist die Lineup-Reihenfolge.
  /// Die 11 Starter haben lo=1..11, Bank-/Nicht-Aufgestellte lo=0 oder >11.
  /// WICHTIG: Ein Torwart mit lo=0 ist KEIN Starter (sonst erscheinen zwei
  /// Torhüter in der S11), sondern Bank.
  static bool isStarter(LineupPlayer player) =>
      player.lineupOrder >= 1 && player.lineupOrder <= 11;

  /// Reihenfolge-Liste für `POST /lineup`, in der genau [swap] umgesetzt ist
  /// (Tap-to-Swap, Story #13): Die aktuelle Ordnung bleibt erhalten, nur die
  /// beiden beteiligten Spieler tauschen ihren Platz.
  static List<String> swappedLineupIds(
    List<LineupPlayer> current,
    LineupSwap swap,
  ) {
    final starters = current.where(isStarter).toList()
      ..sort((a, b) => a.lineupOrder.compareTo(b.lineupOrder));
    // Ohne feste Ordnung (lo == 0/≤11) am Ende der Bank, sonst Reihenfolge.
    int benchOrder(LineupPlayer p) => p.lineupOrder > 11 ? p.lineupOrder : 999;
    final bench = current.where((p) => !isStarter(p)).toList()
      ..sort((a, b) {
        final byOrder = benchOrder(a).compareTo(benchOrder(b));
        return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
      });

    final ids = [...starters, ...bench].map((p) => p.id).toList();
    final outIndex = ids.indexOf(swap.outPlayer.id);
    final inIndex = ids.indexOf(swap.inPlayer.id);
    if (outIndex < 0 || inIndex < 0) return ids;
    final swapped = [...ids];
    swapped[outIndex] = swap.inPlayer.id;
    swapped[inIndex] = swap.outPlayer.id;
    return swapped;
  }

  /// Paart empfohlene Zugänge mit den ausscheidenden Aktuellen (pro Position,
  /// Rest bei Positionswechseln nach Score).
  List<LineupSwap> _swaps({
    required List<LineupPlayer> squad,
    required List<LineupPlayer> starters,
    required Map<String, LineupPlayerScore> scores,
    required int Function(LineupPlayer, LineupPlayer) byScoreDesc,
  }) {
    int byScoreAsc(LineupPlayer a, LineupPlayer b) => byScoreDesc(b, a);

    final current = squad.where(isStarter).toList();
    final currentIds = current.map((p) => p.id).toSet();
    final starterIds = starters.map((p) => p.id).toSet();

    final incoming = starters.where((p) => !currentIds.contains(p.id)).toList()
      ..sort(byScoreDesc);
    final outgoing = current.where((p) => !starterIds.contains(p.id)).toList()
      ..sort(byScoreAsc);

    final swaps = <LineupSwap>[];
    final usedOutIds = <String>{};
    void addSwap(LineupPlayer inPlayer, LineupPlayer outPlayer) {
      usedOutIds.add(outPlayer.id);
      final inScore = scores[inPlayer.id]!;
      final outScore = scores[outPlayer.id]!;
      swaps.add(
        LineupSwap(
          inPlayer: inPlayer,
          outPlayer: outPlayer,
          gain: inScore.score - outScore.score,
          expectedGain: inScore.expectedPoints - outScore.expectedPoints,
          reason: inScore.summary,
        ),
      );
    }

    // 1. Gleiche Position zuerst.
    for (final position in const [1, 2, 3, 4]) {
      final ins = incoming
          .where(
            (p) =>
                p.position == position &&
                !swaps.any((s) => s.inPlayer.id == p.id),
          )
          .toList();
      final outs = outgoing
          .where((p) => p.position == position && !usedOutIds.contains(p.id))
          .toList();
      for (var i = 0; i < min(ins.length, outs.length); i++) {
        addSwap(ins[i], outs[i]);
      }
    }

    // 2. Rest (Positionswechsel) in Score-Reihenfolge.
    final restIn = incoming
        .where((p) => !swaps.any((s) => s.inPlayer.id == p.id))
        .toList();
    final restOut = outgoing.where((p) => !usedOutIds.contains(p.id)).toList();
    for (var i = 0; i < min(restIn.length, restOut.length); i++) {
      addSwap(restIn[i], restOut[i]);
    }

    // Größte erwartete Punkt-Differenz zuerst (Story #13); Score-Gewinn
    // entscheidet bei Gleichstand, danach Spieler-ID (deterministisch).
    return swaps..sort((a, b) {
      final byExpected = b.expectedGain.compareTo(a.expectedGain);
      if (byExpected != 0) return byExpected;
      final byGain = b.gain.compareTo(a.gain);
      return byGain != 0 ? byGain : a.inPlayer.id.compareTo(b.inPlayer.id);
    });
  }

  String _fmt(double value) => value.toStringAsFixed(1).replaceAll('.', ',');
}
