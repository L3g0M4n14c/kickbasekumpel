import '../models/manager_comparison_model.dart';
import '../models/transfer_model.dart';
import 'squad_benchmark_service.dart';

/// Service für den Manager-Direktvergleich („Du vs. Rivale").
///
/// Aggregiert die Kennzahlen zweier Manager (Kaderwert, Punkte der letzten
/// 5 Spieltage, Transfer-Erfolg, Budget) zu einer Gegenüberstellung und
/// erzeugt daraus ein Stärken/Schwächen-Kurzfazit als Klartext.
///
/// Grundlagen sind die vorhandenen Services/Daten:
/// - [SquadBenchmarkService] (positionsweise Kader-Aggregation)
/// - `ManagerTransferHistoryService` (Transferhistorie inkl. Marktwert)
/// - Performance-Daten (`managers/{id}/performance`, Felder `day`/`mdp`)
///
/// Die Logik ist deterministisch und rein – alle API-Aufrufe laufen im
/// zugehörigen `managerComparisonProvider`.
class ManagerComparisonService {
  /// Erstellt den Service.
  ///
  /// [squadBenchmarkService] ist austauschbar (Tests).
  ManagerComparisonService({SquadBenchmarkService? squadBenchmarkService})
    : _squadBenchmarkService = squadBenchmarkService ?? SquadBenchmarkService();

  final SquadBenchmarkService _squadBenchmarkService;

  /// Ab wie viel Punkten Differenz eine Position ins Kurzfazit aufgenommen
  /// wird (z. B. „Sein Torwart ist +12 Punkte stärker").
  static const int positionSummaryThreshold = 5;

  /// Berechnet die Transfer-Kennzahlen eines Managers.
  ///
  /// [transfers] Transferhistorie des Managers (Käufe und Verkäufe).
  /// [currentPlayerValues] aktueller Marktwert je Spieler-ID (aus dem Kader) –
  /// damit wird der Kursgewinn noch gehaltener Käufe ermittelt.
  /// [totalIncome] Einnahmen aus Verkäufen (optional, aus der Budget-
  /// Berechnung).
  TransferComparisonStats transferStats({
    required List<ManagerTransferHistoryEntry> transfers,
    Map<String, int> currentPlayerValues = const {},
    int totalIncome = 0,
  }) {
    // Nur Käufe (transferType == 1) sind für den Transfer-Erfolg relevant.
    final purchases = transfers
        .where((transfer) => transfer.transferType == 1)
        .toList();
    if (purchases.isEmpty) {
      return TransferComparisonStats(totalIncome: totalIncome);
    }

    var invested = 0;
    var dealQualitySum = 0;
    var dealQualityCount = 0;
    var valueGain = 0;

    for (final purchase in purchases) {
      invested += purchase.price;

      final marketValueAtTransfer = purchase.marketValueAtTransfer;
      if (marketValueAtTransfer != null && marketValueAtTransfer > 0) {
        dealQualitySum += marketValueAtTransfer - purchase.price;
        dealQualityCount++;
      }

      final currentValue = currentPlayerValues[purchase.playerId];
      if (currentValue != null && currentValue > 0) {
        valueGain += currentValue - purchase.price;
      }
    }

    return TransferComparisonStats(
      purchaseCount: purchases.length,
      totalInvested: invested,
      avgDealQuality: dealQualityCount > 0
          ? (dealQualitySum / dealQualityCount).round()
          : 0,
      valueGain: valueGain,
      totalIncome: totalIncome,
    );
  }

  /// Aggregiert die Kadersummen je Position aus einer Squad-Rohantwort.
  ///
  /// [squadPlayers] Spieler-Maps der Squad-Response (`it`-Liste) mit den
  /// Feldern `pos`, `mv` und `p`. Die Aggregation selbst übernimmt der
  /// [SquadBenchmarkService].
  List<PositionPoints> positionPoints(List<Map<String, dynamic>> squadPlayers) {
    final totals = _squadBenchmarkService.positionTotals(squadPlayers);
    return SquadBenchmarkService.allPositions.map((position) {
      final total = totals[position]!;
      return PositionPoints(
        position: position,
        points: total.points.round(),
        marketValue: total.marketValue,
        playerCount: total.count,
      );
    }).toList();
  }

