import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';

void main() {
  group('TransferPlannerService', () {
    late TransferPlannerService service;

    setUp(() {
      service = TransferPlannerService();
    });

    test(
      'returns top 3 executable scenarios sorted by starting eleven gain',
      () {
        final result = service.buildPlans(_buildInputWithUpgrades());

        expect(result.noPlanReason, isNull);
        expect(result.scenarios, hasLength(3));
        expect(
          result.scenarios
              .map((scenario) => scenario.score.startingElevenGain)
              .toList(),
          orderedEquals([5.0, 4.0, 3.0]),
        );
      },
    );

    test('ensures every returned scenario has a non-negative budget after', () {
      final result = service.buildPlans(_buildInputWithUpgrades());

      expect(
        result.scenarios.every((scenario) => scenario.budgetAfter >= 0),
        isTrue,
      );
    });

    test(
      'falls back to partial-squad evaluation when no legal XI exists yet',
      () {
        final result = service.buildPlans(_buildPartialSquadInput());

        expect(result.noPlanReason, isNull);
        expect(result.scenarios, hasLength(1));
        expect(result.scenarios.first.score.startingElevenGain, 3.0);
      },
    );

    test('proposes filling a missing position in partial-squad fallback', () {
      final result = service.buildPlans(_buildPartialSquadMissingDefender());

      expect(result.noPlanReason, isNull);
      expect(result.scenarios, hasLength(1));
      expect(
        result.scenarios.single.buys.single.player.id,
        'partial-market-def-missing',
      );
      expect(result.scenarios.single.score.startingElevenGain, 4.0);
    });

    test(
      'rejects missing-position candidates without positive upgrade signal',
      () {
        final result = service.buildPlans(
          _buildPartialSquadMissingDefenderWithoutGain(),
        );

        expect(result.scenarios, isEmpty);
        expect(
          result.noPlanReason,
          'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
        );
      },
    );

    test(
      'uses legal formation starters when evaluating same-position upgrades',
      () {
        final result = service.buildPlans(
          _buildInputForLegalFormationUpgrade(),
        );

        final scenario = result.scenarios.singleWhere(
          (candidate) => candidate.buys.any(
            (buy) => buy.player.id == 'market-def-upgrade',
          ),
        );

        expect(scenario.score.startingElevenGain, 4.0);
        expect(
          scenario.sells.any((sell) => sell.player.id == 'starter-def-weak'),
          isTrue,
        );
      },
    );

    test('keeps resulting starters in a legal 1-3-6-1 to 1-5-2-3 range', () {
      final result = service.buildPlans(_buildInputWithUpgrades());

      for (final scenario in result.scenarios) {
        final gk = scenario.resultingStarters
            .where((p) => p.position == 1)
            .length;
        final def = scenario.resultingStarters
            .where((p) => p.position == 2)
            .length;
        final mid = scenario.resultingStarters
            .where((p) => p.position == 3)
            .length;
        final fwd = scenario.resultingStarters
            .where((p) => p.position == 4)
            .length;

        expect(gk, 1);
        expect(def + mid + fwd, 10);
        expect(def, inInclusiveRange(3, 5));
        expect(mid, inInclusiveRange(2, 6));
        expect(fwd, inInclusiveRange(1, 4));
      }
    });

    test(
      'creates multi-move scenario when two sells are needed for one upgrade',
      () {
        final result = service.buildPlans(_buildInputRequiringTwoSells());

        final multiMoveScenario = result.scenarios.singleWhere(
          (scenario) =>
              scenario.buys.any((buy) => buy.player.id == 'market-star-fwd'),
        );

        expect(multiMoveScenario.sells, hasLength(2));
        expect(multiMoveScenario.buys, hasLength(1));
        expect(
          multiMoveScenario.sells.map((move) => move.player.id),
          containsAll(['starter-fwd-3', 'bench-def-low']),
        );
        expect(multiMoveScenario.budgetAfter, 1000000);
        expect(multiMoveScenario.score.startingElevenGain, 4.0);
      },
    );

    test(
      'supports starter-funded multi-sell chains when bench sales are not enough',
      () {
        final result = service.buildPlans(_buildInputRequiringStarterFunding());

        final scenario = result.scenarios.singleWhere(
          (candidate) => candidate.buys.any(
            (buy) => buy.player.id == 'market-fwd-premium',
          ),
        );

        expect(scenario.sells.length, 2);
        expect(
          scenario.sells.any((sell) => sell.player.id == 'starter-mid-4'),
          isTrue,
        );
      },
    );

    test(
      'drops scenarios where extra starter sales turn final XI into regression',
      () {
        final result = service.buildPlans(
          _buildInputWithRegressionAfterSales(),
        );

        expect(result.scenarios, isEmpty);
        expect(
          result.noPlanReason,
          'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
        );
      },
    );

    test(
      'uses deterministic tie-breakers for same-score same-position starter selection',
      () {
        final result = service.buildPlans(_buildTieBreakerInput());
        final scenario = result.scenarios.single;

        expect(scenario.sells.single.player.id, 'starter-def-a');
      },
    );

    test('prefers minimal deterministic extra-sale chain', () {
      final result = service.buildPlans(_buildInputForMinimalExtraSales());
      final scenario = result.scenarios.singleWhere(
        (candidate) =>
            candidate.buys.any((buy) => buy.player.id == 'market-fwd-costly'),
      );

      expect(scenario.sells.map((sell) => sell.player.id), hasLength(3));
      expect(
        scenario.sells.map((sell) => sell.player.id),
        containsAll(['starter-fwd-3', 'bench-def-five', 'bench-def-six']),
      );
    });

    test(
      'recomputes a legal XI after partial-squad transfer when now possible',
      () {
        final result = service.buildPlans(_buildPartialBecomesLegalAfterBuy());

        final scenario = result.scenarios.singleWhere(
          (candidate) => candidate.buys.any(
            (buy) => buy.player.id == 'market-low-forward',
          ),
        );

        final gk = scenario.resultingStarters
            .where((p) => p.position == 1)
            .length;
        final def = scenario.resultingStarters
            .where((p) => p.position == 2)
            .length;
        final mid = scenario.resultingStarters
            .where((p) => p.position == 3)
            .length;
        final fwd = scenario.resultingStarters
            .where((p) => p.position == 4)
            .length;

        expect(gk, 1);
        expect(def + mid + fwd, 10);
        expect(def, inInclusiveRange(3, 5));
        expect(mid, inInclusiveRange(2, 6));
        expect(fwd, inInclusiveRange(1, 4));
        expect(
          scenario.resultingStarters.any(
            (player) => player.id == 'market-low-forward',
          ),
          isTrue,
        );
      },
    );

    test('returns noPlanReason when no upgrade beats current starters', () {
      final input = TransferPlannerInput(
        squadPlayers: _buildSquadPlayers(),
        marketPlayers: [
          _player(
            id: 'market-flat',
            firstName: 'Market',
            lastName: 'Flat',
            position: 2,
            averagePoints: 5.0,
            marketValue: 3000000,
          ),
          _player(
            id: 'market-weaker',
            firstName: 'Market',
            lastName: 'Weaker',
            position: 4,
            averagePoints: 2.0,
            marketValue: 3000000,
          ),
        ],
        currentBudget: 1000000,
      );

      final result = service.buildPlans(input);

      expect(result.scenarios, isEmpty);
      expect(
        result.noPlanReason,
        'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
      );
    });
  });
}

