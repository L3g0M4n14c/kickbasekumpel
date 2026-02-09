import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// SCOUTED PLAYERS PROVIDERS - Schritt 5
// ============================================================================

/// Scouted Players Provider (Watchlist)
/// GET /v4/leagues/{leagueId}/scoutedplayers
/// Returns list of players on watchlist
final scoutedPlayersProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getScoutedPlayers(leagueId);
});
