import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/budget_calculation_model.dart';
import '../models/market_value_model.dart';
import '../models/performance_model.dart';
import '../models/transfer_model.dart';
import '../services/auto_sale_budget_service.dart';
import '../services/budget_calculation_service.dart';
import 'kickbase_api_provider.dart';
import 'manager_providers.dart';
import 'player_detail_providers.dart';

// ============================================================================
// BUDGET CALCULATION PROVIDERS
// ============================================================================

/// Service Provider für Budget-Berechnung
final budgetCalculationServiceProvider = Provider<BudgetCalculationService>(
  (ref) => BudgetCalculationService(),
);

/// Service Provider für die Auto-Verkauf-Auswertung (250er-Regel)
final autoSaleBudgetServiceProvider = Provider<AutoSaleBudgetService>(
  (ref) => AutoSaleBudgetService(),
);

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// Maximale Anzahl paralleler Spieler-Requests (Performance/Marktwert)
const _maxConcurrentFetches = 8;

/// Zeitrahmen der Marktwert-Historie in Tagen (wie im Spieler-Dialog)
const _marketValueTimeframeDays = 365;

/// Konfiguration des automatischen Spielerverkaufs ("Auto-Verkauf").
class LeagueAutoSaleConfig {
  /// true, wenn die Punkte-Schwelle aktiv ist (Feld `ptspf` > 0)
  final bool active;

  /// Punkte-Schwelle (z.B. 250), ab der Spieler automatisch verkauft werden
  final int threshold;

  const LeagueAutoSaleConfig({required this.active, required this.threshold});
}

/// Provider für die Auto-Verkauf-Konfiguration einer Liga.
///
/// Liest das undokumentierte Feld `ptspf` aus dem League-Overview-Endpoint
/// (Kickbase-Update 4.8.0): Die Saison-Punktzahl, ab der Spieler automatisch
/// an den Transfermarkt verkauft werden (z.B. 250). `ptspf` fehlt oder ist 0,
/// wenn die Regel nicht aktiv ist.
final leagueAutoSaleConfigProvider =
    FutureProvider.family<LeagueAutoSaleConfig, String>((ref, leagueId) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final overview = await apiClient.getLeagueOverview(leagueId);

      final threshold = _asInt(overview['ptspf']);
      _logger.i(
        '⚙️ Auto-Verkauf-Konfiguration (Liga $leagueId): '
        'ptspf=$threshold → ${threshold > 0 ? "AKTIV" : "inaktiv"}',
      );

      return LeagueAutoSaleConfig(active: threshold > 0, threshold: threshold);
    });

/// Lädt die Startelfen (`lp`) aller Manager für jeden abgeschlossenen
/// Spieltag der aktuellen Saison.
///
/// Grundlage ist der Ranking-Endpoint (`?dayNumber=X`), der pro Manager die
/// `lp`-Spieler-IDs des Spieltags liefert – genau die Datenquelle des
/// Tabellen-Tabs. Damit lässt sich der Kader-Besitz pro Spieltag auch ohne
/// Transfer-Historie rekonstruieren (wichtig für Zulostung-Spieler).
///
/// Returns: Map<Spieltag, Map<ManagerId, Set<SpielerId>>>
final leagueLineupsByMatchdayProvider =
    FutureProvider.family<Map<int, Map<String, Set<String>>>, String>((
      ref,
      leagueId,
    ) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);

      // Aktuelle Ranking-Response: `lfmd` = letzter abgeschlossener Spieltag.
      final current = await apiClient.getLeagueRanking(leagueId);
      final lastFinished = _asInt(current['lfmd']);
      final result = <int, Map<String, Set<String>>>{};
      if (lastFinished <= 0) return result;

      const maxConcurrent = 8;
      final days = List<int>.generate(lastFinished, (i) => i + 1);
      for (var i = 0; i < days.length; i += maxConcurrent) {
        final batch = days.skip(i).take(maxConcurrent);
        final pages = await Future.wait(
          batch.map((day) async {
            try {
              final ranking = await apiClient.getLeagueRanking(
                leagueId,
                matchDay: day,
              );
              return MapEntry(day, ranking);
            } catch (_) {
              // Ein fehlender Spieltag darf die Gesamtauswertung nicht
              // blockieren.
              return MapEntry(day, null);
            }
          }),
        );

        for (final entry in pages) {
          final ranking = entry.value;
          if (ranking == null) continue;
          final users = (ranking['us'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList();
          final byUser = <String, Set<String>>{};
          for (final user in users) {
            final userId = user['i']?.toString() ?? '';
            final lineup = (user['lp'] as List? ?? [])
                .map((id) => id.toString())
                .toSet();
            if (userId.isNotEmpty && lineup.isNotEmpty) {
              byUser[userId] = lineup;
            }
          }
          if (byUser.isNotEmpty) result[entry.key] = byUser;
        }
      }

      return result;
    });