TransferPlannerInput _buildInputWithUpgrades() {
  return TransferPlannerInput(
    squadPlayers: _buildSquadPlayers(),
    marketPlayers: [
      _player(
        id: 'market-fwd-expensive',
        firstName: 'Elite',
        lastName: 'Forward',
        position: 4,
        averagePoints: 10.0,
        marketValue: 7000000,
        marketValueTrend: 2,
      ),
      _player(
        id: 'market-fwd-top',
        firstName: 'Top',
        lastName: 'Forward',
        position: 4,
        averagePoints: 9.0,
        marketValue: 5000000,
        marketValueTrend: 5,
      ),
      _player(
        id: 'market-mid-expensive',
        firstName: 'Elite',
        lastName: 'Mid',
        position: 3,
        averagePoints: 9.0,
        marketValue: 8000000,
        marketValueTrend: 3,
      ),
      _player(
        id: 'market-mid-solid',
        firstName: 'Solid',
        lastName: 'Mid',
        position: 3,
        averagePoints: 8.0,
        marketValue: 6000000,
        marketValueTrend: 1,
      ),
      _player(
        id: 'market-def-third',
        firstName: 'Strong',
        lastName: 'Defender',
        position: 2,
        averagePoints: 8.0,
        marketValue: 4000000,
        marketValueTrend: -4,
      ),
      _player(
        id: 'market-def-second',
        firstName: 'Cheaper',
        lastName: 'Defender',
        position: 2,
        averagePoints: 9.0,
        marketValue: 3000000,
        marketValueTrend: 3,
      ),
    ],
    currentBudget: 1000000,
  );
}

