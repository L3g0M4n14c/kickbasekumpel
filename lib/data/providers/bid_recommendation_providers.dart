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

/// Laedt ligaweit alle Kaeufe der Konkurrenten inklusive Marktwert zum
/// Transferzeitpunkt.
///
/// Die Daten sind fuer alle Marktspieler identisch und werden daher nur
/// einmal pro Liga geladen und gecacht, statt den kompletten Abruf fuer
/// jeden geoeffneten Kauf-Dialog zu wiederholen.
final leagueCompetitorPurchasesProvider =
    FutureProvider.family<List<ManagerTransferHistoryEntry>, String>((
      ref,
      leagueId,
    ) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final currentManagerId = ref.watch(currentAuthUserIdProvider);
      final ranking = await apiClient.getLeagueRanking(leagueId);
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
                leagueId: leagueId,
                managerId: managerId,
              )).future,
            );
          } catch (_) {
            return <ManagerTransferHistoryEntry>[];
          }
        }),
      );
      return histories.expand((history) => history).toList();
    });

/// Leitet fuer einen Marktspieler eine Gebotsempfehlung aus den
/// Konkurrenzdaten ab.
final recommendedBidProvider =
    FutureProvider.family<
      BidRecommendation,
      ({String leagueId, int currentMarketValue, int minimumBid})
    >((ref, params) async {
      final transfers = await ref.watch(
        leagueCompetitorPurchasesProvider(params.leagueId).future,
      );
      return ref
          .watch(bidRecommendationServiceProvider)
          .recommend(
            currentMarketValue: params.currentMarketValue,
            minimumBid: params.minimumBid,
            transfers: transfers,
          );
    });
