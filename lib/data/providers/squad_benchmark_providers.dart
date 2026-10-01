import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/player_model.dart';
import '../models/squad_benchmark_model.dart';
import '../services/squad_benchmark_service.dart';
import '../utils/parsing_utils.dart';
import 'league_detail_providers.dart';
import 'manager_providers.dart';

// ============================================================================
// SQUAD BENCHMARK PROVIDERS
// ============================================================================

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// Service Provider für den Kader-Benchmark
final squadBenchmarkServiceProvider = Provider<SquadBenchmarkService>(
  (ref) => SquadBenchmarkService(),
);

/// Liefert die eigene Manager-ID in der Liga (aus dem `/me`-Endpoint).
///
/// Das `u`-Feld der Response ist je nach API-Version ein String (User-ID)
/// oder ein Objekt (`{'i': ...}`). Beide Varianten werden abgedeckt.
final myLeagueUserIdProvider = FutureProvider.family<String, String>((
  ref,
  leagueId,
) async {
  final me = await ref.watch(leagueMeProvider(leagueId).future);
  final u = me['u'];
  if (u is Map) return (u['i'] ?? u['id'] ?? '').toString();
  return u?.toString() ?? '';
});

/// Provider für den positionsweisen Kader-Benchmark einer Liga.
///
/// Aggregiert die Kader ALLER Manager der Liga (via Ranking-Endpoint und
/// Squad-Endpunkt pro Manager) und vergleicht sie positionsweise mit dem
/// eigenen Kader: Marktwert-Summe, Ø-Punkte und Spieleranzahl.
///
/// Die Squad-Family-Provider werden von Riverpod gecacht und teilen sich
/// Requests mit dem Manager-Detail-Screen.
final leagueSquadBenchmarkProvider = FutureProvider.family<SquadBenchmark, String>((
  ref,
  leagueId,
) async {
  final apiService = ref.watch(squadBenchmarkServiceProvider);

  // 1. Alle Manager der Liga über das aktuelle Ranking ermitteln.
  final ranking = await ref.watch(currentLeagueRankingProvider(leagueId).future);
  final users = (ranking['us'] as List? ?? [])
      .whereType<Map<String, dynamic>>()
      .toList();

  final myUserId = await ref.watch(myLeagueUserIdProvider(leagueId).future);

  // 2. Eigenen Kader als vollständige Player-Objekte laden
  //    (gleiche Parsing-Kette wie teamPlayersProvider: Squad-JSON →
  //    normalizePlayerJson → Player.fromJson).
  final ownSquadData = await ref.watch(mySquadProvider(leagueId).future);
  final ownPlayers = ((ownSquadData['it'] as List?) ?? [])
      .whereType<Map<String, dynamic>>()
      .map((json) {
        try {
          return Player.fromJson(normalizePlayerJson(json));
        } catch (_) {
          return null;
        }
      })
      .whereType<Player>()
      .toList();

  // 3. Fremd-Kader parallel laden (Fehler pro Manager abfangen).
  final managerSquads = <String, List<Map<String, dynamic>>>{};
  const maxConcurrent = 8;
  final others = users
      .where((u) => (u['i']?.toString() ?? '') != myUserId)
      .map((u) => u['i'].toString())
      .toList();

  for (var i = 0; i < others.length; i += maxConcurrent) {
    final batch = others.skip(i).take(maxConcurrent);
    await Future.wait(
      batch.map((managerId) async {
        try {
          final squadData = await ref.watch(
            managerSquadProvider((leagueId: leagueId, userId: managerId)).future,
          );
          final players = (squadData['it'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList();
          if (players.isNotEmpty) managerSquads[managerId] = players;
        } catch (e) {
          _logger.w(
            '⚠️ Kader-Benchmark: Squad von Manager $managerId nicht ladbar: $e',
          );
        }
      }),
    );
  }

  final benchmark = apiService.aggregate(
    ownPlayers: ownPlayers,
    managerSquads: managerSquads,
  );

  _logger.i(
    '📊 Kader-Benchmark (Liga $leagueId): ${benchmark.managerCount} Manager, '
    'eigener Wert ${benchmark.ownTotalMarketValue} € vs. Ø '
    '${benchmark.leagueAvgTotalMarketValue.toStringAsFixed(0)} €',
  );

  return benchmark;
});