TransferPlannerInput _buildInputRequiringTwoSells() {
  return TransferPlannerInput(
    squadPlayers: _buildSquadPlayersWithBench(),
    marketPlayers: [
      _player(
        id: 'market-star-fwd',
        firstName: 'Star',
        lastName: 'Forward',
        position: 4,
        averagePoints: 8.0,
        marketValue: 7000000,
        marketValueTrend: 4,
      ),
    ],
    currentBudget: 0,
  );
}

TransferPlannerInput _buildInputForLegalFormationUpgrade() {
  return TransferPlannerInput(
    squadPlayers: [
      _player(
        id: 'starter-gk',
        firstName: 'Starter',
        lastName: 'Goalie',
        position: 1,
        averagePoints: 8.0,
        marketValue: 9000000,
      ),
      _player(
        id: 'starter-def-1',
        firstName: 'Starter',
        lastName: 'Def One',
        position: 2,
        averagePoints: 9.0,
        marketValue: 9000000,
      ),
      _player(
        id: 'starter-def-2',
        firstName: 'Starter',
        lastName: 'Def Two',
        position: 2,
        averagePoints: 8.0,
        marketValue: 8500000,
      ),
      _player(
        id: 'starter-def-weak',
        firstName: 'Starter',
        lastName: 'Def Weak',
        position: 2,
        averagePoints: 1.0,
        marketValue: 2000000,
      ),
      _player(
        id: 'bench-def-extra',
        firstName: 'Bench',
        lastName: 'Def Extra',
        position: 2,
        averagePoints: 0.5,
        marketValue: 1000000,
      ),
      _player(
        id: 'starter-mid-1',
        firstName: 'Starter',
        lastName: 'Mid One',
        position: 3,
        averagePoints: 8.0,
        marketValue: 7000000,
      ),
      _player(
        id: 'starter-mid-2',
        firstName: 'Starter',
        lastName: 'Mid Two',
        position: 3,
        averagePoints: 8.0,
        marketValue: 7000000,
      ),
      _player(
        id: 'starter-mid-3',
        firstName: 'Starter',
        lastName: 'Mid Three',
        position: 3,
        averagePoints: 8.0,
        marketValue: 7000000,
      ),
      _player(
        id: 'starter-mid-4',
        firstName: 'Starter',
        lastName: 'Mid Four',
        position: 3,
        averagePoints: 8.0,
        marketValue: 7000000,
      ),
      _player(
        id: 'starter-fwd-1',
        firstName: 'Starter',
        lastName: 'Fwd One',
        position: 4,
        averagePoints: 10.0,
        marketValue: 10000000,
      ),
      _player(
        id: 'starter-fwd-2',
        firstName: 'Starter',
        lastName: 'Fwd Two',
        position: 4,
        averagePoints: 10.0,
        marketValue: 10000000,
      ),
      _player(
        id: 'starter-fwd-3',
        firstName: 'Starter',
        lastName: 'Fwd Three',
        position: 4,
        averagePoints: 10.0,
        marketValue: 10000000,
      ),
      _player(
        id: 'starter-fwd-4',
        firstName: 'Starter',
        lastName: 'Fwd Four',
        position: 4,
        averagePoints: 10.0,
        marketValue: 10000000,
      ),
      _player(
        id: 'bench-fwd-5',
        firstName: 'Bench',
        lastName: 'Fwd Five',
        position: 4,
        averagePoints: 9.0,
        marketValue: 9000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'market-def-upgrade',
        firstName: 'Market',
        lastName: 'Def Upgrade',
        position: 2,
        averagePoints: 5.0,
        marketValue: 2500000,
        marketValueTrend: 1,
      ),
    ],
    currentBudget: 1000000,
  );
}

