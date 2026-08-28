# Transfer Planner Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current generic transfer recommendations with a planner that builds 3 executable buy/sell scenarios from the user's squad, budget, market, and short-term matchday context.

**Architecture:** Keep the planning logic deterministic in the data layer, then expose it through a presentation-layer Riverpod notifier that collects squad, budget, market, lineup, and Ligainsider context. Rebuild the Transfers screen around scenario cards and detail sheets so the user sees complete upgrade plans instead of isolated player tips.

**Tech Stack:** Flutter, Riverpod 3.x, Freezed/json_serializable, existing Kickbase API client, existing Ligainsider providers, flutter_test, mocktail, fake_cloud_firestore where needed

---

## Planned File Map

- Create: `lib/data/models/transfer_planner_model.dart`  
  Freezed models for planner inputs, transfer moves, ranked scenarios, and final planner result.

- Create: `lib/data/services/transfer_planner_service.dart`  
  Deterministic planner that scores the current starting eleven, builds valid transfer chains, rejects budget-negative outcomes, and returns the top 3 scenarios.

- Create: `test/data/services/transfer_planner_service_test.dart`  
  Unit tests for scenario generation, budget rules, ranking, and no-plan fallbacks.

- Create: `lib/presentation/providers/transfer_planner_provider.dart`  
  Riverpod notifier/state that loads current squad, budget, market, and short-term context, then calls the planner service on demand.

- Create: `test/presentation/providers/transfer_planner_provider_test.dart`  
  Provider tests for loading, success, error, and "no strengthening plan" states.

- Create: `lib/presentation/widgets/transfers/transfer_plan_card.dart`  
  Compact card for each scenario in the result list.

- Create: `lib/presentation/widgets/transfers/transfer_plan_detail_sheet.dart`  
  Bottom sheet with resulting starting eleven, move list, warnings, and rationale.

- Modify: `lib/presentation/screens/dashboard/transfers_screen.dart`  
  Replace the current AI recommendation tabs with a planner CTA, loading/error/result states, and scenario detail handling.

- Test: `test/presentation/screens/dashboard/transfers_screen_test.dart`  
  Widget tests for the empty state, loading state, top-3 cards, and no-plan fallback.

## Task 1: Build planner models and scoring service

**Files:**
- Create: `lib/data/models/transfer_planner_model.dart`
- Create: `lib/data/services/transfer_planner_service.dart`
- Test: `test/data/services/transfer_planner_service_test.dart`

- [ ] **Step 1: Write the failing planner service test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';

void main() {
  group('TransferPlannerService', () {
    test(
      'returns top 3 executable scenarios sorted by starting-eleven gain',
      () {
        final service = TransferPlannerService();

        final squad = [
          _player(id: 'gk-a', position: 1, averagePoints: 4.0, marketValue: 8000000, userOwnsPlayer: true),
          _player(id: 'def-a', position: 2, averagePoints: 3.5, marketValue: 7000000, userOwnsPlayer: true),
          _player(id: 'mid-a', position: 3, averagePoints: 4.2, marketValue: 9000000, userOwnsPlayer: true),
          _player(id: 'fwd-a', position: 4, averagePoints: 5.0, marketValue: 10000000, userOwnsPlayer: true),
        ];

        final market = [
          _player(id: 'def-upgrade', position: 2, averagePoints: 8.4, marketValue: 12000000, userOwnsPlayer: false),
          _player(id: 'mid-upgrade', position: 3, averagePoints: 8.8, marketValue: 13000000, userOwnsPlayer: false),
          _player(id: 'fwd-upgrade', position: 4, averagePoints: 8.1, marketValue: 11500000, userOwnsPlayer: false),
          _player(id: 'def-value', position: 2, averagePoints: 6.9, marketValue: 9500000, userOwnsPlayer: false),
        ];

        final result = service.buildPlans(
          TransferPlannerInput(
            squadPlayers: squad,
            marketPlayers: market,
            currentBudget: 4000000,
          ),
        );

        expect(result.scenarios, hasLength(3));
        expect(result.scenarios.first.score.startingElevenGain, greaterThan(0));
        expect(result.scenarios.first.score.startingElevenGain, greaterThanOrEqualTo(result.scenarios[1].score.startingElevenGain));
        expect(result.scenarios.every((scenario) => scenario.budgetAfter >= 0), isTrue);
      },
    );

    test('returns noPlanReason when no upgrade beats current starters', () {
      final service = TransferPlannerService();

      final squad = [
        _player(id: 'def-a', position: 2, averagePoints: 8.0, marketValue: 12000000, userOwnsPlayer: true),
        _player(id: 'mid-a', position: 3, averagePoints: 8.4, marketValue: 13000000, userOwnsPlayer: true),
      ];

      final market = [
        _player(id: 'def-bench', position: 2, averagePoints: 4.1, marketValue: 7000000, userOwnsPlayer: false),
      ];

      final result = service.buildPlans(
        TransferPlannerInput(
          squadPlayers: squad,
          marketPlayers: market,
          currentBudget: 1000000,
        ),
      );

      expect(result.scenarios, isEmpty);
      expect(result.noPlanReason, contains('kein echter Verstaerkungsplan'));
    });
  });
}

