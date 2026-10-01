/// Positionsweise Kader-Benchmark-Zeile: vergleicht den eigenen Kader
/// einer Position mit dem Ligen-Durchschnitt aller Manager.
///
/// Position-Codes (Kickbase-Konvention):
/// 1 = Torwart (TW), 2 = Abwehr (ABW), 3 = Mittelfeld (MF), 4 = Sturm (ST)
///
/// Hinweis: Plain-Dart-Klasse statt Freezed, da die Freezed-Toolchain
/// (analyzer 7.x) mit dem aktuellen Flutter-SDK nicht lauffähig ist
/// (Dot-Shorthand-Syntax im Framework).
class PositionBenchmark {
  /// Positions-Code (1=TW, 2=ABW, 3=MF, 4=ST)
  final int position;

  /// Gesamt-Marktwert des eigenen Kaders auf dieser Position (€)
  final int ownMarketValue;

  /// Durchschnittlicher Gesamt-Marktwert pro Manager auf dieser Position (€)
  final double leagueAvgMarketValue;

  /// Ø Punkte des eigenen Kaders auf dieser Position (gemittelt über Spieler)
  final double ownAvgPoints;

  /// Ø Punkte pro Spieler auf dieser Position ligaweit
  final double leagueAvgPoints;

  /// Anzahl Spieler auf dieser Position im eigenen Kader
  final int ownCount;

  /// Durchschnittliche Spieleranzahl pro Manager auf dieser Position
  final double leagueAvgCount;

  const PositionBenchmark({
    required this.position,
    this.ownMarketValue = 0,
    this.leagueAvgMarketValue = 0,
    this.ownAvgPoints = 0,
    this.leagueAvgPoints = 0,
    this.ownCount = 0,
    this.leagueAvgCount = 0,
  });

  /// Kurzlabel der Position.
  String get label {
    switch (position) {
      case 1:
        return 'TW';
      case 2:
        return 'ABW';
      case 3:
        return 'MF';
      case 4:
        return 'ST';
      default:
        return '?';
    }
  }

  /// Differenz des eigenen Marktwerts zum Ligen-Schnitt (€).
  double get marketValueDelta => ownMarketValue - leagueAvgMarketValue;

  /// Differenz der Ø-Punkte zum Ligen-Schnitt.
  double get pointsDelta => ownAvgPoints - leagueAvgPoints;
}

/// Ergebnis des Kader-Benchmarks: eine Zeile pro Position plus Kontext.
class SquadBenchmark {
  /// Benchmark-Zeilen je Position (aufsteigend nach Positions-Code).
  final List<PositionBenchmark> positions;

  /// Anzahl der Manager, die in den Ligen-Durchschnitt eingeflossen sind.
  final int managerCount;

  /// Gesamt-Kaderwert des eigenen Teams (€).
  final int ownTotalMarketValue;

  /// Durchschnittlicher Gesamt-Kaderwert pro Manager (€).
  final double leagueAvgTotalMarketValue;

  const SquadBenchmark({
    required this.positions,
    this.managerCount = 0,
    this.ownTotalMarketValue = 0,
    this.leagueAvgTotalMarketValue = 0,
  });

  /// Differenz des eigenen Gesamt-Kaderwerts zum Ligen-Schnitt (€).
  double get totalMarketValueDelta =>
      ownTotalMarketValue - leagueAvgTotalMarketValue;
}
