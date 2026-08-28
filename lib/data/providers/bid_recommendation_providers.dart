import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transfer_model.dart';
import '../services/bid_recommendation_service.dart';
import 'kickbase_api_provider.dart';
import 'manager_transfer_history_providers.dart';
import 'user_providers.dart';

/// Provider fuer die Berechnung konservativer Gebotsempfehlungen.
final bidRecommendationServiceProvider = Provider<BidRecommendationService>(
  (ref) => const BidRecommendationService(),
);

/// Leitet fuer einen Marktspieler ein Gebot aus den Konkurrenzdaten ab.
final recommendedBidProvider =
    FutureProvider.family<
      int,
      ({String leagueId, int currentMarketValue, int minimumBid})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final currentManagerId = ref.watch(currentAuthUserIdProvider);
      final ranking = await apiClient.getLeagueRanking(params.leagueId);
      final managers =
          (ranking['us'] as List<dynamic>? ??
                  ranking['it'] as List<dynamic>? ??
                  const [])
              .whereType<Map<String, dynamic>>();
      final managerIds = managers
          .map((manager) => (manager['i'] ?? manager['id'])?.toString() ?? '')
          .where(
            (managerId) =>
                managerId.isNotEmpty && managerId != currentManagerId,
          )
          .toSet();

      final histories = await Future.wait(
        managerIds.map((managerId) async {
          try {
            return await ref.read(
              managerTransferHistoryProvider((
                leagueId: params.leagueId,
                managerId: managerId,
              )).future,
            );
          } catch (_) {
            return <ManagerTransferHistoryEntry>[];
          }
        }),
      );
      final transfers = histories.expand((history) => history).toList();
      return ref
          .watch(bidRecommendationServiceProvider)
          .recommendBid(
            currentMarketValue: params.currentMarketValue,
            minimumBid: params.minimumBid,
            transfers: transfers,
          );
    });