Player _player({
  required String id,
  required int position,
  required double averagePoints,
  required int marketValue,
  required bool userOwnsPlayer,
}) {
  return Player(
    id: id,
    firstName: 'Max',
    lastName: id,
    profileBigUrl: '',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: position,
    number: 1,
    marketValue: marketValue,
    marketValueTrend: 0,
    points: 0,
    averagePoints: averagePoints,
    totalPoints: 0,
    userOwnsPlayer: userOwnsPlayer,
    status: 0,
    shirtNumber: 1,
    shirtImage: '',
    hasStar: false,
    isCaptain: false,
    isViceCaptain: false,
    stats: const {},
  );
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/data/services/transfer_planner_service_test.dart`  
Expected: FAIL with import errors because `transfer_planner_model.dart` and `transfer_planner_service.dart` do not exist yet.

- [ ] **Step 3: Add the planner Freezed models**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'player_model.dart';

part 'transfer_planner_model.freezed.dart';
part 'transfer_planner_model.g.dart';

@freezed
class TransferPlannerInput with _$TransferPlannerInput {
  const factory TransferPlannerInput({
    required List<Player> squadPlayers,
    required List<Player> marketPlayers,
    required int currentBudget,
  }) = _TransferPlannerInput;

  factory TransferPlannerInput.fromJson(Map<String, dynamic> json) =>
      _$TransferPlannerInputFromJson(json);
}

@freezed
class TransferPlanScore with _$TransferPlanScore {
  const factory TransferPlanScore({
    required double startingElevenGain,
    required double executionRisk,
    required double valueStability,
  }) = _TransferPlanScore;

  factory TransferPlanScore.fromJson(Map<String, dynamic> json) =>
      _$TransferPlanScoreFromJson(json);
}

@freezed
class TransferPlanMove with _$TransferPlanMove {
  const factory TransferPlanMove.sell({
    required Player player,
    required int amount,
  }) = TransferPlanSell;

  const factory TransferPlanMove.buy({
    required Player player,
    required int amount,
  }) = TransferPlanBuy;

  factory TransferPlanMove.fromJson(Map<String, dynamic> json) =>
      _$TransferPlanMoveFromJson(json);
}

@freezed
class TransferPlanScenario with _$TransferPlanScenario {
  const factory TransferPlanScenario({
    required String id,
    required String title,
    required List<TransferPlanMove> sells,
    required List<TransferPlanMove> buys,
    required List<Player> resultingStarters,
    required int budgetBefore,
    required int budgetAfter,
    required String summary,
    required List<String> warnings,
    required TransferPlanScore score,
  }) = _TransferPlanScenario;

  factory TransferPlanScenario.fromJson(Map<String, dynamic> json) =>
      _$TransferPlanScenarioFromJson(json);
}

@freezed
class TransferPlannerResult with _$TransferPlannerResult {
  const factory TransferPlannerResult({
    required List<TransferPlanScenario> scenarios,
    String? noPlanReason,
  }) = _TransferPlannerResult;

  factory TransferPlannerResult.fromJson(Map<String, dynamic> json) =>
      _$TransferPlannerResultFromJson(json);
}
```

- [ ] **Step 4: Generate Freezed code**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`  
Expected: PASS and generated files for `transfer_planner_model.dart`.

- [ ] **Step 5: Implement the minimal planner service**

```dart
import 'dart:math' as math;

import '../models/player_model.dart';
import '../models/transfer_planner_model.dart';

class TransferPlannerService {
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    final currentStarters = _pickStarters(input.squadPlayers);
    final currentStarterIds = currentStarters.map((player) => player.id).toSet();
    final scenarios = <TransferPlanScenario>[];

    for (final marketPlayer in input.marketPlayers) {
      final samePositionStarters = currentStarters
          .where((player) => player.position == marketPlayer.position)
          .toList()
        ..sort((a, b) => a.averagePoints.compareTo(b.averagePoints));

      if (samePositionStarters.isEmpty) {
        continue;
      }

      final weakestStarter = samePositionStarters.first;
      final budgetAfter = input.currentBudget + weakestStarter.marketValue - marketPlayer.marketValue;
      final startingGain = marketPlayer.averagePoints - weakestStarter.averagePoints;

      if (budgetAfter < 0 || startingGain <= 0) {
        continue;
      }

      final updatedPlayers = [
        for (final player in input.squadPlayers)
          if (player.id != weakestStarter.id) player,
        marketPlayer.copyWith(userOwnsPlayer: true),
      ];

      final updatedStarters = _pickStarters(updatedPlayers);
      scenarios.add(
        TransferPlanScenario(
          id: '${weakestStarter.id}-${marketPlayer.id}',
          title: '${_positionLabel(marketPlayer.position)} upgraden',
          sells: [
            TransferPlanMove.sell(player: weakestStarter, amount: weakestStarter.marketValue),
          ],
          buys: [
            TransferPlanMove.buy(player: marketPlayer, amount: marketPlayer.marketValue),
          ],
          resultingStarters: updatedStarters,
          budgetBefore: input.currentBudget,
          budgetAfter: budgetAfter,
          summary: '${marketPlayer.firstName} ${marketPlayer.lastName} ersetzt ${weakestStarter.firstName} ${weakestStarter.lastName}.',
          warnings: const [],
          score: TransferPlanScore(
            startingElevenGain: startingGain,
            executionRisk: 0.0,
            valueStability: math.max(0, marketPlayer.marketValueTrend).toDouble(),
          ),
        ),
      );
    }

    scenarios.sort((a, b) => b.score.startingElevenGain.compareTo(a.score.startingElevenGain));
    final topScenarios = scenarios.take(3).toList();

    if (topScenarios.isEmpty) {
      return const TransferPlannerResult(
        scenarios: [],
        noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
      );
    }

    return TransferPlannerResult(scenarios: topScenarios);
  }

  List<Player> _pickStarters(List<Player> players) {
    final sorted = [...players]..sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    return sorted.take(11).toList();
  }

  String _positionLabel(int position) => switch (position) {
        1 => 'Torwart',
        2 => 'Abwehr',
        3 => 'Mittelfeld',
        4 => 'Sturm',
        _ => 'Position',
      };
}
```

- [ ] **Step 6: Re-run the planner service test**

Run: `flutter test test/data/services/transfer_planner_service_test.dart`  
Expected: PASS with 2 tests passing.

- [ ] **Step 7: Commit the service slice**

```bash
git add lib/data/models/transfer_planner_model.dart lib/data/models/transfer_planner_model.freezed.dart lib/data/models/transfer_planner_model.g.dart lib/data/services/transfer_planner_service.dart test/data/services/transfer_planner_service_test.dart
git commit -m "feat: add transfer planner service"
```

## Task 2: Add Riverpod orchestration for squad, budget, market, and planner state

**Files:**
- Create: `lib/presentation/providers/transfer_planner_provider.dart`
- Test: `test/presentation/providers/transfer_planner_provider_test.dart`

- [ ] **Step 1: Write the failing provider test**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';
import 'package:kickbasekumpel/presentation/providers/transfer_planner_provider.dart';

void main() {
  test('calculate loads planner result into success state', () async {
    final container = ProviderContainer(
      overrides: [
        transferPlannerServiceProvider.overrideWithValue(_FakeTransferPlannerService()),
        selectedLeagueIdProvider.overrideWith((ref) => 'league-1'),
        teamPlayersProvider.overrideWith((ref) async => [
          _player(id: 'owned', position: 2, averagePoints: 4.0, userOwnsPlayer: true),
        ]),
        teamBudgetProvider.overrideWith((ref) async => 3000000),
        marketPlayersProvider.overrideWith((ref) async* {
          yield [
          _marketPlayer(id: 'upgrade', position: 2, averagePoints: 8.0),
          ];
        }),
      ],
    );

    await container.read(transferPlannerProvider.notifier).calculate();

    final state = container.read(transferPlannerProvider);
    expect(state.isLoading, false);
    expect(state.result?.scenarios, hasLength(1));
    expect(state.errorMessage, isNull);
  });
}

class _FakeTransferPlannerService extends TransferPlannerService {
  _FakeTransferPlannerService({this.empty = false});

  final bool empty;

  @override
  TransferPlannerResult buildPlans(TransferPlannerInput input) {
    if (empty) {
      return const TransferPlannerResult(
        scenarios: [],
        noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
      );
    }

    return TransferPlannerResult(
      scenarios: [
        TransferPlanScenario(
          id: 'plan-a',
          title: 'Abwehr upgraden',
          sells: [
            TransferPlanMove.sell(player: input.squadPlayers.first, amount: input.squadPlayers.first.marketValue),
          ],
          buys: [
            TransferPlanMove.buy(player: input.marketPlayers.first, amount: input.marketPlayers.first.marketValue),
          ],
          resultingStarters: [
            input.marketPlayers.first,
          ],
          budgetBefore: input.currentBudget,
          budgetAfter: 1000000,
          summary: 'Testplan',
          warnings: const [],
          score: const TransferPlanScore(
            startingElevenGain: 4.0,
            executionRisk: 0.1,
            valueStability: 0.2,
          ),
        ),
      ],
    );
  }
}

Player _player({
  required String id,
  required int position,
  required double averagePoints,
  required bool userOwnsPlayer,
}) {
  return Player(
    id: id,
    firstName: 'Max',
    lastName: id,
    profileBigUrl: '',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: position,
    number: 1,
    marketValue: 8000000,
    marketValueTrend: 0,
    points: 0,
    averagePoints: averagePoints,
    totalPoints: 0,
    userOwnsPlayer: userOwnsPlayer,
    status: 0,
    shirtNumber: 1,
    shirtImage: '',
    hasStar: false,
    isCaptain: false,
    isViceCaptain: false,
    stats: const {},
  );
}

MarketPlayer _marketPlayer({
  required String id,
  required int position,
  required double averagePoints,
}) {
  return MarketPlayer(
    id: id,
    firstName: 'Markt',
    lastName: id,
    profileBigUrl: '',
    teamName: 'FC Markt',
    teamId: 'team-2',
    position: position,
    number: 1,
    averagePoints: averagePoints,
    totalPoints: 0,
    marketValue: 10000000,
    marketValueTrend: 0,
    price: 10000000,
    expiry: '2099-01-01T12:00:00.000Z',
    offers: 0,
    seller: const MarketSeller(id: 'seller-1', name: 'Kickbase'),
    stl: 0,
    status: 0,
    exs: 0,
  );
}
```

