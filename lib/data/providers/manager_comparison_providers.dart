import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/manager_comparison_model.dart';
import '../models/transfer_model.dart';
import '../services/manager_comparison_service.dart';
import 'budget_calculation_providers.dart';
import 'manager_providers.dart';
import 'manager_transfer_history_providers.dart';
import 'user_providers.dart';

final _logger = Logger();

/// Service-Provider für den Manager-Direktvergleich.
///
/// Kapselt die rein vergleichende Logik ([ManagerComparisonService]).
final managerComparisonServiceProvider = Provider<ManagerComparisonService>((
  ref,
) {
  return ManagerComparisonService();
});

/// Lädt den Direktvergleich („Du vs. Rivale") zweier Manager einer Liga.
///
/// Parameter: `leagueId` sowie die beiden Manager-IDs – Seite A ist dabei
/// der zuerst genannte Manager (in der UI „Du").
///
/// Datenquellen je Manager (gecacht über die bestehenden Family-Provider):
/// - Dashboard (Name, Teamwert)
/// - Kader (positionsweise Summen + aktuelle Marktwerte)
/// - Performance (Spieltagspunkte `day`/`mdp`)
/// - Transferhistorie (Käufe inkl. Marktwert beim Kauf)
/// - Budget-Berechnung (Budget + Verkaufs-Einnahmen)
final managerComparisonProvider =
    FutureProvider.family<
      ManagerComparison,
      ({String leagueId, String managerAId, String managerBId})
    >((ref, params) async {
      final service = ref.watch(managerComparisonServiceProvider);
      final sides = await Future.wait([
        _loadSide(ref, service, params.leagueId, params.managerAId),
        _loadSide(ref, service, params.leagueId, params.managerBId),
      ]);
      // „Du vs. Rivale": Sobald der eigene Manager beteiligt ist, wird er
      // als Seite A geführt, damit das Kurzfazit konsistent aus „Deiner"
      // Sicht formuliert ist.
      final currentUserId = ref.watch(currentAuthUserIdProvider);
      var sideA = sides.first;
      var sideB = sides.last;
      if (sideB.managerId == currentUserId &&
          sideA.managerId != currentUserId) {
        sideA = sides.last;
        sideB = sides.first;
      }

      String labelFor(ManagerComparisonSide side) =>
          side.managerId == currentUserId ? 'Du' : side.managerName;

      return service.compare(
        a: sideA,
        b: sideB,
        aLabel: labelFor(sideA),
        bLabel: labelFor(sideB),
      );
    });

/// Lädt alle Vergleichsdaten eines Managers und baut seinen Datensatz.
///
/// Budget und Transferhistorie sind optionale Zusatzdaten – schlagen sie
/// fehl, wird der Vergleich ohne sie aufgebaut (Budget `null`).
Future<ManagerComparisonSide> _loadSide(
  Ref ref,
  ManagerComparisonService service,
  String leagueId,
  String managerId,
) async {
  // Dashboard: Name + Teamwert (identischer Family-Key wie der
  // Manager-Detail-Screen → gecacht).
  final dashboard = await ref.watch(
    managerDashboardProvider((leagueId: leagueId, userId: managerId)).future,
  );
  final name =
      (dashboard['unm'] ??
              dashboard['userName'] ??
              dashboard['name'] ??
              'Unbekannt')
          .toString();
  final teamValue = _asInt(dashboard['teamValue'] ?? dashboard['tv']);

  // Kader: Positionssummen + aktueller Marktwert je Spieler (für den
  // Kursgewinn der Käufe).
  final squad = await ref.watch(
    managerSquadProvider((leagueId: leagueId, userId: managerId)).future,
  );
  final squadPlayers = (squad['it'] as List? ?? [])
      .whereType<Map<String, dynamic>>()
      .toList();
  final currentPlayerValues = <String, int>{};
  for (final player in squadPlayers) {
    final id =
        (player['pi'] ?? player['i'] ?? player['id'])?.toString().trim() ?? '';
    if (id.isEmpty) continue;
    currentPlayerValues[id] = _asInt(player['mv'] ?? player['marketValue']);
  }

  // Performance: Spieltagspunkte der aktuellen Saison.
  final performance = await ref.watch(
    managerPerformanceProvider((leagueId: leagueId, userId: managerId)).future,
  );
  final matchdayPoints = _matchdayPoints(performance);

  // Transferhistorie (Käufe inkl. Marktwert beim Kauf).
  var transfers = const <ManagerTransferHistoryEntry>[];
  try {
    transfers = await ref.watch(
      managerTransferHistoryProvider((leagueId: leagueId, managerId: managerId))
          .future,
    );
  } catch (e) {
    _logger.w('⚠️ Direktvergleich: Transferhistorie von $managerId fehlt: $e');
  }

  // Budget (transferbasierte Berechnung) + Verkaufs-Einnahmen.
  int? budget;
  var totalIncome = 0;
  try {
    final budgetResult = await ref.watch(
      managerBudgetCalculationProvider((
        leagueId: leagueId,
        managerId: managerId,
      )).future,
    );
    budget = budgetResult.currentBudget;
    totalIncome = budgetResult.totalSales;
  } catch (e) {
    _logger.w('⚠️ Direktvergleich: Budget von $managerId fehlt: $e');
  }

  return service.buildSide(
    managerId: managerId,
    managerName: name,
    teamValue: teamValue,
    budget: budget,
    matchdayPoints: matchdayPoints,
    positionPoints: service.positionPoints(squadPlayers),
    transferStats: service.transferStats(
      transfers: transfers,
      currentPlayerValues: currentPlayerValues,
      totalIncome: totalIncome,
    ),
  );
}

/// Extrahiert die Spieltagspunkte (`day`/`mdp`) der aktuellen Saison.
///
/// API-Struktur: `{ it: [ { it: [ { day, mdp, tw, cur } ] } ] }` – die
/// Saisons sind alt→neu sortiert, daher wird von hinten nach der neuesten
/// Saison mit `cur == true` gesucht (Fallback: letzte Saison).
List<MatchdayPoints> _matchdayPoints(Map<String, dynamic> performance) {
  final seasons = (performance['it'] as List? ?? [])
      .whereType<Map<String, dynamic>>()
      .toList();
  if (seasons.isEmpty) return const [];

  final currentSeason = seasons.reversed.firstWhere(
    (season) => ((season['it'] as List?) ?? []).any(
      (d) => d is Map && d['cur'] == true,
    ),
    orElse: () => seasons.last,
  );

  return (currentSeason['it'] as List? ?? [])
      .whereType<Map<String, dynamic>>()
      .where(
        (day) =>
            _asInt(day['day']) > 0 &&
            (_asInt(day['mdp']) > 0 || day['cur'] == true),
      )
      .map(
        (day) => MatchdayPoints(
          matchDay: _asInt(day['day']),
          points: _asInt(day['mdp']),
        ),
      )
      .toList();
}

int _asInt(Object? value) => switch (value) {
  int value => value,
  num value => value.toInt(),
  String value => int.tryParse(value) ?? 0,
  _ => 0,
};
