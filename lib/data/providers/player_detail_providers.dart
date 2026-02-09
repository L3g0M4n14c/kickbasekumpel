import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kickbase_api_provider.dart';

// ============================================================================
// PLAYER DETAIL PROVIDERS - Schritt 5
// ============================================================================

/// Player Details Provider
/// GET /v4/leagues/{leagueId}/players/{playerId}
/// Returns complete player details
final playerDetailsProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String playerId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getPlayerDetails(params.leagueId, params.playerId);
    });

/// Player Market Value Provider
/// GET /v4/leagues/{leagueId}/players/{playerId}/marketvalue/{timeframe}
/// Returns market value history for a player
final playerMarketValueProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String playerId, int timeframe})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getPlayerMarketValue(
        params.leagueId,
        params.playerId,
        timeframe: params.timeframe,
      );
    });

/// Convenience provider for player market value (365 days default)
final playerMarketValueYearProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String playerId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getPlayerMarketValue(
        params.leagueId,
        params.playerId,
        timeframe: 365,
      );
    });

/// Player Transfer History Provider
/// GET /v4/leagues/{leagueId}/players/{playerId}/transferHistory
/// Returns transfer history for a player
final playerTransferHistoryProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String playerId, int? matchDay})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getPlayerTransferHistory(
        params.leagueId,
        params.playerId,
        matchDay: params.matchDay,
      );
    });

/// Convenience provider for player transfer history (current matchday)
final currentPlayerTransferHistoryProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String playerId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getPlayerTransferHistory(
        params.leagueId,
        params.playerId,
      );
    });

/// Player Transfers Provider
/// GET /v4/leagues/{leagueId}/players/{playerId}/transfers
/// Returns all transfers for a player
final playerTransfersProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String playerId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getPlayerTransfers(
        params.leagueId,
        params.playerId,
      );
    });