- [ ] **Step 2: Run the provider test to verify it fails**

Run: `flutter test test/presentation/providers/transfer_planner_provider_test.dart`  
Expected: FAIL because `transfer_planner_provider.dart` and `transferPlannerServiceProvider` do not exist yet.

- [ ] **Step 3: Create the planner provider state and service provider**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';

import '../providers/dashboard_providers.dart';
import '../providers/market_providers.dart';
import '../../data/providers/league_providers.dart';

final transferPlannerServiceProvider = Provider<TransferPlannerService>((ref) {
  return TransferPlannerService();
});

class TransferPlannerState {
  const TransferPlannerState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
  });

  final bool isLoading;
  final TransferPlannerResult? result;
  final String? errorMessage;

  TransferPlannerState copyWith({
    bool? isLoading,
    TransferPlannerResult? result,
    String? errorMessage,
  }) {
    return TransferPlannerState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }
}
```

- [ ] **Step 4: Implement the notifier that gathers the current league context**

```dart
class TransferPlannerNotifier extends Notifier<TransferPlannerState> {
  @override
  TransferPlannerState build() => const TransferPlannerState();

  Future<void> calculate() async {
    final leagueId = ref.read(selectedLeagueIdProvider);
    if (leagueId == null) {
      state = const TransferPlannerState(
        errorMessage: 'Bitte waehle zuerst eine Liga aus.',
      );
      return;
    }

    state = const TransferPlannerState(isLoading: true);

    try {
      final squadPlayers = await ref.read(teamPlayersProvider.future);
      final budget = await ref.read(teamBudgetProvider.future);
      final marketPlayers = await ref.read(marketPlayersProvider.future);
      final planner = ref.read(transferPlannerServiceProvider);

      final result = planner.buildPlans(
        TransferPlannerInput(
          squadPlayers: squadPlayers,
          marketPlayers: [
            for (final market in marketPlayers)
              Player(
                id: market.id,
                firstName: market.firstName,
                lastName: market.lastName,
                profileBigUrl: market.profileBigUrl,
                teamName: market.teamName,
                teamId: market.teamId,
                position: market.position,
                number: market.number,
                marketValue: market.marketValue,
                marketValueTrend: market.marketValueTrend,
                points: market.totalPoints,
                averagePoints: market.averagePoints,
                totalPoints: market.totalPoints,
                userOwnsPlayer: false,
                status: market.status,
                shirtNumber: market.number,
                shirtImage: '',
                hasStar: false,
                isCaptain: false,
                isViceCaptain: false,
                stats: const {},
              ),
          ],
          currentBudget: budget,
        ),
      );

      state = TransferPlannerState(result: result);
    } catch (error) {
      state = TransferPlannerState(
        errorMessage: 'Transferplaene konnten nicht berechnet werden: $error',
      );
    }
  }
}

