import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/models/common_models.dart';
import 'package:kickbasekumpel/data/models/league_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';
import 'package:kickbasekumpel/presentation/providers/transfer_planner_provider.dart';

void main() {
  group('transferPlannerProvider', () {
    test(
      'calculate loads squad, budget, market and stores success result',
      () async {
        final expectedResult = TransferPlannerResult(
          scenarios: [
            TransferPlanScenario(
              id: 'scenario-1',
              title: 'Upgrade',
              sells: const [],
              buys: [
                TransferPlanMove.buy(
                  player: _buildPlayer(id: 'market-1'),
                  amount: 12000000,
                ),
              ],
              resultingStarters: [_buildPlayer(id: 'starter-1')],
              budgetBefore: 15000000,
              budgetAfter: 3000000,
              summary: 'Summary',
              warnings: const [],
              score: const TransferPlanScore(
                startingElevenGain: 2.5,
                executionRisk: 0,
                valueStability: 1,
              ),
            ),
          ],
        );
        final plannerService = _RecordingTransferPlannerService(expectedResult);
        final squadPlayers = [_buildPlayer(id: 'starter-1')];
        final marketPlayers = [_buildMarketPlayer(id: 'market-1')];

        final container = ProviderContainer(
          overrides: [
            selectedLeagueIdProvider.overrideWithValue('league-1'),
            teamPlayersProvider.overrideWith(
              (ref) => Future.value(squadPlayers),
            ),
            teamBudgetProvider.overrideWith((ref) => Future.value(15000000)),
            marketPlayersProvider.overrideWith(
              (ref) => Stream.value(marketPlayers),
            ),
            transferPlannerServiceProvider.overrideWithValue(plannerService),
          ],
        );
        addTearDown(container.dispose);

        await container.read(transferPlannerProvider.notifier).calculate();

        final state = container.read(transferPlannerProvider);
        expect(state.isLoading, isFalse);
        expect(state.errorMessage, isNull);
        expect(state.result, expectedResult);

        final capturedInput = plannerService.lastInput!;
        expect(capturedInput.currentBudget, 15000000);
        expect(capturedInput.squadPlayers, squadPlayers);
        expect(capturedInput.marketPlayers, hasLength(1));
        expect(capturedInput.marketPlayers.first.id, 'market-1');
        expect(capturedInput.marketPlayers.first.userOwnsPlayer, isFalse);
        expect(capturedInput.marketPlayers.first.marketValue, 9000000);
        expect(
          capturedInput.marketPlayers.first.tfhmvt,
          marketPlayers.first.marketValueTrend,
        );
        expect(
          capturedInput.marketPlayers.first.prlo,
          marketPlayers.first.prlo ?? 0,
        );
      },
    );

    test(
      'calculate waits for auto league selection before no-league decision',
      () async {
        final plannerService = _RecordingTransferPlannerService(
          const TransferPlannerResult(scenarios: []),
        );

        final container = ProviderContainer(
          overrides: [
            autoSelectFirstLeagueProvider.overrideWith((ref) async {
              await Future<void>.delayed(const Duration(milliseconds: 20));
              ref.read(selectedLeagueProvider.notifier).select(_buildLeague());
            }),
            teamPlayersProvider.overrideWith(
              (ref) => Future.value([_buildPlayer(id: 'starter-1')]),
            ),
            teamBudgetProvider.overrideWith((ref) => Future.value(1000000)),
            marketPlayersProvider.overrideWith(
              (ref) => Stream.value([_buildMarketPlayer(id: 'market-1')]),
            ),
            transferPlannerServiceProvider.overrideWithValue(plannerService),
          ],
        );
        addTearDown(container.dispose);

        await container.read(transferPlannerProvider.notifier).calculate();

        final state = container.read(transferPlannerProvider);
        expect(state.errorMessage, isNull);
        expect(plannerService.lastInput, isNotNull);
      },
    );

    test('calculate returns no selected league error state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(transferPlannerProvider.notifier).calculate();

      final state = container.read(transferPlannerProvider);
      expect(state.isLoading, isFalse);
      expect(state.result, isNull);
      expect(state.errorMessage, contains('Liga'));
    });

    test('calculate stores no-plan fallback result without error', () async {
      const noPlanReason =
          'Aktuell wurde kein echter Verstaerkungsplan gefunden.';
      final plannerService = _RecordingTransferPlannerService(
        const TransferPlannerResult(scenarios: [], noPlanReason: noPlanReason),
      );

      final container = ProviderContainer(
        overrides: [
          selectedLeagueIdProvider.overrideWithValue('league-1'),
          teamPlayersProvider.overrideWith(
            (ref) => Future.value([_buildPlayer(id: 'starter-1')]),
          ),
          teamBudgetProvider.overrideWith((ref) => Future.value(1000000)),
          marketPlayersProvider.overrideWith(
            (ref) => Stream.value([_buildMarketPlayer(id: 'market-1')]),
          ),
          transferPlannerServiceProvider.overrideWithValue(plannerService),
        ],
      );
      addTearDown(container.dispose);

      await container.read(transferPlannerProvider.notifier).calculate();

      final state = container.read(transferPlannerProvider);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.result, isNotNull);
      expect(state.result!.scenarios, isEmpty);
      expect(state.result!.noPlanReason, noPlanReason);
    });

    test(
      'calculate stores readable error message on service failure',
      () async {
        final container = ProviderContainer(
          overrides: [
            selectedLeagueIdProvider.overrideWithValue('league-1'),
            teamPlayersProvider.overrideWith(
              (ref) => Future.value([_buildPlayer(id: 'starter-1')]),
            ),
            teamBudgetProvider.overrideWith((ref) => Future.value(1000000)),
            marketPlayersProvider.overrideWith(
              (ref) => Stream.value([_buildMarketPlayer(id: 'market-1')]),
            ),
            transferPlannerServiceProvider.overrideWithValue(
              _ThrowingTransferPlannerService(),
            ),
          ],
        );
        addTearDown(container.dispose);

        await container.read(transferPlannerProvider.notifier).calculate();

        final state = container.read(transferPlannerProvider);
        expect(state.result, isNull);
        expect(state.errorMessage, 'Planung fehlgeschlagen: kaputt');
      },
    );
  });
}

