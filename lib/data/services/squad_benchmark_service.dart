import '../models/player_model.dart';
import '../models/squad_benchmark_model.dart';

/// Service für den positionsweisen Kader-Benchmark gegen die Liga.
///
/// Vergleicht den eigenen Kader (Marktwert, Punkte, Spieleranzahl) mit dem
/// Durchschnitt aller Manager der Liga – positionsweise. Grundlage sind die
/// Squad-Endpunkte aller Manager (`managers/{userId}/squad`) bzw. der eigene
/// Squad-Endpunkt (`/squad`).
class SquadBenchmarkService {
  /// Alle Kickbase-Positions-Codes, die im Benchmark erscheinen.
  static const List<int> allPositions = [1, 2, 3, 4];

  /// Aggregiert den Benchmark aus eigenem Kader und den Fremd-Kadern.
  ///
  /// [ownPlayers] - Spieler des eigenen Kaders (voller Player via `/squad`)
  /// [managerSquads] - Fremd-Kader als Roh-JSON-Maps pro Manager-ID
  ///   (Squad-Response `it`-Listen mit `mv`, `st`/`pt`, `pos`-Feldern)
  SquadBenchmark aggregate({
    required List<Player> ownPlayers,
    required Map<String, List<Map<String, dynamic>>> managerSquads,
  }) {
    // Fremd-Kader: Summen pro Position und Manager zählen.
    final mvByPos = {for (final p in allPositions) p: 0.0};
    final pointsByPos = {for (final p in allPositions) p: 0.0};
    final countByPos = {for (final p in allPositions) p: 0.0};

    var managersCounted = 0;
    var leagueTotalMv = 0.0;

    for (final squad in managerSquads.values) {
      if (squad.isEmpty) continue;
      managersCounted++;

      final perPosMv = {for (final p in allPositions) p: 0};
      final perPosPoints = {for (final p in allPositions) p: 0.0};
      final perPosCount = {for (final p in allPositions) p: 0};
      var squadMv = 0;

      for (final raw in squad) {
        final position = _asInt(raw['pos'] ?? raw['position']);
        if (!allPositions.contains(position)) continue;
        final mv = _asInt(raw['mv'] ?? raw['marketValue']);
        final points = _asDouble(raw['st'] ?? raw['pt'] ?? raw['totalPoints']);
        perPosMv[position] = perPosMv[position]! + mv;
        perPosPoints[position] = perPosPoints[position]! + points;
        perPosCount[position] = perPosCount[position]! + 1;
        squadMv += mv;
      }

      leagueTotalMv += squadMv;
      for (final p in allPositions) {
        mvByPos[p] = mvByPos[p]! + perPosMv[p]!;
        pointsByPos[p] = pointsByPos[p]! + perPosPoints[p]!;
        countByPos[p] = countByPos[p]! + perPosCount[p]!;
      }
    }

    // Eigener Kader: Summen pro Position.
    final ownMvByPos = {for (final p in allPositions) p: 0};
    final ownPointsSumByPos = {for (final p in allPositions) p: 0.0};
    final ownCountByPos = {for (final p in allPositions) p: 0};
    var ownTotalMv = 0;

    for (final player in ownPlayers) {
      if (!allPositions.contains(player.position)) continue;
      ownMvByPos[player.position] =
          ownMvByPos[player.position]! + player.marketValue;
      ownPointsSumByPos[player.position] =
          ownPointsSumByPos[player.position]! + player.totalPoints;
      ownCountByPos[player.position] = ownCountByPos[player.position]! + 1;
      ownTotalMv += player.marketValue;
    }

    final rows = allPositions.map((p) {
      final managerCountForPos = managersCounted;
      return PositionBenchmark(
        position: p,
        ownMarketValue: ownMvByPos[p]!,
        leagueAvgMarketValue: managerCountForPos > 0
            ? mvByPos[p]! / managerCountForPos
            : 0,
        ownAvgPoints: ownCountByPos[p]! > 0
            ? ownPointsSumByPos[p]! / ownCountByPos[p]!
            : 0,
        leagueAvgPoints: managerCountForPos > 0
            ? pointsByPos[p]! / managerCountForPos
            : 0,
        ownCount: ownCountByPos[p]!,
        leagueAvgCount: managerCountForPos > 0
            ? countByPos[p]! / managerCountForPos
            : 0,
      );
    }).toList();

    return SquadBenchmark(
      positions: rows,
      managerCount: managersCounted,
      ownTotalMarketValue: ownTotalMv,
      leagueAvgTotalMarketValue: managersCounted > 0
          ? leagueTotalMv / managersCounted
          : 0,
    );
  }

  int _asInt(Object? value) => switch (value) {
    int value => value,
    num value => value.toInt(),
    String value => int.tryParse(value) ?? 0,
    _ => 0,
  };

  double _asDouble(Object? value) => switch (value) {
    int value => value.toDouble(),
    double value => value,
    num value => value.toDouble(),
    String value => double.tryParse(value) ?? 0,
    _ => 0,
  };
}
