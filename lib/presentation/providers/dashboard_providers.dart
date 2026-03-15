import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:kickbasekumpel/data/models/sales_recommendation_model.dart';
import 'package:kickbasekumpel/data/models/optimal_lineup_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/user_model.dart';
import 'package:kickbasekumpel/data/providers/kickbase_auth_provider.dart';
import 'package:kickbasekumpel/data/providers/user_providers.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/providers/league_detail_providers.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/utils/parsing_utils.dart';
import 'package:kickbasekumpel/domain/exceptions/kickbase_exceptions.dart';

final _logger = Logger();

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
/// Lädt die Spieler des aktuellen Teams basierend auf der ausgewählten Liga
final teamPlayersProvider = FutureProvider<List<Player>>((ref) async {
  // Wait for auto-select to complete first
  await ref.watch(autoSelectFirstLeagueProvider.future);

  final leagueId = ref.watch(selectedLeagueIdProvider);

  _logger.i('🎯 teamPlayersProvider called. selectedLeagueId: $leagueId');

  if (leagueId == null) {
    _logger.w('⚠️ selectedLeagueId is null, returning empty list');
    return [];
  }

  try {
    // Get squad data from API
    _logger.i('📥 Fetching squad data for league: $leagueId');
    final squadData = await ref.watch(mySquadProvider(leagueId).future);

    _logger.i('✅ Squad data received: ${squadData.keys}');

    // Extract players from squad data
    final rawPlayers = (squadData['it'] as List?) ?? [];
    _logger.i('📊 Raw players count: ${rawPlayers.length}');
    if (rawPlayers.isNotEmpty) {
      _logger.i('📋 First raw player: ${rawPlayers.first}');
    }

    final players = rawPlayers.map((json) {
      try {
        final normalized = normalizePlayerJson(json as Map<String, dynamic>);
        return Player.fromJson(normalized);
      } catch (e) {
        _logger.e('❌ Error normalizing player: $e');
        rethrow;
      }
    }).toList();

    // Vorname + Nachname parallel vom Player-Detail-Endpunkt nachladen,
    // da der Squad-Endpunkt nur den Anzeigenamen (fn = "Baumgartner") liefert.
    final apiClient = ref.watch(kickbaseApiClientProvider);
    final enrichedPlayers = await Future.wait(
      players.map((player) async {
        if (player.id.isEmpty) return player;
        try {
          final details = await apiClient.getPlayerDetails(leagueId, player.id);
          final fn = (details['fn'] as String?) ?? '';
          final ln = (details['ln'] as String?) ?? '';
          if (fn.isNotEmpty || ln.isNotEmpty) {
            _logger.i(
              '🔄 Enriched player: fn=$fn, ln=$ln (was: fn=${player.firstName}, ln=${player.lastName})',
            );
            return player.copyWith(firstName: fn, lastName: ln);
          }
        } catch (e) {
          _logger.w('⚠️ Name enrichment failed for player ${player.id}: $e');
        }
        return player;
      }),
    );

    _logger.i('✅ Extracted ${enrichedPlayers.length} players from squad data');
    return enrichedPlayers;
  } on AuthorizationException catch (e) {
    _logger.w('🔒 403 in teamPlayersProvider – Token abgelaufen: ${e.message}');
    // Logout erzwingen → Router leitet zur Login-Seite weiter
    ref.read(kickbaseAuthProvider.notifier).handleSessionExpired();
    rethrow;
  } on AuthenticationException catch (e) {
    _logger.w('🔒 401 in teamPlayersProvider – Token ungültig: ${e.message}');
    ref.read(kickbaseAuthProvider.notifier).handleSessionExpired();
    rethrow;
  } catch (e, stack) {
    _logger.e(
      '❌ Error in teamPlayersProvider: $e',
      error: e,
      stackTrace: stack,
    );
    rethrow;
  }
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

/// Team Budget Provider - lädt das Budget für die ausgewählte Liga
final teamBudgetProvider = FutureProvider<int>((ref) async {
  // Wait for auto-select to complete first
  await ref.watch(autoSelectFirstLeagueProvider.future);

  final leagueId = ref.watch(selectedLeagueIdProvider);

  _logger.i('💰 teamBudgetProvider called. selectedLeagueId: $leagueId');

  if (leagueId == null) {
    _logger.w('⚠️ selectedLeagueId is null, returning 0');
    return 0;
  }

  try {
    // Get budget data from API
    _logger.i('📥 Fetching budget data for league: $leagueId');
    final budgetData = await ref.watch(myBudgetProvider(leagueId).future);

    _logger.i('✅ Budget data received: ${budgetData.keys}');

    // Extract budget - API might return 'b' (short) or 'budget' (long)
    // Can be double or int
    final budgetValue = budgetData['b'] ?? budgetData['budget'] ?? 0;
    final budget = budgetValue is int
        ? budgetValue
        : budgetValue is double
        ? budgetValue.toInt()
        : (int.tryParse(budgetValue.toString()) ?? 0);

    _logger.i('✅ Budget: €$budget');
    return budget;
  } catch (e, stack) {
    _logger.e('❌ Error in teamBudgetProvider: $e', error: e, stackTrace: stack);
    return 0;
  }
});
