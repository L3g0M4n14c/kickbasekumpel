import 'dart:math';

import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:logger/logger.dart';

/// Ablehnungsgrund eines einzelnen Szenario-Versuchs in [_buildScenario].
enum _ScenarioRejection {
  /// Budget + Verkäufe decken den Kaufpreis nicht.
  unaffordable,

  /// Die resultierende Startelf wäre nicht mehr legal (nur bei aktuell
  /// legaler Startelf).
  illegalLineup,

  /// Der Marktspieler schafft nach dem Transfer nicht die Startelf.
  notInXI,

  /// Kein positiver Punktegewinn für die Startelf.
  noGain,
}

/// Erstellt deterministische Transfer-Szenarien mit legaler Formation.
class TransferPlannerService {
  final Logger _logger = Logger();

  /// Baut ausführbare Transfer-Pläne basierend auf Kader, Markt und Budget.
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    _logger.i(
      '📊 buildPlans: Kader=${input.squadPlayers.length} '
      '(${_positionHistogram(input.squadPlayers)}), '
      'Markt=${input.marketPlayers.length} '
      '(${_positionHistogram(input.marketPlayers)}), '
      'Budget=${input.currentBudget} €, '
      'Startelf-legal=${_selectBestLegalLineup(input.squadPlayers) != null}',
    );

    final currentSelection =
        _selectBestLegalLineup(input.squadPlayers) ??
        _selectSimpleLineup(input.squadPlayers);
    if (currentSelection.starters.isEmpty) {
      _logger.w('🚫 buildPlans: Kader leer – kein Startelf-Spieler verfügbar');
      return TransferPlannerResult(
        scenarios: const [],
        noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
        noPlanDetails:
            'Dein Kader ist leer (0 auswertbare Spieler) – '
            'die Kaderdaten konnten nicht geladen werden.',
      );
    }

    final currentStarters = currentSelection.starters;
    final scenarios = <TransferPlanScenario>[];
    var skippedNoPosition = 0;
    var rejectedUnaffordable = 0;
    var rejectedIllegalLineup = 0;
    var rejectedNotInXI = 0;
    var rejectedNoGain = 0;

    void handleRejection(_ScenarioRejection reason) {
      switch (reason) {
        case _ScenarioRejection.unaffordable:
          rejectedUnaffordable++;
        case _ScenarioRejection.illegalLineup:
          rejectedIllegalLineup++;
        case _ScenarioRejection.notInXI:
          rejectedNotInXI++;
        case _ScenarioRejection.noGain:
          rejectedNoGain++;
      }
    }

    for (final marketPlayer in input.marketPlayers) {
      final samePositionStarters = currentStarters
          .where((starter) => starter.position == marketPlayer.position)
          .toList();
      if (samePositionStarters.isEmpty && currentSelection.isLegal) {
        skippedNoPosition++;
        continue;
      }
      final weakestCurrentStarters = [...currentStarters]
        ..sort(_comparePlayersByWeakness);

      samePositionStarters.sort(_comparePlayersByWeakness);
      final weakestStarter = samePositionStarters.isEmpty
          ? null
          : samePositionStarters.first;

      final baseSellOptions = <List<Player>>[
        if (weakestStarter == null || !currentSelection.isLegal) <Player>[],
        if (weakestStarter != null) <Player>[weakestStarter],
      ];
      final crossPositionFallbackSells = weakestCurrentStarters
          .where((candidate) => candidate.id != weakestStarter?.id)
          .take(4)
          .toList();

      TransferPlanScenario? bestScenarioForMarket;
      for (final baseSells in baseSellOptions) {
        final scenario = _buildScenario(
          input: input,
          currentSelection: currentSelection,
          marketPlayer: marketPlayer,
          weakestStarter: weakestStarter,
          baseSells: baseSells,
          onReject: handleRejection,
        );
        if (scenario == null) {
          continue;
        }
        if (bestScenarioForMarket == null ||
            _compareScenarioPriority(scenario, bestScenarioForMarket) < 0) {
          bestScenarioForMarket = scenario;
        }
      }

      if (bestScenarioForMarket == null) {
        for (final fallbackSell in crossPositionFallbackSells) {
          final scenario = _buildScenario(
            input: input,
            currentSelection: currentSelection,
            marketPlayer: marketPlayer,
            weakestStarter: weakestStarter,
            baseSells: [fallbackSell],
            onReject: handleRejection,
          );
          if (scenario == null) {
            continue;
          }
          if (bestScenarioForMarket == null ||
              _compareScenarioPriority(scenario, bestScenarioForMarket) < 0) {
            bestScenarioForMarket = scenario;
          }
        }
      }

      if (bestScenarioForMarket != null) {
        scenarios.add(bestScenarioForMarket);
      }
    }