/// Parst die Marktwert-Historie aus der Rohresponse des
/// Marketvalue-Endpoints (`it`-Liste mit `dt` = Tage seit 1970, `mv`).
List<MarketValueEntry> _marketValuesFromResponse(
  Map<String, dynamic> response,
) {
  final rawList = response['it'] as List<dynamic>? ?? const [];
  return rawList
      .whereType<Map<String, dynamic>>()
      .map((item) {
        final rawDt = item['dt'];
        final rawMv = item['mv'];
        if (rawDt == null || rawMv == null) return null;
        final days = rawDt is int ? rawDt : (rawDt as num).toInt();
        final mv = rawMv is int ? rawMv : (rawMv as num).toInt();
        return MarketValueEntry(dt: days, mv: mv);
      })
      .whereType<MarketValueEntry>()
      .toList();
}

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
      var result = calculationService.calculateManagerBudget(
        managerId: params.managerId,
        managerName: managerName,
        leagueId: params.leagueId,
        allTransfers: allTransfers,
      );

      // 5b. Täglicher Anmeldebonus berücksichtigen.
      //
      // Jeder Manager bekommt am ersten Tag der Liga 10.000 €, am zweiten
      // Tag 20.000 €, … am zehnten Tag 100.000 € – und ab da an jedem Tag
      // konstant 100.000 €. Der Bonus ist für alle Manager identisch und
      // wird kumuliert seit dem Saison-Start aufs Budget aufgerechnet.
      final loginBonus = calculationService.calculateLoginBonus(
        seasonStart: seasonStartDate,
      );
      if (loginBonus > 0) {
        final loginBonusDays = calculationService
            .loginBonusDaysSince(seasonStartDate);
        _logger.i(
          '🎁 Anmeldebonus: $loginBonusDays Liga-Tag(e) → '
          '+$loginBonus € für Manager ${params.managerId}',
        );
        result = result.copyWith(
          loginBonus: loginBonus,
          loginBonusDays: loginBonusDays,
          currentBudget: result.currentBudget + loginBonus,
        );
      }

      // 6. Auto-Verkauf ("250er-Regel") berücksichtigen.
      //
      // Spieler, die die Punkte-Schwelle (Overview-Feld `ptspf`, z.B. 250)
      // erreichen, werden von Kickbase automatisch an den Transfermarkt
      // verkauft. Diese Verkäufe erscheinen NICHT in der Transfer-Historie
      // des Managers, daher wird das dabei eingenommene Budget (Marktwert
      // zum Verkaufszeitpunkt) hier spieltagweise rekonstruiert und addiert.
      final autoSaleConfig = await ref.watch(
        leagueAutoSaleConfigProvider(params.leagueId).future,
      );

      if (autoSaleConfig.active) {
        final autoSaleService = ref.watch(autoSaleBudgetServiceProvider);

        // Besitz-Zeiträume des Managers aus der Transfer-Historie ableiten.
        var periods = autoSaleService.ownershipPeriods(
          transfers: allTransfers,
          seasonStart: seasonStartDate,
        );

        // Lücke schließen: Spieler aus der Zulostung zum Saisonstart haben
        // KEINEN Transfer-Eintrag und wären sonst unsichtbar. Über die
        // Startelfen (`lp`) der abgeschlossenen Spieltage (gleiche Daten-
        // quelle wie der Tabellen-Tab) werden sie ergänzt.
        final lineupsByMatchday = await ref.watch(
          leagueLineupsByMatchdayProvider(params.leagueId).future,
        );
        final managerLineups = <int, Set<String>>{
          for (final entry in lineupsByMatchday.entries)
            if (entry.value[params.managerId] != null)
              entry.key: entry.value[params.managerId]!,
        };
        periods = autoSaleService.mergeLineupOwnership(
          historyPeriods: periods,
          lineupsByMatchday: managerLineups,
          seasonStart: seasonStartDate,
        );

        // Performance- und Marktwert-Daten pro Kandidat parallel laden
        // (Limit 8 wie in managerTransferHistoryProvider). Fehler pro
        // Spieler werden abgefangen, statt die Berechnung scheitern zu
        // lassen. Die Family-Provider cachen über alle Manager hinweg.
        final candidateIds = periods.map((p) => p.playerId).toSet().toList();
        final performanceByPlayer = <String, PlayerPerformanceResponse>{};
        final marketValuesByPlayer = <String, List<MarketValueEntry>>{};

        for (var i = 0; i < candidateIds.length; i += _maxConcurrentFetches) {
          final batch = candidateIds.skip(i).take(_maxConcurrentFetches);
          await Future.wait(
            batch.map((playerId) async {
              try {
                final performance = await ref.watch(
                  playerPerformanceProvider((
                    leagueId: params.leagueId,
                    playerId: playerId,
                  )).future,
                );
                if (performance.it.isNotEmpty) {
                  performanceByPlayer[playerId] = performance;
                }
              } catch (_) {
                // Fehlende Performance-Daten: Spieler ohne Auto-Sale-Ereignis.
              }

              try {
                final mvResponse = await apiClient.getPlayerMarketValue(
                  params.leagueId,
                  playerId,
                  timeframe: _marketValueTimeframeDays,
                );
                marketValuesByPlayer[playerId] = _marketValuesFromResponse(
                  mvResponse,
                );
              } catch (_) {
                // Ohne MV-Historie wird der Event als "uncertain" verbucht.
              }
            }),
          );
        }

        final computation = autoSaleService.computeAutoSales(
          threshold: autoSaleConfig.threshold,
          periods: periods,
          seasonStart: seasonStartDate,
          performanceByPlayer: performanceByPlayer,
          marketValuesByPlayer: marketValuesByPlayer,
          now: DateTime.now().toUtc(),
        );

        if (computation.events.isNotEmpty) {
          _logger.i(
            '💰 Auto-Verkauf (Schwelle ${autoSaleConfig.threshold} Punkte): '
            '${computation.events.length} Verkauf(e), '
            '+${computation.totalIncome} € für Manager ${params.managerId}',
          );
        }

        // Namen für lp-basierte Events nachladen (die Startelfen enthalten
        // nur Spieler-IDs, keine Namen).
        final events = <AutoSaleEvent>[];
        for (final event in computation.events) {
          if (event.playerName.isNotEmpty) {
            events.add(event);
            continue;
          }
          try {
            final details = await apiClient.getPlayerDetails(
              params.leagueId,
              event.playerId,
            );
            final name = [details['fn'], details['ln'] ?? details['n']]
                .whereType<String>()
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .join(' ')
                .trim();
            events.add(
              event.copyWith(
                playerName: name.isNotEmpty ? name : event.playerId,
              ),
            );
          } catch (_) {
            events.add(event.copyWith(playerName: event.playerId));
          }
        }

        result = result.copyWith(
          autoSaleIncome: computation.totalIncome,
          autoSaleEvents: events,
          currentBudget: result.currentBudget + computation.totalIncome,
        );
      }

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
      await ref.watch(leagueSeasonStartDateProvider(params.leagueId).future);

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
