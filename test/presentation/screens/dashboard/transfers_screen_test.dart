import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/presentation/providers/transfer_planner_provider.dart';
import 'package:kickbasekumpel/presentation/screens/dashboard/transfers_screen.dart';
import 'package:kickbasekumpel/presentation/widgets/transfers/transfer_plan_card.dart';

void main() {
  group('TransfersScreen', () {
    testWidgets('shows initial planner prompt with calculate button', (
      tester,
    ) async {
      await _pumpTransfersScreen(
        tester,
        initialState: const TransferPlannerState(),
      );

      expect(find.text('Transferplaner'), findsOneWidget);
      expect(find.text('Beste Transferplaene berechnen'), findsOneWidget);
    });

    testWidgets('shows scenario cards from planner result', (tester) async {
      final scenario = _buildScenario();

      await _pumpTransfersScreen(
        tester,
        initialState: TransferPlannerState(
          result: TransferPlannerResult(scenarios: [scenario]),
        ),
      );

      expect(find.text('Beste Transferplaene berechnen'), findsOneWidget);
      expect(find.text(scenario.title), findsOneWidget);
      expect(find.text(scenario.summary), findsOneWidget);
    });

    testWidgets('shows one card per scenario when three plans exist', (
      tester,
    ) async {
      await _pumpTransfersScreen(
        tester,
        initialState: TransferPlannerState(
          result: TransferPlannerResult(
            scenarios: [
              _buildScenario(id: 's1', title: 'Plan 1'),
              _buildScenario(id: 's2', title: 'Plan 2'),
              _buildScenario(id: 's3', title: 'Plan 3'),
            ],
          ),
        ),
      );

      expect(find.byType(TransferPlanCard), findsNWidgets(3));
    });

    testWidgets('shows loading indicator while planner is running', (
      tester,
    ) async {
      await _pumpTransfersScreen(
        tester,
        initialState: const TransferPlannerState(isLoading: true),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows planner error message', (tester) async {
      await _pumpTransfersScreen(
        tester,
        initialState: const TransferPlannerState(errorMessage: 'kaputt'),
      );

      expect(find.text('kaputt'), findsOneWidget);
    });

    testWidgets('shows no-plan message when no scenarios are available', (
      tester,
    ) async {
      await _pumpTransfersScreen(
        tester,
        initialState: const TransferPlannerState(
          result: TransferPlannerResult(
            scenarios: [],
            noPlanReason: 'Aktuell kein sinnvoller Plan moeglich.',
          ),
        ),
      );

      expect(
        find.text('Aktuell kein sinnvoller Plan moeglich.'),
        findsOneWidget,
      );
    });

    testWidgets('opens detail sheet when a scenario card is tapped', (
      tester,
    ) async {
      final scenario = _buildScenario(
        sells: [
          _buildPlayer(id: 'sell-1', firstName: 'Nico', lastName: 'Abgang'),
        ],
        buys: [
          _buildPlayer(id: 'buy-1', firstName: 'Paul', lastName: 'Zugang'),
        ],
        starters: [
          _buildPlayer(id: 'start-1', firstName: 'Tim', lastName: 'Startelf'),
        ],
      );

      await _pumpTransfersScreen(
        tester,
        initialState: TransferPlannerState(
          result: TransferPlannerResult(scenarios: [scenario]),
        ),
      );

      await tester.tap(find.text(scenario.title));
      await tester.pumpAndSettle();

      expect(find.text('Szenario-Details'), findsOneWidget);
      expect(find.text('Paul Zugang'), findsOneWidget);
      expect(find.text('Nico Abgang'), findsOneWidget);
      expect(find.text('Tim Startelf'), findsOneWidget);
      expect(find.text('• Transfer unsicher'), findsOneWidget);
    });

    testWidgets('calls planner calculation on button tap', (tester) async {
      var calculateCalls = 0;

      await _pumpTransfersScreen(
        tester,
        initialState: const TransferPlannerState(),
        onCalculate: () {
          calculateCalls++;
        },
      );

      await tester.tap(find.text('Beste Transferplaene berechnen'));
      await tester.pump();

      expect(calculateCalls, 1);
    });
  });
}

Future<void> _pumpTransfersScreen(
  WidgetTester tester, {
  required TransferPlannerState initialState,
  VoidCallback? onCalculate,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transferPlannerProvider.overrideWith(
          () => _FakeTransferPlannerNotifier(
            initialState,
            onCalculate: onCalculate,
          ),
        ),
      ],
      child: const MaterialApp(home: TransfersScreen()),
    ),
  );
  await tester.pump();
}

class _FakeTransferPlannerNotifier extends TransferPlannerNotifier {
  _FakeTransferPlannerNotifier(this._initialState, {this.onCalculate});

  final TransferPlannerState _initialState;
  final VoidCallback? onCalculate;

  @override
  TransferPlannerState build() => _initialState;

  @override
  Future<void> calculate() async {
    onCalculate?.call();
  }
}

TransferPlanScenario _buildScenario({
  String id = 'scenario-1',
  String title = 'Max Alt -> Luca Neu',
  List<Player>? sells,
  List<Player>? buys,
  List<Player>? starters,
}) {
  final playerOut = _buildPlayer(id: 'p-1', firstName: 'Max', lastName: 'Alt');
  final playerIn = _buildPlayer(
    id: 'p-2',
    firstName: 'Luca',
    lastName: 'Neu',
    averagePoints: 9.2,
    marketValue: 22000000,
  );
  final sellPlayers = sells ?? [playerOut];
  final buyPlayers = buys ?? [playerIn];
  final starterPlayers = starters ?? [playerIn];

  return TransferPlanScenario(
    id: id,
    title: title,
    sells: sellPlayers
        .map(
          (player) => TransferPlanMove.sell(player: player, amount: 12000000),
        )
        .toList(),
    buys: buyPlayers
        .map((player) => TransferPlanMove.buy(player: player, amount: 22000000))
        .toList(),
    resultingStarters: starterPlayers,
    budgetBefore: 30000000,
    budgetAfter: 20000000,
    summary: 'Startelf verbessert sich deutlich.',
    warnings: const ['Transfer unsicher'],
    score: const TransferPlanScore(
      startingElevenGain: 2.7,
      executionRisk: 0.2,
      valueStability: 0.8,
    ),
  );
}

Player _buildPlayer({
  required String id,
  required String firstName,
  required String lastName,
  double averagePoints = 6.0,
  int marketValue = 12000000,
}) {
  return Player(
    id: id,
    firstName: firstName,
    lastName: lastName,
    profileBigUrl: '',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: 3,
    number: 10,
    averagePoints: averagePoints,
    totalPoints: 100,
    marketValue: marketValue,
    marketValueTrend: 100000,
    tfhmvt: 100000,
    prlo: 0,
    stl: 0,
    status: 0,
    userOwnsPlayer: true,
  );
}