  /// Baut den Datensatz einer Vergleichsseite aus den Rohdaten eines Managers.
  ///
  /// [matchdayPoints] Spieltagspunkte der aktuellen Saison (`day`/`mdp`);
  /// die letzten 5 gewerteten Spieltage werden herausgefiltert und summiert.
  ManagerComparisonSide buildSide({
    required String managerId,
    required String managerName,
    int teamValue = 0,
    int? budget,
    List<MatchdayPoints> matchdayPoints = const [],
    List<PositionPoints> positionPoints = const [],
    TransferComparisonStats transferStats = const TransferComparisonStats(),
  }) {
    final sorted = List<MatchdayPoints>.from(matchdayPoints)
      ..sort((a, b) => b.matchDay.compareTo(a.matchDay));
    final lastFive = sorted.take(5).toList();
    final pointsLast5 = lastFive.fold<int>(0, (sum, m) => sum + m.points);

    return ManagerComparisonSide(
      managerId: managerId,
      managerName: managerName,
      teamValue: teamValue,
      budget: budget,
      lastMatchdayPoints: lastFive,
      pointsLast5: pointsLast5,
      positionPoints: positionPoints,
      transferStats: transferStats,
    );
  }

  /// Erstellt den Direktvergleich aus zwei Manager-Datensätzen.
  ///
  /// [a] Seite A („Du"), [b] Seite B (Rivale). Über [aLabel]/[bLabel] werden
  /// die Namen für das Klartext-Kurzfazit gesetzt (Standard: „Du"/„Rivale").
  ///
  /// Returns: [ManagerComparison] mit Gegenüberstellung, positionsweisem
  /// Kadervergleich und Stärken/Schwächen als Klartext (aus Sicht von A).
  ManagerComparison compare({
    required ManagerComparisonSide a,
    required ManagerComparisonSide b,
    String aLabel = 'Du',
    String bLabel = 'Rivale',
  }) {
    final rows = _buildRows(a, b);
    final positionComparisons = _buildPositionComparisons(a, b);

    final strengths = <String>[];
    final weaknesses = <String>[];

    // Kategorien: besser = größeren Wert (Kaderwert, Punkte, Ø Deal-Qualität,
    // Budget – alle "mehr ist besser").
    void addCategoryLine(
      ComparisonRow row, {
      required bool plural,
      required String Function(String possessive) lineBuilder,
    }) {
      if (row.isTie) return;
      final label = row.aIsBetter ? aLabel : bLabel;
      final text = lineBuilder(_possessive(label, plural: plural));
      if (row.aIsBetter) {
        strengths.add(text);
      } else {
        weaknesses.add(text);
      }
    }

    for (final row in rows) {
      switch (row.metric) {
        case ComparisonMetric.squadValue:
          addCategoryLine(
            row,
            plural: false,
            lineBuilder: (possessive) =>
                '$possessive Kaderwert ist ${_money(row.absDelta)} höher',
          );
        case ComparisonMetric.pointsLast5:
          addCategoryLine(
            row,
            plural: true,
            lineBuilder: (possessive) =>
                '$possessive Punkte der letzten 5 Spieltage sind '
                '${row.absDelta.round()} besser',
          );
        case ComparisonMetric.transferSuccess:
          addCategoryLine(
            row,
            plural: false,
            lineBuilder: (possessive) {
              final winner = row.aIsBetter ? a : b;
              return '$possessive Transfer-Erfolg ist besser '
                  '(Ø ${_signedMoney(winner.transferStats.avgDealQuality)} '
                  'pro Kauf)';
            },
          );
        case ComparisonMetric.budget:
          addCategoryLine(
            row,
            plural: false,
            lineBuilder: (possessive) =>
                '$possessive Budget ist ${_money(row.absDelta)} höher',
          );
      }
    }

    // Positionsweises Kurzfazit (z. B. „Sein Torwart ist +12 Punkte stärker").
    for (final position in positionComparisons) {
      final delta = position.pointsDelta;
      if (delta.abs() < positionSummaryThreshold) continue;
      final aIsBetter = delta > 0;
      final label = aIsBetter ? aLabel : bLabel;
      final text =
          '${_possessive(label, plural: false)} ${position.label} '
          'ist ${delta.abs()} Punkte stärker';
      if (aIsBetter) {
        strengths.add(text);
      } else {
        weaknesses.add(text);
      }
    }

    return ManagerComparison(
      a: a,
      b: b,
      rows: rows,
      positionComparisons: positionComparisons,
      strengths: strengths,
      weaknesses: weaknesses,
    );
  }

