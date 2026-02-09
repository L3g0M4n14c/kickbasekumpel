import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// LIVE PROVIDERS - Schritt 5
// ============================================================================

/// My Eleven Provider (Live Lineup)
/// GET /v4/leagues/{leagueId}/teamcenter/myeleven
/// Returns current lineup with live points
final myElevenProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getMyEleven(leagueId);
});

/// Live Event Types Provider
/// GET /v4/live/eventtypes
/// Returns available live event types
final liveEventTypesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getLiveEventTypes();
});

/// Bonus Collect Provider
/// GET /v4/bonus/collect
/// Collects daily bonus - note: this is a state-changing operation
/// Use with caution - calling this provider will trigger the bonus collection
final collectBonusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.collectBonus();
});
