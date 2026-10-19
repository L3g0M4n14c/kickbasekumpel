import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/market_value_model.dart';
import '../models/transfer_model.dart';
import '../services/manager_transfer_history_service.dart';
import 'budget_calculation_providers.dart';
import 'kickbase_api_provider.dart';

/// Provider fuer die Auswertung von Manager-Transferhistorien.
final managerTransferHistoryServiceProvider =
    Provider<ManagerTransferHistoryService>(
      (ref) => ManagerTransferHistoryService(),
    );

/// Laedt die Transferhistorie eines Managers mit Marktwert zum Transferzeitpunkt.
final managerTransferHistoryProvider =
    FutureProvider.family<
      List<ManagerTransferHistoryEntry>,
      ({String leagueId, String managerId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final service = ref.watch(managerTransferHistoryServiceProvider);
      final response = await apiClient.getManagerTransferHistory(
        params.leagueId,
        params.managerId,
      );
      final allTransfers = service.transfersFromResponse(
        leagueId: params.leagueId,
        response: response,
      );

      // Nur Käufe (transferType == 1) anzeigen
      final transfers = allTransfers
          .where((transfer) => transfer.transferType == 1)
          .toList();

      if (transfers.isEmpty) return const [];

      // Zeitrahmen: 365 Tage (wie im Spieler-Dialog)
      final timeframe = 365;
      final playerIds = transfers.map((transfer) => transfer.playerId).toSet();

      // Performance: Marktwert-Requests parallel mit Limit ausführen,
      // damit bei vielen Transfers nicht minutenlange Ladezeiten entstehen.
      // Fehler pro Spieler werden abgefangen (leere Liste), statt den
      // gesamten Provider fehlschlagen zu lassen.
      const maxConcurrent = 8;
      final playerIdsList = playerIds.toList();
      final marketValueResults = <MapEntry<String, List<MarketValueEntry>>>[];

      for (var i = 0; i < playerIdsList.length; i += maxConcurrent) {
        final batch = playerIdsList.skip(i).take(maxConcurrent);
        final batchResults = await Future.wait(
          batch.map((playerId) async {
            try {
              final response = await apiClient.getPlayerMarketValue(
                params.leagueId,
                playerId,
                timeframe: timeframe,
              );
              // Manuelles Parsen wie im _MarketValueTab, um sicherzustellen, dass dt und mv korrekt gelesen werden
              final rawList = response['it'] as List<dynamic>? ?? const [];
              final values = rawList
                  .whereType<Map<String, dynamic>>()
                  .map((item) {
                    final rawDt = item['dt'];
                    final rawMv = item['mv'];
                    if (rawDt == null || rawMv == null) return null;
                    // dt = Tage seit 1.1.1970 (wie in der API)
                    final days = rawDt is int ? rawDt : (rawDt as num).toInt();
                    final mv = rawMv is int ? rawMv : (rawMv as num).toInt();
                    return MarketValueEntry(dt: days, mv: mv);
                  })
                  .whereType<MarketValueEntry>()
                  .toList();
              return MapEntry(playerId, values);
            } catch (_) {
              // Einzelner fehlgeschlagener Spieler darf die gesamte
              // Budget-Berechnung nicht blockieren.
              return MapEntry(playerId, <MarketValueEntry>[]);
            }
          }),
        );
        marketValueResults.addAll(batchResults);
      }

      final marketValuesByPlayer =
          Map<String, List<MarketValueEntry>>.fromEntries(marketValueResults);
      return service.enrichWithMarketValues(transfers, marketValuesByPlayer);
    });

/// Aggregierte Nachfrage der Liga: Käufe aller Manager pro Wochentag und
/// Zeitfenster (Story #15 – Verkaufs-Timing).
///
/// Grundlage sind die vollständigen Transfer-Historien aller Manager ab
/// Saisonstart (API-Paging via `getManagerTransferHistoryPaged`, ohne
/// Marktwert-Anreicherung – für die Nachfrage zählt nur das Kauf-Zeitfenster).
/// Der eigene Manager zählt mit, weil die Historie die Liga-Gesamtnachfrage
/// abbilden soll.
///
/// Der Hinweis ist Best-Effort: Fehler beim Ranking oder einzelner Manager
/// werden abgefangen (der Hinweis entfällt dann wegen zu weniger Daten) und
/// es laufen keine Provider-Retries, damit die Karte nicht auf einem
/// Retry-Stau hängen bleibt.
final leagueTransferDemandProvider =
    FutureProvider.family<TransferDemandProfile, String>((ref, leagueId) async {
      final service = ref.watch(managerTransferHistoryServiceProvider);
      final transfers = await _leagueTransfers(ref, leagueId, service);
      return service.demandProfile(transfers: transfers);
    }, retry: (retryCount, error) => null);

/// Laedt die Transfer-Historien aller Manager einer Liga ab Saisonstart.
///
/// Fehler beim Ranking oder einzelner Manager werden toleriert und als
/// leere Historie wiedergegeben.
Future<List<ManagerTransferHistoryEntry>> _leagueTransfers(
  Ref ref,
  String leagueId,
  ManagerTransferHistoryService service,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  final seasonStartDate = kLeagueSeasonStartDate;

  final Set<String> managerIds;
  try {
    final ranking = await apiClient.getLeagueRanking(leagueId);
    final managers =
        (ranking['us'] as List<dynamic>? ??
                ranking['it'] as List<dynamic>? ??
                const [])
            .whereType<Map<String, dynamic>>();
    managerIds = managers
        .map((manager) => (manager['i'] ?? manager['id'])?.toString() ?? '')
        .where((managerId) => managerId.isNotEmpty)
        .toSet();
  } catch (_) {
    // Ranking nicht ladbar: keine Datenbasis -> Hinweis entfaellt.
    return const [];
  }

  final histories = await Future.wait(
    managerIds.map((managerId) async {
      try {
        final response = await apiClient.getManagerTransferHistoryPaged(
          leagueId,
          managerId,
          since: seasonStartDate,
        );
        return service
            .transfersFromResponse(leagueId: leagueId, response: response)
            .where((transfer) => !transfer.timestamp.isBefore(seasonStartDate))
            .toList();
      } catch (_) {
        // Fehler einzelner Manager duerfen die Nachfrage-Aggregation
        // nicht verhindern.
        return <ManagerTransferHistoryEntry>[];
      }
    }),
  );
  return histories.expand((history) => history).toList();
}
