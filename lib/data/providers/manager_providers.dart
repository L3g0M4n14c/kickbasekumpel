import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kickbase_api_provider.dart';
import 'league_detail_providers.dart';

// ============================================================================
// MANAGER PROVIDERS - Schritt 5
// ============================================================================

/// Manager Dashboard Provider
/// GET /v4/leagues/{leagueId}/managers/{userId}/dashboard
/// Returns manager profile and dashboard data
final managerDashboardProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String userId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getManagerDashboard(
        params.leagueId,
        params.userId,
      );
    });

/// Manager Performance Provider
/// GET /v4/leagues/{leagueId}/managers/{userId}/performance
/// Returns manager performance history
final managerPerformanceProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String userId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getManagerPerformance(
        params.leagueId,
        params.userId,
      );
    });

/// Manager Squad Provider
/// GET /v4/leagues/{leagueId}/managers/{userId}/squad
/// Returns manager's squad (players)
final managerSquadProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, String userId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getManagerSquad(params.leagueId, params.userId);
    });

/// Manager Lineup Players Provider
///
/// Lädt die Spieler der Startelf (`lp`) eines Managers für einen bestimmten
/// Spieltag. Spieler, die nicht mehr im aktuellen Kader sind (z.B. verkauft),
/// werden über den Player-Details-Endpunkt nachgeladen – analog zur
/// `loadPlayersForLineup`-Logik der iOS-Vorgänger-App.
///
/// Returns a list of raw player maps, die mit [normalizePlayerJson] verarbeitet
/// werden können.
final managerLineupPlayersProvider =
    FutureProvider.family<
      List<Map<String, dynamic>>,
      ({String leagueId, String userId, int matchDay})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);

      // 1. Rangliste für Spieltag → lp-IDs ermitteln
      final ranking = await ref.watch(
        leagueRankingProvider((
          leagueId: params.leagueId,
          matchDay: params.matchDay,
        )).future,
      );

      final users = (ranking['us'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();

      final matchUser = users.firstWhere(
        (u) => u['i'] == params.userId,
        orElse: () => <String, dynamic>{},
      );

      final lineupIds = (matchUser['lp'] as List? ?? [])
          .map((id) => id.toString())
          .toList();

      if (lineupIds.isEmpty) {
        // Kein lp-Eintrag → kompletten aktuellen Kader zurückgeben
        final squadData = await apiClient.getManagerSquad(
          params.leagueId,
          params.userId,
        );
        final players = (squadData['it'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList();
        return players;
      }

      // 2. Aktuellen Kader laden und als Lookup-Map aufbauen (pi = Spieler-ID)
      final squadData = await apiClient.getManagerSquad(
        params.leagueId,
        params.userId,
      );
      final squadPlayers = (squadData['it'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();

      final squadById = <String, Map<String, dynamic>>{
        for (final p in squadPlayers)
          (p['pi'] ?? p['i'] ?? p['id'])?.toString() ?? '': p,
      };
      squadById.remove(''); // leere Keys entfernen

      // 3. Für jeden lp-Eintrag Spielerdaten ermitteln
      final result = <Map<String, dynamic>>[];

      for (final id in lineupIds) {
        if (squadById.containsKey(id)) {
          // Im aktuellen Kader gefunden
          result.add(squadById[id]!);
        } else {
          // Nicht im aktuellen Kader → Fallback auf Player-Details-Endpunkt
          // (analog zu loadPlayersForLineup in der Swift-App)
          try {
            final details = await apiClient.getPlayerDetails(
              params.leagueId,
              id,
            );
            // Details normalisieren: id sicherstellen
            result.add({...details, 'id': id, 'pi': id});
          } catch (_) {
            // Spieler konnte nirgends gefunden werden → Platzhalter
            result.add({'pi': id, 'id': id, 'pn': 'Unbekannt ($id)'});
          }
        }
      }

      return result;
    });
