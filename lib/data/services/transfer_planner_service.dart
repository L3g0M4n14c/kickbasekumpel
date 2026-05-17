import 'dart:math';

import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';

/// Erstellt deterministische Transfer-Szenarien mit legaler Formation.
class TransferPlannerService {
  /// Baut ausführbare Transfer-Pläne basierend auf Kader, Markt und Budget.
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    final currentSelection =
        _selectBestLegalLineup(input.squadPlayers) ??
        _selectSimpleLineup(input.squadPlayers);
    if (currentSelection.starters.isEmpty) {
      return const TransferPlannerResult(
        scenarios: [],
        noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
      );
    }

    final currentStarters = currentSelection.starters;
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

      final sells = <Player>[weakestStarter];
      var budgetAfter =
          input.currentBudget +
          weakestStarter.marketValue -
          marketPlayer.marketValue;

      if (budgetAfter < 0) {
        final sellCandidates =
            input.squadPlayers
                .where(
                  (player) =>
                      !currentStarters.any(
                        (starter) => starter.id == player.id,
                      ) &&
                      player.id != marketPlayer.id,
                )
                .toList()
              ..sort((a, b) => b.marketValue.compareTo(a.marketValue));

        for (final sellCandidate in sellCandidates) {
          sells.add(sellCandidate);
          budgetAfter += sellCandidate.marketValue;
          if (budgetAfter >= 0) {
            break;
          }
        }

        if (budgetAfter < 0) {
          continue;
        }
      }

      final resultingSquad = _buildResultingSquad(
        squadPlayers: input.squadPlayers,
        soldPlayers: sells,
        marketPlayer: marketPlayer,
      );
      final resultingSelection = currentSelection.isLegal
          ? _selectBestLegalLineup(resultingSquad)
          : null;
      if (currentSelection.isLegal && resultingSelection == null) {
        continue;
      }
      final resultingStarters =
          resultingSelection?.starters ??
          _selectSimpleLineup(resultingSquad).starters;
      if (!resultingStarters.any((player) => player.id == marketPlayer.id)) {
        continue;
      }

      scenarios.add(
        TransferPlanScenario(
          id: '${weakestStarter.id}-${marketPlayer.id}',
          title:
              '${weakestStarter.firstName} ${weakestStarter.lastName} -> ${marketPlayer.firstName} ${marketPlayer.lastName}',
          sells: sells
              .map(
                (sellPlayer) => TransferPlanMove.sell(
                  player: sellPlayer,
                  amount: sellPlayer.marketValue,
                ),
              )
              .toList(),
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
              'Startelf-Upgrade um ${startingGain.toStringAsFixed(1)} Punkte durch Transfer-Kette mit ${sells.length} Verkauf(en).',
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

  _LineupSelection? _selectBestLegalLineup(List<Player> squadPlayers) {
    final goalkeepers =
        squadPlayers.where((player) => player.position == 1).toList()
          ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    final defenders =
        squadPlayers.where((player) => player.position == 2).toList()
          ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    final midfielders =
        squadPlayers.where((player) => player.position == 3).toList()
          ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    final forwards =
        squadPlayers.where((player) => player.position == 4).toList()
          ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));

    if (goalkeepers.isEmpty) {
      return null;
    }

    _LineupSelection? bestSelection;
    for (final formation in _plannerFormations) {
      if (defenders.length < formation.defenders ||
          midfielders.length < formation.midfielders ||
          forwards.length < formation.forwards) {
        continue;
      }

      final starters = <Player>[
        goalkeepers.first,
        ...defenders.take(formation.defenders),
        ...midfielders.take(formation.midfielders),
        ...forwards.take(formation.forwards),
      ];

      final score = starters.fold<double>(
        0.0,
        (sum, player) => sum + player.averagePoints,
      );

      if (bestSelection == null || score > bestSelection.score) {
        bestSelection = _LineupSelection(
          starters: starters,
          score: score,
          isLegal: true,
        );
      }
    }

    return bestSelection;
  }

  _LineupSelection _selectSimpleLineup(List<Player> squadPlayers) {
    final starters = [...squadPlayers]
      ..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));

    final selected = starters.take(min(11, starters.length)).toList();
    final score = selected.fold<double>(
      0.0,
      (sum, player) => sum + player.averagePoints,
    );
    return _LineupSelection(starters: selected, score: score, isLegal: false);
  }

  List<Player> _buildResultingSquad({
    required List<Player> squadPlayers,
    required List<Player> soldPlayers,
    required Player marketPlayer,
  }) {
    final soldIds = soldPlayers.map((player) => player.id).toSet();
    return squadPlayers.where((player) => !soldIds.contains(player.id)).toList()
      ..add(marketPlayer);
  }
}

class _LineupSelection {
  const _LineupSelection({
    required this.starters,
    required this.score,
    required this.isLegal,
  });

  final List<Player> starters;
  final double score;
  final bool isLegal;
}

class _PlannerFormation {
  const _PlannerFormation({
    required this.defenders,
    required this.midfielders,
    required this.forwards,
  });

  final int defenders;
  final int midfielders;
  final int forwards;
}

const List<_PlannerFormation> _plannerFormations = [
  _PlannerFormation(defenders: 4, midfielders: 4, forwards: 2),
  _PlannerFormation(defenders: 4, midfielders: 2, forwards: 4),
  _PlannerFormation(defenders: 3, midfielders: 4, forwards: 3),
  _PlannerFormation(defenders: 4, midfielders: 3, forwards: 3),
  _PlannerFormation(defenders: 5, midfielders: 3, forwards: 2),
  _PlannerFormation(defenders: 3, midfielders: 5, forwards: 2),
  _PlannerFormation(defenders: 5, midfielders: 4, forwards: 1),
  _PlannerFormation(defenders: 4, midfielders: 5, forwards: 1),
  _PlannerFormation(defenders: 3, midfielders: 6, forwards: 1),
  _PlannerFormation(defenders: 5, midfielders: 2, forwards: 3),
];
