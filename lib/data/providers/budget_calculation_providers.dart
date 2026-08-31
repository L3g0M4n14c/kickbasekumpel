import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/budget_calculation_model.dart';
import '../models/transfer_model.dart';
import '../services/budget_calculation_service.dart';
import 'kickbase_api_provider.dart';
import 'manager_providers.dart';

// ============================================================================
// BUDGET CALCULATION PROVIDERS
// ============================================================================

/// Service Provider für Budget-Berechnung
final budgetCalculationServiceProvider = Provider<BudgetCalculationService>(
  (ref) => BudgetCalculationService(),
);

/// Fester Saison-/Ligastart der aktuellen Saison.
///
/// Die Kickbase-API liefert in `/v4/leagues/{leagueId}/overview` im Feld `dt`
/// kein zuverlässiges Startdatum für die Budget-Berechnung (der Wert liegt
/// NACH den ersten Transfers der Liga, sodass Frühabbruch im Paging und der
/// Datumsfilter im Budget-Provider Transfers verlieren). Daher ist der
/// Stichtag hier fest hinterlegt und muss zu Saisonbeginn angepasst werden.
final kLeagueSeasonStartDate = DateTime.utc(2026, 8, 21);

/// Provider für das Saisonstartdatum.
///
/// Gibt die feste Konstante [kLeagueSeasonStartDate] zurück. Die Transfers
/// werden seitenseitig ab diesem Datum geladen (Frühabbruch im Paging) und im
/// Budget-Provider nochmals danach gefiltert.
final leagueSeasonStartDateProvider = FutureProvider.family<DateTime, String>((
  ref,
  leagueId,
) async {
  return kLeagueSeasonStartDate;
});

