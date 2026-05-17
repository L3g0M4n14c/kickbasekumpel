import 'dart:math';

import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';

/// Erstellt deterministische 1:1-Transfer-Szenarien.
class TransferPlannerService {
  /// Baut ausführbare Transfer-Pläne basierend auf Kader, Markt und Budget.
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    final currentStarters = _pickCurrentStarters(input.squadPlayers);
    final scenarios = <TransferPlanScenario>[];

    for (final marketPlayer in input.marketPlayers) {
      final samePositionStarters = currentStarters
          .where((starter) => starter.position == marketPlayer.position)
          .toList();

      if (samePositionStarters.isEmpty) {
        continue;
      }

      final weakestStarter = samePositionStarters.reduce(
        (weakest, candidate) => candidate.averagePoints < weakest.averagePoints
            ? candidate
            : weakest,
      );

      final startingGain =
          marketPlayer.averagePoints - weakestStarter.averagePoints;
      if (startingGain <= 0) {
        continue;
      }

      final budgetAfter =
          input.currentBudget +
          weakestStarter.marketValue -
          marketPlayer.marketValue;
      if (budgetAfter < 0) {
        continue;
      }

      final resultingStarters = _replaceStarter(
        starters: currentStarters,
        weakestStarter: weakestStarter,
        marketPlayer: marketPlayer,
      );

      scenarios.add(
        TransferPlanScenario(
          id: '${weakestStarter.id}-${marketPlayer.id}',
          title:
              '${weakestStarter.firstName} ${weakestStarter.lastName} -> ${marketPlayer.firstName} ${marketPlayer.lastName}',
          sells: [
            TransferPlanMove.sell(
              player: weakestStarter,
              amount: weakestStarter.marketValue,
            ),
          ],
          buys: [
            TransferPlanMove.buy(
              player: marketPlayer,
              amount: marketPlayer.marketValue,
            ),
          ],
          resultingStarters: resultingStarters,
          budgetBefore: input.currentBudget,
          budgetAfter: budgetAfter,
          summary:
              'Startelf-Upgrade um ${startingGain.toStringAsFixed(1)} Punkte durch 1:1-Transfer.',
          warnings: const [],
          score: TransferPlanScore(
            startingElevenGain: startingGain,
            executionRisk: 0.0,
            valueStability: max(0, marketPlayer.marketValueTrend).toDouble(),
          ),
        ),
      );
    }

    scenarios.sort(
      (a, b) =>
          b.score.startingElevenGain.compareTo(a.score.startingElevenGain),
    );

    final topScenarios = scenarios.take(3).toList();
    if (topScenarios.isEmpty) {
      return const TransferPlannerResult(
        scenarios: [],
        noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
      );
    }

    return TransferPlannerResult(scenarios: topScenarios);
  }

  List<Player> _pickCurrentStarters(List<Player> squadPlayers) {
    final sorted = [...squadPlayers]
      ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    return sorted.take(11).toList();
  }

  List<Player> _replaceStarter({
    required List<Player> starters,
    required Player weakestStarter,
    required Player marketPlayer,
  }) {
    final updated =
        starters.where((starter) => starter.id != weakestStarter.id).toList()
          ..add(marketPlayer)
          ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    return updated.take(11).toList();
  }
}