TransferPlannerInput _buildPartialSquadInput() {
  return TransferPlannerInput(
    squadPlayers: [
      _player(
        id: 'partial-gk',
        firstName: 'Partial',
        lastName: 'Goalie',
        position: 1,
        averagePoints: 5.0,
        marketValue: 6000000,
      ),
      _player(
        id: 'partial-def-weak',
        firstName: 'Partial',
        lastName: 'Def Weak',
        position: 2,
        averagePoints: 2.0,
        marketValue: 3000000,
      ),
      _player(
        id: 'partial-mid',
        firstName: 'Partial',
        lastName: 'Mid',
        position: 3,
        averagePoints: 6.0,
        marketValue: 5000000,
      ),
      _player(
        id: 'partial-fwd',
        firstName: 'Partial',
        lastName: 'Fwd',
        position: 4,
        averagePoints: 4.0,
        marketValue: 4000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'partial-market-def',
        firstName: 'Market',
        lastName: 'Def Better',
        position: 2,
        averagePoints: 5.0,
        marketValue: 2500000,
      ),
    ],
    currentBudget: 0,
  );
}

TransferPlannerInput _buildPartialSquadMissingDefender() {
  return TransferPlannerInput(
    squadPlayers: [
      _player(
        id: 'partial-gk-only',
        firstName: 'Partial',
        lastName: 'Goalie',
        position: 1,
        averagePoints: 5.0,
        marketValue: 6000000,
      ),
      _player(
        id: 'partial-mid-only',
        firstName: 'Partial',
        lastName: 'Mid',
        position: 3,
        averagePoints: 6.0,
        marketValue: 5000000,
      ),
      _player(
        id: 'partial-fwd-only',
        firstName: 'Partial',
        lastName: 'Fwd',
        position: 4,
        averagePoints: 4.0,
        marketValue: 4000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'partial-market-def-missing',
        firstName: 'Market',
        lastName: 'Missing Defender',
        position: 2,
        averagePoints: 4.0,
        marketValue: 2500000,
      ),
    ],
    currentBudget: 3000000,
  );
}

TransferPlannerInput _buildPartialSquadMissingDefenderWithoutGain() {
  return TransferPlannerInput(
    squadPlayers: [
      _player(
        id: 'partial-gk-only',
        firstName: 'Partial',
        lastName: 'Goalie',
        position: 1,
        averagePoints: 5.0,
        marketValue: 6000000,
      ),
      _player(
        id: 'partial-mid-only',
        firstName: 'Partial',
        lastName: 'Mid',
        position: 3,
        averagePoints: 6.0,
        marketValue: 5000000,
      ),
      _player(
        id: 'partial-fwd-only',
        firstName: 'Partial',
        lastName: 'Fwd',
        position: 4,
        averagePoints: 4.0,
        marketValue: 4000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'partial-market-def-flat',
        firstName: 'Market',
        lastName: 'Flat Defender',
        position: 2,
        averagePoints: 0.0,
        marketValue: 2500000,
      ),
    ],
    currentBudget: 3000000,
  );
}

