import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transfer_model.dart';
import '../services/bid_recommendation_service.dart';
import '../services/budget_calculation_service.dart';
import 'budget_calculation_providers.dart';
import 'kickbase_api_provider.dart';
import 'manager_transfer_history_providers.dart';
import 'user_providers.dart';

/// Provider fuer die Berechnung konservativer Gebotsempfehlungen.
final bidRecommendationServiceProvider = Provider<BidRecommendationService>(
  (ref) => const BidRecommendationService(),
);

/// IDs aller Konkurrenten einer Liga (ohne den aktuellen Manager).
///
/// Grundlage ist das Liga-Ranking; doppelte Eintraege werden entfernt. Die
/// Ermittlung ist fuer alle Marktspieler identisch und wird daher nur einmal
/// pro Liga geladen und gecacht.
final leagueCompetitorIdsProvider = FutureProvider.family<List<String>, String>(
  (ref, leagueId) async {
    final apiClient = ref.watch(kickbaseApiClientProvider);
    final currentManagerId = ref.watch(currentAuthUserIdProvider);
    final ranking = await apiClient.getLeagueRanking(leagueId);
    final managers =
        (ranking['us'] as List<dynamic>? ??
                ranking['it'] as List<dynamic>? ??
                const [])
            .whereType<Map<String, dynamic>>();
    return managers
        .map((manager) => (manager['i'] ?? manager['id'])?.toString() ?? '')
        .where(
          (managerId) => managerId.isNotEmpty && managerId != currentManagerId,
        )
        .toSet()
        .toList();
  },
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
      final managerIds = await ref.watch(
        leagueCompetitorIdsProvider(leagueId).future,
      );

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

/// Budgets aller Konkurrenten einer Liga (ohne den aktuellen Manager).
///
/// Die Budgets werden ligaweit über [managersBudgetCalculationProvider]
/// berechnet und als reine Betragsliste bereitgestellt – die Auswertung
/// gegenüber einem konkreten Gebot übernimmt [competitorBudgetHintProvider].
final leagueCompetitorBudgetsProvider =
    FutureProvider.family<List<int>, String>((ref, leagueId) async {
      final managerIds = await ref.watch(
        leagueCompetitorIdsProvider(leagueId).future,
      );
      if (managerIds.isEmpty) return const <int>[];

      final budgets = await ref.watch(
        managersBudgetCalculationProvider((
          leagueId: leagueId,
          managerIds: managerIds,
        )).future,
      );
      return budgets.values
          .map((result) => result.currentBudget)
          .toList(growable: false);
    });

/// Vergleicht ein konkretes Gebot mit den Budgets der Mitbieter.
///
/// Liefert den [CompetitorBudgetHint] für die Gebots-Card: Anzahl der
/// Manager, die das Gebot noch überbieten könnten, plus höchstes
/// Konkurrenz-Budget. Der Vergleich ist synchron und folgt sofort jeder
/// Änderung des Gebots – nur das Budget-Laden per Liga ist asynchron.
final competitorBudgetHintProvider =
    Provider.family<
      AsyncValue<CompetitorBudgetHint>,
      ({String leagueId, int bidAmount})
    >((ref, params) {
      final budgets = ref.watch(
        leagueCompetitorBudgetsProvider(params.leagueId),
      );
      final calculationService = ref.watch(budgetCalculationServiceProvider);
      return budgets.whenData(
        (competitorBudgets) => calculationService.analyzeCompetitorBudgets(
          bidAmount: params.bidAmount,
          competitorBudgets: competitorBudgets,
        ),
      );
    });
