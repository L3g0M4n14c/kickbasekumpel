import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// LEAGUE DETAIL PROVIDERS - Schritt 5
// ============================================================================

/// League Me Provider
/// GET /v4/leagues/{leagueId}/me
/// Returns own stats in the league
final leagueMeProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getLeagueMe(leagueId);
});

/// My Budget Provider
/// GET /v4/leagues/{leagueId}/me/budget
/// Returns current budget in the league
final myBudgetProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getMyBudget(leagueId);
});

/// My Squad Provider
/// GET /v4/leagues/{leagueId}/squad
/// Returns own squad (players)
final mySquadProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getMySquad(leagueId);
});

/// League Ranking Provider
/// GET /v4/leagues/{leagueId}/ranking
/// Returns league ranking, optionally for a specific matchday
final leagueRankingProvider = FutureProvider.family<Map<String, dynamic>, ({String leagueId, int? matchDay})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getLeagueRanking(params.leagueId, matchDay: params.matchDay);
});

/// Convenience provider for current matchday ranking
final currentLeagueRankingProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getLeagueRanking(leagueId);
});