final transferPlannerProvider =
    NotifierProvider<TransferPlannerNotifier, TransferPlannerState>(
      TransferPlannerNotifier.new,
    );
```

- [ ] **Step 5: Re-run the provider test**

Run: `flutter test test/presentation/providers/transfer_planner_provider_test.dart`  
Expected: PASS with the planner state populated from the fake service.

- [ ] **Step 6: Add one more provider test for the no-plan fallback**

```dart
test('calculate keeps no-plan reason when planner finds no upgrade', () async {
  final container = ProviderContainer(
    overrides: [
      transferPlannerServiceProvider.overrideWithValue(
        _FakeTransferPlannerService(empty: true),
      ),
      selectedLeagueIdProvider.overrideWith((ref) => 'league-1'),
      teamPlayersProvider.overrideWith((ref) async => [
        _player(id: 'owned', position: 2, averagePoints: 8.0, userOwnsPlayer: true),
      ]),
      teamBudgetProvider.overrideWith((ref) async => 1000000),
      marketPlayersProvider.overrideWith((ref) async* {
        yield const <MarketPlayer>[];
      }),
    ],
  );

  await container.read(transferPlannerProvider.notifier).calculate();

  expect(
    container.read(transferPlannerProvider).result?.noPlanReason,
    contains('kein echter Verstaerkungsplan'),
  );
});
```

- [ ] **Step 7: Run the provider test file again**

Run: `flutter test test/presentation/providers/transfer_planner_provider_test.dart`  
Expected: PASS with both tests green.

- [ ] **Step 8: Commit the provider slice**

```bash
git add lib/presentation/providers/transfer_planner_provider.dart test/presentation/providers/transfer_planner_provider_test.dart
git commit -m "feat: add transfer planner provider"
```

## Task 3: Replace the Transfers UI with planner cards and scenario details

**Files:**
- Create: `lib/presentation/widgets/transfers/transfer_plan_card.dart`
- Create: `lib/presentation/widgets/transfers/transfer_plan_detail_sheet.dart`
- Modify: `lib/presentation/screens/dashboard/transfers_screen.dart`
- Test: `test/presentation/screens/dashboard/transfers_screen_test.dart`

- [ ] **Step 1: Write the failing widget test for the new planner screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/presentation/providers/transfer_planner_provider.dart';
import 'package:kickbasekumpel/presentation/screens/dashboard/transfers_screen.dart';
import 'package:kickbasekumpel/presentation/widgets/transfers/transfer_plan_card.dart';

void main() {
  testWidgets('shows top 3 scenario cards and the no-plan fallback', (tester) async {
    final state = TransferPlannerState(
      result: TransferPlannerResult(
        scenarios: [
          _scenario('plan-a'),
          _scenario('plan-b'),
          _scenario('plan-c'),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transferPlannerProvider.overrideWith(
            () => _StaticTransferPlannerNotifier(state),
          ),
        ],
        child: const MaterialApp(home: TransfersScreen()),
      ),
    );

    expect(find.text('Beste Transferplaene berechnen'), findsOneWidget);
    expect(find.byType(TransferPlanCard), findsNWidgets(3));
  });
}

class _StaticTransferPlannerNotifier extends TransferPlannerNotifier {
  _StaticTransferPlannerNotifier(this.initialState);

  final TransferPlannerState initialState;

  @override
  TransferPlannerState build() => initialState;
}

TransferPlanScenario _scenario(String id) {
  return TransferPlanScenario(
    id: id,
    title: 'Plan $id',
    sells: const [],
    buys: const [],
    resultingStarters: const [],
    budgetBefore: 3000000,
    budgetAfter: 1000000,
    summary: 'Kurzbeschreibung $id',
    warnings: const [],
    score: const TransferPlanScore(
      startingElevenGain: 3.0,
      executionRisk: 0.2,
      valueStability: 0.1,
    ),
  );
}
```