    scenarios.sort((a, b) {
      final gainCompare = b.score.startingElevenGain.compareTo(
        a.score.startingElevenGain,
      );
      if (gainCompare != 0) {
        return gainCompare;
      }
      final stabilityCompare = b.score.valueStability.compareTo(
        a.score.valueStability,
      );
      if (stabilityCompare != 0) {
        return stabilityCompare;
      }
      return a.id.compareTo(b.id);
    });

    final topScenarios = scenarios.take(3).toList();
    if (topScenarios.isEmpty) {
      final details = _buildNoPlanDetails(
        marketCount: input.marketPlayers.length,
        skippedNoPosition: skippedNoPosition,
        unaffordable: rejectedUnaffordable,
        illegalLineup: rejectedIllegalLineup,
        notInXI: rejectedNotInXI,
        noGain: rejectedNoGain,
      );
      _logger.w('🚫 buildPlans: kein Szenario – $details');
      return TransferPlannerResult(
        scenarios: const [],
        noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
        noPlanDetails: details,
      );
    }

    _logger.i('✅ buildPlans: ${topScenarios.length} Szenarien erstellt');
    return TransferPlannerResult(scenarios: topScenarios);
  }

  /// Baut die Diagnose-Unterzeile, wenn kein Szenario übrig geblieben ist.
  ///
  /// Die Zählungen machen die konkrete Ursache sichtbar: leerer Markt,
  /// Positions-Mismatch, fehlendes Budget oder fehlender Punktegewinn.
  String _buildNoPlanDetails({
    required int marketCount,
    required int skippedNoPosition,
    required int unaffordable,
    required int illegalLineup,
    required int notInXI,
    required int noGain,
  }) {
    if (marketCount == 0) {
      return 'Der Markt liefert aktuell 0 Spieler – es gibt nichts zu kaufen. '
          'Prüfe den Markt-Spieler-Tab in der App.';
    }

    final parts = <String>[];
    if (skippedNoPosition > 0) {
      parts.add(
        '$skippedNoPosition von $marketCount ohne passende Position '
        'in der Startelf',
      );
    }
    if (unaffordable > 0) {
      parts.add(
        '$unaffordable× nicht finanzierbar '
        '(Budget + Verkäufe reichen nicht aus)',
      );
    }
    if (illegalLineup > 0) {
      parts.add('$illegalLineup× würde die Startelf-Formation zerstören');
    }
    if (notInXI > 0) {
      parts.add('$notInXI× schafft nicht die Startelf');
    }
    if (noGain > 0) {
      parts.add('$noGain× ohne Punktegewinn für die Startelf');
    }

    if (parts.isEmpty) {
      return 'Untersucht: $marketCount Marktspieler – '
          'keiner erfüllt die Planungsbedingungen.';
    }
    return 'Untersucht: $marketCount Marktspieler. '
        'Ablehnungsgründe: ${parts.join('; ')}.';
  }

  /// Kurz-Histogramm der Positions-Codes (1=TW, 2=ABW, 3=MF, 4=ST)
  /// für die Diagnose-Logging-Ausgabe.
  String _positionHistogram(List<Player> players) {
    var tw = 0;
    var abw = 0;
    var mf = 0;
    var st = 0;
    var other = 0;
    for (final player in players) {
      switch (player.position) {
        case 1:
          tw++;
        case 2:
          abw++;
        case 3:
          mf++;
        case 4:
          st++;
        default:
          other++;
      }
    }
    return 'TW=$tw ABW=$abw MF=$mf ST=$st sonst=$other';
  }

  _LineupSelection? _selectBestLegalLineup(List<Player> squadPlayers) {
    final goalkeepers =
        squadPlayers.where((player) => player.position == 1).toList()
          ..sort(_comparePlayersByStrength);
    final defenders =
        squadPlayers.where((player) => player.position == 2).toList()
          ..sort(_comparePlayersByStrength);
    final midfielders =
        squadPlayers.where((player) => player.position == 3).toList()
          ..sort(_comparePlayersByStrength);
    final forwards =
        squadPlayers.where((player) => player.position == 4).toList()
          ..sort(_comparePlayersByStrength);

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

      if (bestSelection == null ||
          score > bestSelection.score ||
          (score == bestSelection.score &&
              _lineupSignature(
                    starters,
                  ).compareTo(_lineupSignature(bestSelection.starters)) <
                  0)) {
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
    final starters = [...squadPlayers]..sort(_comparePlayersByStrength);

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

  TransferPlanScenario? _buildScenario({
    required TransferPlannerInput input,
    required _LineupSelection currentSelection,
    required Player marketPlayer,
    required Player? weakestStarter,
    required List<Player> baseSells,
    void Function(_ScenarioRejection reason)? onReject,
  }) {
    final sells = List<Player>.from(baseSells);
    var budgetAfter =
        input.currentBudget +
        sells.fold<int>(0, (sum, player) => sum + player.marketValue) -
        marketPlayer.marketValue;

    if (budgetAfter < 0) {
      final additionalSales = _findAdditionalSales(
        squadPlayers: input.squadPlayers,
        excludedIds: {...sells.map((player) => player.id), marketPlayer.id},
        requiredAmount: -budgetAfter,
      );
      if (additionalSales == null) {
        onReject?.call(_ScenarioRejection.unaffordable);
        return null;
      }
      sells.addAll(additionalSales);
      budgetAfter += additionalSales.fold<int>(
        0,
        (sum, player) => sum + player.marketValue,
      );
    }

    final resultingSquad = _buildResultingSquad(
      squadPlayers: input.squadPlayers,
      soldPlayers: sells,
      marketPlayer: marketPlayer,
    );
    final resultingLegalSelection = _selectBestLegalLineup(resultingSquad);
    if (currentSelection.isLegal && resultingLegalSelection == null) {
      onReject?.call(_ScenarioRejection.illegalLineup);
      return null;
    }
    final resultingSelection =
        resultingLegalSelection ?? _selectSimpleLineup(resultingSquad);
    final resultingStarters = resultingSelection.starters;
    if (!resultingStarters.any((player) => player.id == marketPlayer.id)) {
      onReject?.call(_ScenarioRejection.notInXI);
      return null;
    }
    final finalGain = resultingSelection.score - currentSelection.score;
    if (finalGain <= 0) {
      onReject?.call(_ScenarioRejection.noGain);
      return null;
    }

    return TransferPlanScenario(
      id:
          weakestStarter != null &&
              sells.any((sell) => sell.id == weakestStarter.id)
          ? '${weakestStarter.id}-${marketPlayer.id}'
          : 'add-${marketPlayer.id}',
      title:
          weakestStarter != null &&
              sells.any((sell) => sell.id == weakestStarter.id)
          ? '${weakestStarter.firstName} ${weakestStarter.lastName} -> ${marketPlayer.firstName} ${marketPlayer.lastName}'
          : 'Add ${marketPlayer.firstName} ${marketPlayer.lastName}',
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
          'Finales Startelf-Upgrade um ${finalGain.toStringAsFixed(1)} Punkte durch Transfer-Kette mit ${sells.length} Verkauf(en).',
      warnings: const [],
      score: TransferPlanScore(
        startingElevenGain: finalGain,
        executionRisk: 0.0,
        valueStability: max(0, marketPlayer.marketValueTrend).toDouble(),
      ),
    );
  }

  List<Player>? _findAdditionalSales({
    required List<Player> squadPlayers,
    required Set<String> excludedIds,
    required int requiredAmount,
  }) {
    final candidates = squadPlayers
        .where((player) => !excludedIds.contains(player.id))
        .toList();

    candidates.sort(_compareSalesCandidate);

    for (var chainLength = 1; chainLength <= candidates.length; chainLength++) {
      List<Player>? bestChain;
      _searchSalesChains(
        candidates: candidates,
        requiredAmount: requiredAmount,
        chainLength: chainLength,
        startIndex: 0,
        currentSelection: <Player>[],
        currentAmount: 0,
        onCandidate: (candidate) {
          if (bestChain == null ||
              _compareSalesChains(candidate, bestChain!) < 0) {
            bestChain = List<Player>.from(candidate);
          }
        },
      );

      if (bestChain != null) {
        return bestChain;
      }
    }

    return null;
  }

  void _searchSalesChains({
    required List<Player> candidates,
    required int requiredAmount,
    required int chainLength,
    required int startIndex,
    required List<Player> currentSelection,
    required int currentAmount,
    required void Function(List<Player>) onCandidate,
  }) {
    if (currentSelection.length == chainLength) {
      if (currentAmount >= requiredAmount) {
        onCandidate(currentSelection);
      }
      return;
    }

    final remainingSlots = chainLength - currentSelection.length;
    final maxStart = candidates.length - remainingSlots;
    for (var index = startIndex; index <= maxStart; index++) {
      currentSelection.add(candidates[index]);
      _searchSalesChains(
        candidates: candidates,
        requiredAmount: requiredAmount,
        chainLength: chainLength,
        startIndex: index + 1,
        currentSelection: currentSelection,
        currentAmount: currentAmount + candidates[index].marketValue,
        onCandidate: onCandidate,
      );
      currentSelection.removeLast();
    }
  }

  int _comparePlayersByStrength(Player a, Player b) {
    final avgCompare = b.averagePoints.compareTo(a.averagePoints);
    if (avgCompare != 0) {
      return avgCompare;
    }
    final valueCompare = b.marketValue.compareTo(a.marketValue);
    if (valueCompare != 0) {
      return valueCompare;
    }
    return a.id.compareTo(b.id);
  }

  int _comparePlayersByWeakness(Player a, Player b) {
    final avgCompare = a.averagePoints.compareTo(b.averagePoints);
    if (avgCompare != 0) {
      return avgCompare;
    }
    final valueCompare = a.marketValue.compareTo(b.marketValue);
    if (valueCompare != 0) {
      return valueCompare;
    }
    return a.id.compareTo(b.id);
  }

  int _compareSalesCandidate(Player a, Player b) {
    final weaknessCompare = _comparePlayersByWeakness(a, b);
    if (weaknessCompare != 0) {
      return weaknessCompare;
    }
    return a.id.compareTo(b.id);
  }

  int _compareSalesChains(List<Player> a, List<Player> b) {
    final aAvg = a.fold<double>(0, (sum, player) => sum + player.averagePoints);
    final bAvg = b.fold<double>(0, (sum, player) => sum + player.averagePoints);
    final avgCompare = aAvg.compareTo(bAvg);
    if (avgCompare != 0) {
      return avgCompare;
    }

    final aValue = a.fold<int>(0, (sum, player) => sum + player.marketValue);
    final bValue = b.fold<int>(0, (sum, player) => sum + player.marketValue);
    final valueCompare = aValue.compareTo(bValue);
    if (valueCompare != 0) {
      return valueCompare;
    }

    final sortedA = [...a]..sort((x, y) => x.id.compareTo(y.id));
    final sortedB = [...b]..sort((x, y) => x.id.compareTo(y.id));
    for (var index = 0; index < sortedA.length; index++) {
      final idCompare = sortedA[index].id.compareTo(sortedB[index].id);
      if (idCompare != 0) {
        return idCompare;
      }
    }
    return 0;
  }

  String _lineupSignature(List<Player> starters) {
    final ids = starters.map((player) => player.id).toList()..sort();
    return ids.join('|');
  }

  int _compareScenarioPriority(TransferPlanScenario a, TransferPlanScenario b) {
    final gainCompare = b.score.startingElevenGain.compareTo(
      a.score.startingElevenGain,
    );
    if (gainCompare != 0) {
      return gainCompare;
    }
    final sellCountCompare = a.sells.length.compareTo(b.sells.length);
    if (sellCountCompare != 0) {
      return sellCountCompare;
    }
    return a.id.compareTo(b.id);
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
