import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// COMPETITION PROVIDERS - Schritt 5
// ============================================================================

/// Competition Table Provider
/// GET /v4/competitions/{competitionId}/table
/// Returns competition table (e.g., Bundesliga table)
final competitionTableProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  competitionId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getCompetitionTable(competitionId);
});

/// Competition Matchdays Provider
/// GET /v4/competitions/{competitionId}/matchdays
/// Returns all matchdays for a competition
final competitionMatchdaysProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  competitionId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getCompetitionMatchdays(competitionId);
});

/// Player Event History Provider
/// GET /v4/competitions/{competitionId}/playercenter/{playerId}
/// Returns player match details and event history
final playerEventHistoryProvider = FutureProvider.family<Map<String, dynamic>, ({String competitionId, String playerId, int? matchDay})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getPlayerEventHistory(
    params.competitionId,
    params.playerId,
    matchDay: params.matchDay,
  );
});

/// Convenience provider for player event history (current matchday)
final currentPlayerEventHistoryProvider = FutureProvider.family<Map<String, dynamic>, ({String competitionId, String playerId})>((
  ref,
  params,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getPlayerEventHistory(
    params.competitionId,
    params.playerId,
  );
});

/// Convenience provider for Bundesliga table (competitionId = "1")
final bundesligaTableProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getCompetitionTable('1');
});