TransferPlannerInput _buildPartialBecomesLegalAfterBuy() {
  return TransferPlannerInput(
    squadPlayers: [
      _player(
        id: 'partial-gk',
        firstName: 'Partial',
        lastName: 'Goalie',
        position: 1,
        averagePoints: 8.0,
        marketValue: 9000000,
      ),
      _player(
        id: 'partial-def-1',
        firstName: 'Partial',
        lastName: 'Def One',
        position: 2,
        averagePoints: 9.0,
        marketValue: 9000000,
      ),
      _player(
        id: 'partial-def-2',
        firstName: 'Partial',
        lastName: 'Def Two',
        position: 2,
        averagePoints: 8.0,
        marketValue: 8000000,
      ),
      _player(
        id: 'partial-def-3',
        firstName: 'Partial',
        lastName: 'Def Three',
        position: 2,
        averagePoints: 7.0,
        marketValue: 7000000,
      ),
      _player(
        id: 'partial-def-4',
        firstName: 'Partial',
        lastName: 'Def Four',
        position: 2,
        averagePoints: 6.0,
        marketValue: 6000000,
      ),
      _player(
        id: 'partial-def-5',
        firstName: 'Partial',
        lastName: 'Def Five',
        position: 2,
        averagePoints: 5.0,
        marketValue: 5000000,
      ),
      _player(
        id: 'partial-mid-1',
        firstName: 'Partial',
        lastName: 'Mid One',
        position: 3,
        averagePoints: 9.0,
        marketValue: 9000000,
      ),
      _player(
        id: 'partial-mid-2',
        firstName: 'Partial',
        lastName: 'Mid Two',
        position: 3,
        averagePoints: 8.0,
        marketValue: 8000000,
      ),
      _player(
        id: 'partial-mid-3',
        firstName: 'Partial',
        lastName: 'Mid Three',
        position: 3,
        averagePoints: 7.0,
        marketValue: 7000000,
      ),
      _player(
        id: 'partial-mid-4',
        firstName: 'Partial',
        lastName: 'Mid Four',
        position: 3,
        averagePoints: 6.0,
        marketValue: 6000000,
      ),
      _player(
        id: 'partial-mid-5',
        firstName: 'Partial',
        lastName: 'Mid Five',
        position: 3,
        averagePoints: 5.0,
        marketValue: 5000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'market-low-forward',
        firstName: 'Market',
        lastName: 'Low Forward',
        position: 4,
        averagePoints: 9.0,
        marketValue: 1000000,
      ),
    ],
    currentBudget: 1000000,
  );
}

TransferPlannerInput _buildInputRequiringStarterFunding() {
  return TransferPlannerInput(
    squadPlayers: [
      ..._buildSquadPlayers(),
      _player(
        id: 'bench-mid-tiny',
        firstName: 'Bench',
        lastName: 'Mid Tiny',
        position: 3,
        averagePoints: 0.0,
        marketValue: 1000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'market-fwd-premium',
        firstName: 'Market',
        lastName: 'Fwd Premium',
        position: 4,
        averagePoints: 12.0,
        marketValue: 10000000,
        marketValueTrend: 3,
      ),
    ],
    currentBudget: 0,
  );
}

TransferPlannerInput _buildInputWithRegressionAfterSales() {
  return TransferPlannerInput(
    squadPlayers: [
      ..._buildSquadPlayers(),
      _player(
        id: 'bench-mid-tiny',
        firstName: 'Bench',
        lastName: 'Mid Tiny',
        position: 3,
        averagePoints: 0.0,
        marketValue: 1000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'market-fwd-regression',
        firstName: 'Market',
        lastName: 'Fwd Regression',
        position: 4,
        averagePoints: 8.0,
        marketValue: 10000000,
      ),
    ],
    currentBudget: 0,
  );
}

TransferPlannerInput _buildTieBreakerInput() {
  return TransferPlannerInput(
    squadPlayers: [
      _player(
        id: 'starter-gk',
        firstName: 'Starter',
        lastName: 'Goalie',
        position: 1,
        averagePoints: 8.0,
        marketValue: 9000000,
      ),
      _player(
        id: 'starter-def-b',
        firstName: 'Starter',
        lastName: 'Def B',
        position: 2,
        averagePoints: 3.0,
        marketValue: 4000000,
      ),
      _player(
        id: 'starter-def-a',
        firstName: 'Starter',
        lastName: 'Def A',
        position: 2,
        averagePoints: 3.0,
        marketValue: 3000000,
      ),
      _player(
        id: 'starter-mid',
        firstName: 'Starter',
        lastName: 'Mid',
        position: 3,
        averagePoints: 6.0,
        marketValue: 5000000,
      ),
      _player(
        id: 'starter-fwd',
        firstName: 'Starter',
        lastName: 'Fwd',
        position: 4,
        averagePoints: 6.0,
        marketValue: 5000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'market-def-tie-upgrade',
        firstName: 'Market',
        lastName: 'Def Upgrade',
        position: 2,
        averagePoints: 5.0,
        marketValue: 2000000,
      ),
    ],
    currentBudget: 2000000,
  );
}

