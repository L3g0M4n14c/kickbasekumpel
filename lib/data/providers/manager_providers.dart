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

/// Manager Squad (angereichert mit vollständigen Namen)
///
/// Der Squad-Endpunkt liefert bei Spielern nur den Nachnamen (`n`) und
/// kein `fn` (Vorname). Dieser Provider lädt für Spieler ohne Vorname
/// die vollständigen Daten parallel via Player-Details-Endpunkt nach,
/// damit der Ligainsider-Foto-Lookup (`fn + ln`) funktioniert.
final managerSquadEnrichedProvider =
    FutureProvider.family<
      List<Map<String, dynamic>>,
      ({String leagueId, String userId})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final squadData = await apiClient.getManagerSquad(
        params.leagueId,
        params.userId,
      );
      final players = (squadData['it'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();

      final enriched = await Future.wait(
        players.map((p) async {
          final fn = (p['fn'] ?? '').toString().trim();
          if (fn.isNotEmpty) return p;
          final id = (p['pi'] ?? p['i'] ?? p['id'])?.toString().trim() ?? '';
          if (id.isEmpty) return p;
          try {
            final details = await apiClient.getPlayerDetails(
              params.leagueId,
              id,
            );
            return <String, dynamic>{
              ...p,
              'fn': details['fn'] ?? '',
              'ln': details['ln'] ?? p['n'] ?? '',
            };
          } catch (_) {
            return p;
          }
        }),
      );

      return enriched;
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

/// Manager Lineup Enriched Provider (für Spieltag-Ansicht)
///
/// Erweitert [managerLineupPlayersProvider] um:
/// 1. Vollständige Spielernamen (`fn` + `ln`) für Kader-Spieler ohne Vornamen
/// 2. Spieltag-spezifische Punkte (`matchDayPoints`) via Player-Stats-Endpunkt
///
/// Das Ergebnis ist eine Liste von Spieler-Maps mit dem zusätzlichen Key
/// `matchDayPoints` (int), der die Punkte des Spielers an diesem Spieltag enthält.
final managerLineupEnrichedProvider =
    FutureProvider.family<
      List<Map<String, dynamic>>,
      ({String leagueId, String userId, int matchDay})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);

      // 1. Basis-Lineup laden (inkl. Fallback auf Player-Details für nicht mehr
      //    im Kader befindliche Spieler)
      final players = await ref.watch(
        managerLineupPlayersProvider(params).future,
      );

      // 2. Namen & Spieltag-Punkte für alle Spieler parallel anreichern
      final enriched = await Future.wait(
        players.map((p) async {
          final id = (p['pi'] ?? p['i'] ?? p['id'])?.toString().trim() ?? '';

          // Namen-Anreicherung: fn fehlt → Player-Details nachladen
          Map<String, dynamic> enrichedPlayer = p;
          final fn = (p['fn'] ?? '').toString().trim();
          if (fn.isEmpty && id.isNotEmpty) {
            try {
              final details = await apiClient.getPlayerDetails(
                params.leagueId,
                id,
              );
              enrichedPlayer = {
                ...p,
                'fn': details['fn'] ?? '',
                'ln': details['ln'] ?? p['n'] ?? '',
              };
            } catch (_) {
              // Vorname bleibt leer, Foto-Lookup läuft trotzdem per Nachname
            }
          }

          // Spieltag-Punkte über Performance-Endpunkt laden
          int matchDayPoints = 0;
          if (id.isNotEmpty) {
            try {
              final stats = await apiClient.getPlayerStats(params.leagueId, id);
              // Aktuelle Saison ermitteln: neueste Saison mit cur==true-Spieltag,
              // Fallback auf die letzte Saison in der Liste (= neueste).
              final currentSeason = stats.it.reversed.firstWhere(
                (s) => s.ph.any((m) => m.cur),
                orElse: () => stats.it.last,
              );
              final match = currentSeason.ph
                  .where((m) => m.day == params.matchDay)
                  .firstOrNull;
              matchDayPoints = match?.p ?? 0;
            } catch (_) {
              // Punkte bleiben 0
            }
          }

          return {...enrichedPlayer, 'matchDayPoints': matchDayPoints};
        }),
      );

      return enriched;
    });
