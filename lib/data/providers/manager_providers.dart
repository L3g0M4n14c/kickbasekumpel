import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// MANAGER PROVIDERS - Schritt 5
// ============================================================================

/// Manager Dashboard Provider
/// GET /v4/leagues/{leagueId}/managers/{userId}/dashboard
/// Returns manager profile and dashboard data
final managerDashboardProvider = FutureProvider.family<Map<String, dynamic>, ({String leagueId, String userId})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getManagerDashboard(params.leagueId, params.userId);
});

/// Manager Performance Provider
/// GET /v4/leagues/{leagueId}/managers/{userId}/performance
/// Returns manager performance history
final managerPerformanceProvider = FutureProvider.family<Map<String, dynamic>, ({String leagueId, String userId})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getManagerPerformance(params.leagueId, params.userId);
});

/// Manager Squad Provider
/// GET /v4/leagues/{leagueId}/managers/{userId}/squad
/// Returns manager's squad (players)
final managerSquadProvider = FutureProvider.family<Map<String, dynamic>, ({String leagueId, String userId})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getManagerSquad(params.leagueId, params.userId);
});