TransferPlannerInput _buildInputForMinimalExtraSales() {
  return TransferPlannerInput(
    squadPlayers: [
      ..._buildSquadPlayers(),
      _player(
        id: 'bench-def-tiny',
        firstName: 'Bench',
        lastName: 'Def Tiny',
        position: 2,
        averagePoints: 0.0,
        marketValue: 2000000,
      ),
      _player(
        id: 'bench-def-five',
        firstName: 'Bench',
        lastName: 'Def Five',
        position: 2,
        averagePoints: 1.0,
        marketValue: 5000000,
      ),
      _player(
        id: 'bench-def-six',
        firstName: 'Bench',
        lastName: 'Def Six',
        position: 2,
        averagePoints: 2.0,
        marketValue: 6000000,
      ),
    ],
    marketPlayers: [
      _player(
        id: 'market-fwd-costly',
        firstName: 'Market',
        lastName: 'Fwd Costly',
        position: 4,
        averagePoints: 9.0,
        marketValue: 16000000,
      ),
    ],
    currentBudget: 0,
  );
}

List<Player> _buildSquadPlayers() {
  return [
    _player(
      id: 'starter-gk',
      firstName: 'Starter',
      lastName: 'Goalie',
      position: 1,
      averagePoints: 8.0,
      marketValue: 10000000,
    ),
    _player(
      id: 'starter-def-1',
      firstName: 'Starter',
      lastName: 'Def One',
      position: 2,
      averagePoints: 7.0,
      marketValue: 8000000,
    ),
    _player(
      id: 'starter-def-2',
      firstName: 'Starter',
      lastName: 'Def Two',
      position: 2,
      averagePoints: 6.0,
      marketValue: 7000000,
    ),
    _player(
      id: 'starter-def-3',
      firstName: 'Starter',
      lastName: 'Def Three',
      position: 2,
      averagePoints: 5.0,
      marketValue: 4000000,
    ),
    _player(
      id: 'starter-mid-1',
      firstName: 'Starter',
      lastName: 'Mid One',
      position: 3,
      averagePoints: 8.0,
      marketValue: 9000000,
    ),
    _player(
      id: 'starter-mid-2',
      firstName: 'Starter',
      lastName: 'Mid Two',
      position: 3,
      averagePoints: 7.0,
      marketValue: 8000000,
    ),
    _player(
      id: 'starter-mid-3',
      firstName: 'Starter',
      lastName: 'Mid Three',
      position: 3,
      averagePoints: 6.0,
      marketValue: 6000000,
    ),
    _player(
      id: 'starter-mid-4',
      firstName: 'Starter',
      lastName: 'Mid Four',
      position: 3,
      averagePoints: 5.5,
      marketValue: 5500000,
    ),
    _player(
      id: 'starter-fwd-1',
      firstName: 'Starter',
      lastName: 'Fwd One',
      position: 4,
      averagePoints: 9.0,
      marketValue: 10000000,
    ),
    _player(
      id: 'starter-fwd-2',
      firstName: 'Starter',
      lastName: 'Fwd Two',
      position: 4,
      averagePoints: 8.0,
      marketValue: 9000000,
    ),
    _player(
      id: 'starter-fwd-3',
      firstName: 'Starter',
      lastName: 'Fwd Three',
      position: 4,
      averagePoints: 4.0,
      marketValue: 5000000,
    ),
  ];
}

List<Player> _buildSquadPlayersWithBench() {
  return [
    ..._buildSquadPlayers(),
    _player(
      id: 'bench-def-low',
      firstName: 'Bench',
      lastName: 'Def Low',
      position: 2,
      averagePoints: 2.0,
      marketValue: 3000000,
    ),
    _player(
      id: 'bench-mid-low',
      firstName: 'Bench',
      lastName: 'Mid Low',
      position: 3,
      averagePoints: 1.0,
      marketValue: 1000000,
    ),
  ];
}

Player _player({
  required String id,
  required String firstName,
  required String lastName,
  required int position,
  required double averagePoints,
  required int marketValue,
  int marketValueTrend = 0,
}) {
  return Player(
    id: id,
    firstName: firstName,
    lastName: lastName,
    profileBigUrl: 'https://example.com/$id.png',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: position,
    number: 1,
    averagePoints: averagePoints,
    totalPoints: (averagePoints * 10).round(),
    marketValue: marketValue,
    marketValueTrend: marketValueTrend,
    tfhmvt: 0,
    prlo: 0,
    stl: 0,
    status: 0,
    userOwnsPlayer: true,
  );
}