  /// Baut die Gegenüberstellungs-Zeilen der Kern-Kennzahlen.
  List<ComparisonRow> _buildRows(
    ManagerComparisonSide a,
    ManagerComparisonSide b,
  ) {
    final rows = <ComparisonRow>[
      ComparisonRow(
        metric: ComparisonMetric.squadValue,
        valueA: a.teamValue.toDouble(),
        valueB: b.teamValue.toDouble(),
      ),
      ComparisonRow(
        metric: ComparisonMetric.pointsLast5,
        valueA: a.pointsLast5.toDouble(),
        valueB: b.pointsLast5.toDouble(),
        note: 'letzte 5 Spieltage',
      ),
    ];

    // Budget nur gegenüberstellen, wenn es für beide Seiten berechenbar ist.
    final budgetA = a.budget;
    final budgetB = b.budget;
    if (budgetA != null && budgetB != null) {
      rows.add(
        ComparisonRow(
          metric: ComparisonMetric.budget,
          valueA: budgetA.toDouble(),
          valueB: budgetB.toDouble(),
        ),
      );
    }

    // Transfer-Erfolg = Ø Deal-Qualität (positiv = unter Marktwert gekauft).
    rows.add(
      ComparisonRow(
        metric: ComparisonMetric.transferSuccess,
        valueA: a.transferStats.avgDealQuality.toDouble(),
        valueB: b.transferStats.avgDealQuality.toDouble(),
        note:
            '${a.transferStats.purchaseCount} vs. '
            '${b.transferStats.purchaseCount} Käufe',
      ),
    );

    return rows;
  }

  /// Baut den positionsweisen Kadervergleich (Kaderwert + Punkte je Position).
  List<PositionComparison> _buildPositionComparisons(
    ManagerComparisonSide a,
    ManagerComparisonSide b,
  ) {
    final pointsA = {for (final p in a.positionPoints) p.position: p};
    final pointsB = {for (final p in b.positionPoints) p.position: p};
    final positions = <int>{...pointsA.keys, ...pointsB.keys}.toList()..sort();

    return positions.map((position) {
      final sideA = pointsA[position];
      final sideB = pointsB[position];
      return PositionComparison(
        position: position,
        pointsA: sideA?.points ?? 0,
        pointsB: sideB?.points ?? 0,
        marketValueA: sideA?.marketValue ?? 0,
        marketValueB: sideB?.marketValue ?? 0,
      );
    }).toList();
  }

  /// Besitzanzeige für das Kurzfazit: „Dein"/„Deine" oder „Annas".
  ///
  /// Für Namen wird der Genitiv gebildet („Ben" → „Bens", „Andi" → „Andis").
  String _possessive(String label, {required bool plural}) {
    if (label == 'Du') return plural ? 'Deine' : 'Dein';
    final genitive = label.endsWith('s') || label.endsWith('z')
        ? "$label'"
        : '${label}s';
    return genitive;
  }

  /// Formatiert einen Geldbetrag verkürzt (z. B. „3.2M€").
  String _money(num value) => '${(value / 1000000).toStringAsFixed(1)}M€';

  /// Formatiert einen Geldbetrag mit Vorzeichen (z. B. „+1.2M€").
  String _signedMoney(num value) => '${value >= 0 ? '+' : ''}${_money(value)}';
}
