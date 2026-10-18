/// Modelle für den Manager-Direktvergleich („Du vs. Rivale").
///
/// Position-Codes (Kickbase-Konvention):
/// 1 = Torwart (TW), 2 = Abwehr (ABW), 3 = Mittelfeld (MF), 4 = Sturm (ST)
///
/// Hinweis: Plain-Dart-Klassen statt Freezed, da die Freezed-Toolchain
/// (analyzer 7.x) mit dem aktuellen Flutter-SDK nicht lauffähig ist
/// (Dot-Shorthand-Syntax im Framework) – siehe `squad_benchmark_model.dart`.
library;

/// Spieltagspunkte eines Managers an einem Spieltag (Felder `day`/`mdp`).
class MatchdayPoints {
  const MatchdayPoints({required this.matchDay, required this.points});

  /// Spieltag-Nummer (1-34).
  final int matchDay;

  /// Erreichte Punkte an diesem Spieltag.
  final int points;
}

/// Summen eines Kaders auf einer Position (Marktwert, Punkte, Spieleranzahl).
class PositionPoints {
  const PositionPoints({
    required this.position,
    this.points = 0,
    this.marketValue = 0,
    this.playerCount = 0,
  });

  /// Positions-Code (1=TW, 2=ABW, 3=MF, 4=ST).
  final int position;

  /// Summe der Saisonpunkte aller Spieler auf dieser Position.
  final int points;

  /// Summe der Marktwerte aller Spieler auf dieser Position (€).
  final int marketValue;

  /// Anzahl der Spieler auf dieser Position.
  final int playerCount;

  /// Langlabel der Position (z. B. „Torwart").
  String get label {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }
}

/// Transfer-Kennzahlen eines Managers für den Direktvergleich.
///
/// Die Werte werden aus der Manager-Transferhistorie
/// (`ManagerTransferHistoryEntry`) und der aktuellen Kader-Zusammensetzung
/// deterministisch abgeleitet.
class TransferComparisonStats {
  const TransferComparisonStats({
    this.purchaseCount = 0,
    this.totalInvested = 0,
    this.avgDealQuality = 0,
    this.valueGain = 0,
    this.totalIncome = 0,
  });

  /// Anzahl der Käufe in der aktuellen Saison.
  final int purchaseCount;

  /// Summe aller Kaufpreise (€).
  final int totalInvested;

  /// Ø Deal-Qualität pro Kauf (€): Marktwert beim Kauf − Kaufpreis.
  ///
  /// Positiv = unter Marktwert eingekauft, negativ = überbezahlt.
  final int avgDealQuality;

  /// Kursgewinn der Käufe, die noch im Kader sind (€):
  /// aktueller Marktwert − gezahlter Preis.
  final int valueGain;

  /// Einnahmen aus Verkäufen (€), sofern verfügbar.
  final int totalIncome;

  /// Gibt es auswertbare Kaufdaten?
  bool get hasPurchaseData => purchaseCount > 0;
}

/// Kennzahl-Kategorien der Gegenüberstellung.
enum ComparisonMetric {
  /// Kaderwert (Teamwert) in €.
  squadValue,

  /// Punkte der letzten 5 Spieltage.
  pointsLast5,

  /// Transfer-Erfolg (Ø Deal-Qualität pro Kauf) in €.
  transferSuccess,

  /// Aktuelles Budget in €.
  budget,
}

/// Eine Zeile der Gegenüberstellung: Kennzahl plus Werte beider Seiten.
class ComparisonRow {
  const ComparisonRow({
    required this.metric,
    required this.valueA,
    required this.valueB,
    this.note = '',
  });

  /// Kategorie der Zeile.
  final ComparisonMetric metric;

  /// Wert der Seite A („Du").
  final double valueA;

  /// Wert der Seite B (Rivale).
  final double valueB;

  /// Zusatzinfo (z. B. „5 Käufe · 42,3M€ investiert").
  final String note;

  /// Differenz A − B.
  double get delta => valueA - valueB;

  /// Betrag der Differenz.
  double get absDelta => delta.abs();

  /// Beide Seiten liegen gleichauf.
  bool get isTie => valueA == valueB;

  /// Seite A liegt vorn.
  bool get aIsBetter => valueA > valueB;
}

/// Positionsgleicher Vergleich der Kader zweier Manager.
class PositionComparison {
  const PositionComparison({
    required this.position,
    this.pointsA = 0,
    this.pointsB = 0,
    this.marketValueA = 0,
    this.marketValueB = 0,
  });

  /// Positions-Code (1=TW, 2=ABW, 3=MF, 4=ST).
  final int position;

  /// Saisonpunkte der Position bei Seite A.
  final int pointsA;

  /// Saisonpunkte der Position bei Seite B.
  final int pointsB;

  /// Marktwert der Position bei Seite A (€).
  final int marketValueA;

  /// Marktwert der Position bei Seite B (€).
  final int marketValueB;

  /// Langlabel der Position.
  String get label {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }

  /// Punktdifferenz A − B.
  int get pointsDelta => pointsA - pointsB;

  /// Marktwert-Differenz A − B (€).
  int get marketValueDelta => marketValueA - marketValueB;
}

/// Datensatz einer Vergleichsseite (ein Manager) im Direktvergleich.
class ManagerComparisonSide {
  const ManagerComparisonSide({
    required this.managerId,
    required this.managerName,
    this.teamValue = 0,
    this.budget,
    this.lastMatchdayPoints = const [],
    this.pointsLast5 = 0,
    this.positionPoints = const [],
    this.transferStats = const TransferComparisonStats(),
  });

  /// Manager-ID (Kickbase-User-ID).
  final String managerId;

  /// Anzeigename des Managers.
  final String managerName;

  /// Aktueller Kaderwert (Teamwert, €).
  final int teamValue;

  /// Aktuelles Budget (€) – `null`, wenn nicht berechenbar.
  final int? budget;

  /// Spieltagspunkte der letzten 5 gewerteten Spieltage (absteigend).
  final List<MatchdayPoints> lastMatchdayPoints;

  /// Summe der Punkte der letzten 5 Spieltage.
  final int pointsLast5;

  /// Kadersummen je Position.
  final List<PositionPoints> positionPoints;

  /// Transfer-Kennzahlen der Saison.
  final TransferComparisonStats transferStats;
}

/// Gesamtergebnis des Direktvergleichs zweier Manager.
class ManagerComparison {
  const ManagerComparison({
    required this.a,
    required this.b,
    this.rows = const [],
    this.positionComparisons = const [],
    this.strengths = const [],
    this.weaknesses = const [],
  });

  /// Seite A („Du" bzw. der zuerst genannte Manager).
  final ManagerComparisonSide a;

  /// Seite B (Rivale bzw. der zweitgenannte Manager).
  final ManagerComparisonSide b;

  /// Gegenüberstellung der Kern-Kennzahlen.
  final List<ComparisonRow> rows;

  /// Positionsweiser Kadervergleich.
  final List<PositionComparison> positionComparisons;

  /// Stärken aus Sicht von Seite A (Klartext).
  final List<String> strengths;

  /// Schwächen aus Sicht von Seite A (Klartext).
  final List<String> weaknesses;
}
