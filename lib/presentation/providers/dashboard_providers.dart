import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/models/sales_recommendation_model.dart';
import 'package:kickbasekumpel/data/models/optimal_lineup_model.dart';
import 'package:kickbasekumpel/data/models/team_player_counts_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/user_model.dart';
import 'package:kickbasekumpel/data/providers/player_providers.dart';
import 'package:kickbasekumpel/data/providers/user_providers.dart';

// ============================================================================
// DASHBOARD TAB NOTIFIER & PROVIDER (Riverpod 3.x)
// ============================================================================

class SelectedDashboardTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectTab(int index) => state = index;
}

final selectedDashboardTabProvider =
    NotifierProvider<SelectedDashboardTabNotifier, int>(
      SelectedDashboardTabNotifier.new,
    );

// ============================================================================
// TEAM PLAYERS FOR SALE NOTIFIER & PROVIDER
// ============================================================================

class SelectedTeamPlayersNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void togglePlayer(String playerId) {
    if (state.contains(playerId)) {
      state = state.where((id) => id != playerId).toSet();
    } else {
      state = {...state, playerId};
    }
  }

  void clearSelection() => state = {};
}

final selectedTeamPlayersForSaleProvider =
    NotifierProvider<SelectedTeamPlayersNotifier, Set<String>>(
      SelectedTeamPlayersNotifier.new,
    );

// ============================================================================
// SALES OPTIMIZATION NOTIFIER & PROVIDER
// ============================================================================

class SalesOptimizationGoalNotifier extends Notifier<OptimizationGoal> {
  @override
  OptimizationGoal build() => OptimizationGoal.balancePositive;

  void setGoal(OptimizationGoal goal) => state = goal;
}

final salesOptimizationGoalProvider =
    NotifierProvider<SalesOptimizationGoalNotifier, OptimizationGoal>(
      SalesOptimizationGoalNotifier.new,
    );

// ============================================================================
// LINEUP OPTIMIZATION NOTIFIER & PROVIDER
// ============================================================================

class LineupOptimizationTypeNotifier extends Notifier<OptimizationType> {
  @override
  OptimizationType build() => OptimizationType.averagePoints;

  void setType(OptimizationType type) => state = type;
}

final lineupOptimizationTypeProvider =
    NotifierProvider<LineupOptimizationTypeNotifier, OptimizationType>(
      LineupOptimizationTypeNotifier.new,
    );

// ============================================================================
// LINEUP BUDGET RESPECT NOTIFIER & PROVIDER
// ============================================================================

class LineupRespectBudgetNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final lineupRespectBudgetProvider =
    NotifierProvider<LineupRespectBudgetNotifier, bool>(
      LineupRespectBudgetNotifier.new,
    );

// ============================================================================
// FORMATION INDEX NOTIFIER & PROVIDER
// ============================================================================

class SelectedFormationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setFormation(int index) => state = index;
}

final selectedFormationIndexProvider =
    NotifierProvider<SelectedFormationIndexNotifier, int>(
      SelectedFormationIndexNotifier.new,
    );

// ============================================================================
// TEAM DATA PROVIDERS
// ============================================================================

/// Team Players Provider - wird aus API geladen
final teamPlayersProvider = FutureProvider<List<Player>>((ref) async {
  // Placeholder - später mit echter API-Integration
  return [];
});

/// User Stats Provider
final userStatsProvider = FutureProvider<User?>((ref) async {
  return ref
      .watch(currentUserProvider)
      .when(
        data: (user) => user,
        loading: () => throw Exception('Loading...'),
        error: (err, stack) => throw err,
      );
});