/// Provider für die Budget-Berechnung eines Managers
///
/// Berechnet das aktuelle Budget basierend auf:
/// - Startbudget: 50 Mio. €
/// - Transfers: Verkäufe (addieren) und Käufe (subtrahieren)
///
/// Parameter:
/// - leagueId: Liga ID
/// - managerId: Manager ID
///
/// Returns: [BudgetCalculationResult] mit allen Berechnungsschritten
final managerBudgetCalculationProvider =
    FutureProvider.family<
      BudgetCalculationResult,
      ({String leagueId, String managerId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final calculationService = ref.watch(budgetCalculationServiceProvider);

      // 1. Dashboard-Daten und Saisondatum laden.
      // Wichtig: Wir nutzen denselben [managerDashboardProvider] wie der
      // Screen-Header (identischer Family-Key `leagueId + userId`), damit der
      // Request gecacht wird und NICHT ein zweites Mal gefeuert wird.
      final dashboardData = await ref.watch(
        managerDashboardProvider((
          leagueId: params.leagueId,
          userId: params.managerId,
        )).future,
      );
      final seasonStartDate = await ref.watch(
        leagueSeasonStartDateProvider(params.leagueId).future,
      );

      final managerName =
          dashboardData['userName'] ??
          dashboardData['name'] ??
          'Unbekannter Manager';

      // 2. Transferhistorie SEITENWEISE laden: Die Kickbase API liefert pro
      // Aufruf nur die neuesten ~25 Transfers. Für eine korrekte Budget-
      // berechnung müssen ALLE Transfers ab dem Saison-Startdatum berück-
      // sichtigt werden, daher laden wir so lange ältere Seiten nach, bis
      // die ältesten Transfers vor dem Saison-Start liegen.
      final transferHistoryData = await apiClient
          .getManagerTransferHistoryPaged(
            params.leagueId,
            params.managerId,
            since: seasonStartDate,
          );

      // 4. Transferhistorie normalisieren und nach Saisondatum filtern
      final rawTransfers = (transferHistoryData['it'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();

      final managerId =
          transferHistoryData['u']?.toString() ?? params.managerId;
      final managerNameFromTransfer =
          transferHistoryData['unm']?.toString() ?? managerName;

      // Transfers in ManagerTransferHistoryEntry umwandeln und nach Saison filtern
      final allTransfers = rawTransfers
          .map((rawTransfer) {
            return ManagerTransferHistoryEntry(
              id: rawTransfer['tid']?.toString() ?? '',
              leagueId: params.leagueId,
              managerId: managerId,
              managerName: managerNameFromTransfer,
              playerId: rawTransfer['pi']?.toString() ?? '',
              playerName: rawTransfer['pn']?.toString() ?? '',
              price: _asInt(rawTransfer['trp']),
              transferType: _asInt(rawTransfer['tty']),
              timestamp: _asDateTime(rawTransfer['dt']),
            );
          })
          .where((transfer) {
            // Nur Transfers nach oder am Saisondatum berücksichtigen
            return transfer.timestamp.isAtSameMomentAs(seasonStartDate) ||
                transfer.timestamp.isAfter(seasonStartDate);
          })
          .toList();

      // 5. Budget berechnen
      final result = calculationService.calculateManagerBudget(
        managerId: params.managerId,
        managerName: managerName,
        leagueId: params.leagueId,
        allTransfers: allTransfers,
      );

      return result;
    });

/// Hilfsfunktion: Konvertiere Wert in int
int _asInt(Object? value) => switch (value) {
  int value => value,
  num value => value.toInt(),
  String value => int.tryParse(value) ?? 0,
  _ => 0,
};

/// Hilfsfunktion: Konvertiere Wert in DateTime
///
/// Das dt-Feld in Transfers kommt als ISO-8601 String (z.B. "2026-08-21T08:59:41Z")
/// oder als Unix-Timestamp (Millisekunden, Sekunden oder Tage – letzteres für alte MarketValue-Daten)
DateTime _asDateTime(Object? value) {
  if (value is num) {
    int ms;
    if (value.abs() < 100000) {
      // Tage seit 1970
      ms = value.toInt() * Duration.millisecondsPerDay;
    } else if (value.abs() < 100000000000) {
      // Sekunden
      ms = value.toInt() * 1000;
    } else {
      ms = value.toInt();
    }
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }
  if (value is String) {
    // Reines Datums-Format ("2026-08-21", ohne Zeitanteil): als UTC-Mitternacht
    // parsen. DateTime.tryParse würde lokale Mitternacht liefern, und das
    // nachfolgende toUtc() würde das Datum auf den Vortag verschieben.
    final dateOnly = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
    if (dateOnly != null) {
      return DateTime.utc(
        int.parse(dateOnly.group(1)!),
        int.parse(dateOnly.group(2)!),
        int.parse(dateOnly.group(3)!),
      );
    }
    // Erst ISO-8601 versuchen
    final iso = DateTime.tryParse(value)?.toUtc();
    if (iso != null) return iso;
    // Fallback: numerischer String (z.B. "1736812800000")
    final asNum = num.tryParse(value);
    if (asNum != null) {
      int ms;
      if (asNum.abs() < 100000) {
        ms = asNum.toInt() * Duration.millisecondsPerDay;
      } else if (asNum.abs() < 100000000000) {
        ms = asNum.toInt() * 1000;
      } else {
        ms = asNum.toInt();
      }
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

/// Provider für die Budget-Berechnung mehrerer Manager
///
/// Lädt die Budgets für alle Manager in einer Liga
///
/// Parameter:
/// - leagueId: Liga ID
/// - managerIds: Liste der Manager IDs
///
/// Returns: Map<managerId, BudgetCalculationResult>
final managersBudgetCalculationProvider =
    FutureProvider.family<
      Map<String, BudgetCalculationResult>,
      ({String leagueId, List<String> managerIds})
    >((ref, params) async {
      final results = <String, BudgetCalculationResult>{};

      // Saisondatum einmal für alle Manager in dieser Liga laden
      // Dann wird es von Riverpod fuer jeden managerBudgetCalculationProvider gecached
      await ref.watch(
        leagueSeasonStartDateProvider(params.leagueId).future,
      );

      // Wichtig: Wir uebergeben das Saisondatum NICHT an die einzelnen Manager,
      // sondern verlassen uns auf das Caching von Riverpod.
      // Jeder managerBudgetCalculationProvider wird das Saisondatum aus dem
      // leagueSeasonStartDateProvider laden, und Riverpod cached es.

      for (final managerId in params.managerIds) {
        try {
          final result = await ref.watch(
            managerBudgetCalculationProvider((
              leagueId: params.leagueId,
              managerId: managerId,
            )).future,
          );
          results[managerId] = result;
        } catch (e) {
          // Fehler ignorieren und mit leeren Werten weitermachen
          continue;
        }
      }

      return results;
    });