class _RecordingTransferPlannerService extends TransferPlannerService {
  _RecordingTransferPlannerService(this._result);

  final TransferPlannerResult _result;
  TransferPlannerInput? lastInput;

  @override
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    lastInput = input;
    return _result;
  }
}

class _ThrowingTransferPlannerService extends TransferPlannerService {
  @override
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    throw Exception('kaputt');
  }
}

Player _buildPlayer({required String id}) {
  return Player(
    id: id,
    firstName: 'Max',
    lastName: 'Mustermann',
    profileBigUrl: '',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: 3,
    number: 8,
    averagePoints: 6.5,
    totalPoints: 65,
    marketValue: 10000000,
    marketValueTrend: 150000,
    tfhmvt: 150000,
    prlo: 0,
    stl: 3,
    status: 0,
    userOwnsPlayer: true,
  );
}

MarketPlayer _buildMarketPlayer({required String id}) {
  return MarketPlayer(
    id: id,
    firstName: 'Market',
    lastName: 'Player',
    profileBigUrl: '',
    teamName: 'FC Market',
    teamId: 'team-2',
    position: 3,
    number: 10,
    averagePoints: 8.1,
    totalPoints: 81,
    marketValue: 12000000,
    marketValueTrend: 250000,
    price: 9000000,
    expiry: '2026-01-01T00:00:00.000Z',
    offers: 0,
    seller: const MarketSeller(id: 'seller-1', name: 'Seller'),
    stl: 0,
    status: 0,
    prlo: null,
    exs: 0,
  );
}

League _buildLeague() {
  return const League(
    i: 'league-auto',
    n: 'Auto League',
    cu: LeagueUser(
      id: 'user-1',
      name: 'User',
      teamName: 'Team',
      budget: 0,
      teamValue: 0,
      points: 0,
      placement: 1,
      won: 0,
      drawn: 0,
      lost: 0,
      se11: 0,
      ttm: 0,
    ),
  );
}
