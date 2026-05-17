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
        expect(
          result.scenarios.every(
            (scenario) =>
                scenario.sells.length == 1 && scenario.buys.length == 1,
          ),
          isTrue,
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