- [ ] **Step 2: Run the widget test to verify it fails**

Run: `flutter test test/presentation/screens/dashboard/transfers_screen_test.dart`  
Expected: FAIL because the planner widgets and provider integration are not in the screen yet.

- [ ] **Step 3: Create the scenario card widget**

```dart
import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';

class TransferPlanCard extends StatelessWidget {
  const TransferPlanCard({
    super.key,
    required this.scenario,
    required this.onTap,
  });

  final TransferPlanScenario scenario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(scenario.title),
        subtitle: Text(scenario.summary),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${scenario.score.startingElevenGain.toStringAsFixed(1)} Punkte'),
            Text('Budget: ${scenario.budgetAfter}'),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create the scenario detail sheet**

```dart
import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';

class TransferPlanDetailSheet extends StatelessWidget {
  const TransferPlanDetailSheet({
    super.key,
    required this.scenario,
  });

  final TransferPlanScenario scenario;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scenario.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(scenario.summary),
            const SizedBox(height: 12),
            Text('Verkaufen: ${scenario.sells.length}'),
            Text('Kaufen: ${scenario.buys.length}'),
            Text('Budget danach: ${scenario.budgetAfter}'),
            const SizedBox(height: 12),
            for (final warning in scenario.warnings) Text('Warnung: $warning'),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Replace the screen body with planner CTA + result states**

```dart
class TransfersScreen extends ConsumerWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(transferPlannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transfers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: plannerState.isLoading
                ? null
                : () => ref.read(transferPlannerProvider.notifier).calculate(),
            icon: const Icon(Icons.auto_graph),
            label: const Text('Beste Transferplaene berechnen'),
          ),
          const SizedBox(height: 16),
          if (plannerState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (plannerState.errorMessage != null)
            Text(plannerState.errorMessage!)
          else if (plannerState.result?.scenarios.isNotEmpty ?? false)
            ...plannerState.result!.scenarios.map(
              (scenario) => TransferPlanCard(
                scenario: scenario,
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => TransferPlanDetailSheet(scenario: scenario),
                  );
                },
              ),
            )
          else if (plannerState.result?.noPlanReason != null)
            Text(plannerState.result!.noPlanReason!)
          else
            const Text(
              'Berechne Transferplaene, um konkrete Verstaerkungsoptionen fuer deine Startelf zu sehen.',
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Re-run the widget test**

Run: `flutter test test/presentation/screens/dashboard/transfers_screen_test.dart`  
Expected: PASS with 3 scenario cards rendered.

- [ ] **Step 7: Add a second widget test for the no-plan message**

```dart
testWidgets('shows no-plan reason when no strengthening scenario exists', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transferPlannerProvider.overrideWith(
          () => _StaticTransferPlannerNotifier(
            const TransferPlannerState(
              result: TransferPlannerResult(
                scenarios: [],
                noPlanReason: 'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
              ),
            ),
          ),
        ),
      ],
      child: const MaterialApp(home: TransfersScreen()),
    ),
  );

  expect(find.textContaining('kein echter Verstaerkungsplan'), findsOneWidget);
});
```

- [ ] **Step 8: Run the widget test file again**

Run: `flutter test test/presentation/screens/dashboard/transfers_screen_test.dart`  
Expected: PASS with both screen tests green.

- [ ] **Step 9: Commit the UI slice**

```bash
git add lib/presentation/screens/dashboard/transfers_screen.dart lib/presentation/widgets/transfers/transfer_plan_card.dart lib/presentation/widgets/transfers/transfer_plan_detail_sheet.dart test/presentation/screens/dashboard/transfers_screen_test.dart
git commit -m "feat: show transfer planner scenarios"
```

## Task 4: Verify the full planner flow and clean up the old recommendation path

**Files:**
- Modify: `lib/presentation/screens/dashboard/transfers_screen.dart`
- Test: `test/data/services/transfer_planner_service_test.dart`
- Test: `test/presentation/providers/transfer_planner_provider_test.dart`
- Test: `test/presentation/screens/dashboard/transfers_screen_test.dart`

- [ ] **Step 1: Remove the obsolete tab-controller shell from `TransfersScreen`**

```dart
class TransfersScreen extends ConsumerWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(transferPlannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transfers')),
      body: plannerState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 2: Run the focused test suite**

Run: `flutter test test/data/services/transfer_planner_service_test.dart test/presentation/providers/transfer_planner_provider_test.dart test/presentation/screens/dashboard/transfers_screen_test.dart`  
Expected: PASS with all new planner tests green.

- [ ] **Step 3: Run repository-wide analysis**

Run: `flutter analyze`  
Expected: PASS with no new analyzer errors.

- [ ] **Step 4: Run the full test suite**

Run: `flutter test`  
Expected: PASS with the existing suite plus the new planner coverage.

- [ ] **Step 5: Commit the final cleanup**

```bash
git add lib/presentation/screens/dashboard/transfers_screen.dart test/data/services/transfer_planner_service_test.dart test/presentation/providers/transfer_planner_provider_test.dart test/presentation/screens/dashboard/transfers_screen_test.dart
git commit -m "refactor: finalize transfer planner flow"
```
