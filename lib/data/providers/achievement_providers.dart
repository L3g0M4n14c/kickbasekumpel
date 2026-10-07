import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/achievement_model.dart';
import '../services/achievement_budget_service.dart';
import '../services/achievement_derivation_service.dart';
import 'budget_calculation_providers.dart' show leagueSeasonStartDateProvider;
import 'kickbase_api_provider.dart';
import 'league_detail_providers.dart';
import 'manager_providers.dart';
import 'player_detail_providers.dart';
import 'squad_benchmark_providers.dart' show myLeagueUserIdProvider;

// ============================================================================
// ACHIEVEMENT PROVIDERS
// ============================================================================

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// Maximale Anzahl paralleler Spieler-Requests (Performance-Daten).
const _maxConcurrentFetches = 8;

/// Anzahl Spieltage der Bundesliga – Heuristik für „Saison beendet".
const _bundesligaMatchdays = 34;

/// Service Provider für die Achievements-Budget-Ermittlung
final achievementBudgetServiceProvider = Provider<AchievementBudgetService>(
  (ref) => AchievementBudgetService(),
);

/// Lädt die eigenen Achievements einer Liga inkl. Belohnung (`er`).
///
/// Strategie: Erst die Liste (`/user/achievements`), dann für jeden
/// nicht-leeren Eintrag den Detail-Endpoint (`/user/achievements/{type}`),
/// um `er` (Geld-Belohnung) zu bekommen. Detail-Fehler pro Erfolg werden
/// abgefangen.
final myLeagueAchievementsProvider =
    FutureProvider.family<List<KickbaseAchievement>, String>((
      ref,
      leagueId,
    ) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      final service = ref.watch(achievementBudgetServiceProvider);

      final rawItems = await apiClient.getUserAchievements(leagueId);
      final achievements = service.parseAchievements(rawItems);

      // Details (er, d, dt) parallel nachladen – nur für Einträge mit ac > 0,
      // da nur diese Budget-Einnahmen erzeugen.
      final enriched = await Future.wait(
        achievements.map((a) async {
          if (a.achievedCount <= 0) return a;
          try {
            final detail = await apiClient.getUserAchievementByType(
              leagueId,
              a.typeId,
            );
            return service.mergeAchievementDetail(a, detail);
          } catch (_) {
            // Detail nicht ladbar → Katalog-Fallback über den Namen. Damit
            // bedeutet er = 0 eindeutig „Boni deaktiviert" (API-Aussage) und
            // nicht „Detail-Request fehlgeschlagen".
            return a.copyWith(earnedReward: service.catalogReward(a.name));
          }
        }),
      );

      // Katalog-Dump: alle Erfolgs-Typen der Liga – Ground Truth für die
      // Namens-/Schwellen-Zuordnung von Ableitung und Kalibrierung.
      for (final a in enriched) {
        _logger.i(
          '🏅 Erfolg: "${a.name}" (t=${a.typeId}, ac=${a.achievedCount}, '
          'ise=${a.isOneTime}, er=${a.earnedReward}, dt=${a.earnedAt ?? '-'})'
          '${(a.description?.isNotEmpty ?? false) ? ' – ${a.description}' : ''}',
        );
      }

      return enriched;
    });

/// Belohnung (`er`) pro Erfolgs-Name aus der eigenen Achievements-Liste.
///
/// Nur Einträge mit `ac > 0` (bei denen der Detail-Endpoint `er` liefert) sind
/// enthalten. Ein Wert von 0 bedeutet: Erfolgs-Geldboni in der Liga
/// deaktiviert – [AchievementDerivationService] zahlt dann durchgehend 0.
final achievementApiRewardsByNameProvider =
    FutureProvider.family<Map<String, int>, String>((ref, leagueId) async {
      final achievements = await ref.watch(
        myLeagueAchievementsProvider(leagueId).future,
      );
      return {
        for (final a in achievements)
          if (a.achievedCount > 0 && a.name.isNotEmpty) a.name: a.earnedReward,
      };
    });

/// Abgeleitete Erfolgs-Ereignisse ALLER Manager einer Liga.
///
/// Da die API Erfolge fremder Manager nicht zeigt (der Aktivitäten-Feed
/// enthält laut Live-Verifikation nur die eigenen), werden sie deterministisch
/// aus ligaweit verfügbaren Daten rekonstruiert (siehe
/// [AchievementDerivationService]):
///
/// - Spieltagssieger + Spieltagspunkte-Boni aus dem Spieltags-Ranking
/// - Topscorer/Matchwinner/Weltklasse/Fussballgott + MVP aus Lineup-Punkten
/// - Meister/Vizemeister aus der Endtabelle (nur nach Saisonende)
///
/// Händchen/Königstransfer fehlen hier (benötigen die Transfer-Historie des
/// jeweiligen Managers) – sie werden in `managerAchievementIncomeProvider`
/// ergänzt.
///
/// Returns: `Map<managerId, List<AchievementEvent>>`.
final leagueDerivedAchievementEventsProvider =
    FutureProvider.family<Map<String, List<AchievementEvent>>, String>((
      ref,
      leagueId,
    ) async {
      // 1. Belohnungen (er = 0 → Boni deaktiviert).
      var apiRewards = const <String, int>{};
      try {
        apiRewards = await ref.watch(
          achievementApiRewardsByNameProvider(leagueId).future,
        );
      } catch (e) {
        _logger.w('⚠️ Achievements: Belohnungen nicht ladbar: $e');
      }
      final derivation = AchievementDerivationService(
        apiRewardsByName: apiRewards,
      );

      // 2. Spieltags-Punkte + Startelfen aller Manager.
      final data = await ref.watch(leagueMatchdayDataProvider(leagueId).future);
      final pointsByMatchday = <int, Map<String, int>>{
        for (final entry in data.byMatchday.entries)
          entry.key: {
            for (final manager in entry.value.entries)
              manager.key: manager.value.points,
          },
      };
      // 2b. Punkte-Primärquelle: managers/{id}/performance (Felder `day`/
      // `mdp` – dieselben, die der Manager-Detail-Screen anzeigt). Der
      // Ranking-Wert oben bleibt als Lücken-Füller erhalten.
      final managerIds = {
        ...data.seasonPoints.keys,
        for (final byManager in pointsByMatchday.values) ...byManager.keys,
      }.toList();
      for (var i = 0; i < managerIds.length; i += _maxConcurrentFetches) {
        final batch = managerIds.skip(i).take(_maxConcurrentFetches);
        await Future.wait(
          batch.map((managerId) async {
            try {
              final performance = await ref.watch(
                managerPerformanceProvider((
                  leagueId: leagueId,
                  userId: managerId,
                )).future,
              );
              final seasons = (performance['it'] as List? ?? [])
                  .whereType<Map<String, dynamic>>()
                  .toList();
              if (seasons.isEmpty) return;
              final currentSeason = seasons.reversed.firstWhere(
                (s) => ((s['it'] as List?) ?? []).any(
                  (d) => d is Map && d['cur'] == true,
                ),
                orElse: () => seasons.last,
              );
              for (final day
                  in (currentSeason['it'] as List? ?? [])
                      .whereType<Map<String, dynamic>>()) {
                final dayNumber = _asInt(day['day']);
                final mdp = _asInt(day['mdp']);
                if (dayNumber > 0 && mdp > 0) {
                  pointsByMatchday.putIfAbsent(dayNumber, () => {})[managerId] =
                      mdp;
                }
              }
            } catch (_) {
              // Ohne Performance-Daten bleibt der Ranking-Wert erhalten.
            }
          }),
        );
      }

      final lineupsByMatchday = <int, Map<String, Set<String>>>{
        for (final entry in data.byMatchday.entries)
          entry.key: {
            for (final manager in entry.value.entries)
              if (manager.value.lineup.isNotEmpty)
                manager.key: manager.value.lineup,
          },
      };

      // 3. Spieler-Punkte pro Spieltag (ein gecachter Request pro Lineup-Spieler).
      final playerIds = <String>{
        for (final byManager in lineupsByMatchday.values)
          for (final lineup in byManager.values) ...lineup,
      };
      final playerPointsByMatchday = <String, Map<int, int>>{};
      final ids = playerIds.toList();
      for (var i = 0; i < ids.length; i += _maxConcurrentFetches) {
        final batch = ids.skip(i).take(_maxConcurrentFetches);
        await Future.wait(
          batch.map((playerId) async {
            try {
              final stats = await ref.watch(
                playerPerformanceProvider((
                  leagueId: leagueId,
                  playerId: playerId,
                )).future,
              );
              if (stats.it.isEmpty) return;
              final currentSeason = stats.it.reversed.firstWhere(
                (s) => s.ph.any((m) => m.cur),
                orElse: () => stats.it.last,
              );
              final points = <int, int>{
                for (final m in currentSeason.ph)
                  if ((m.p ?? 0) > 0) m.day: m.p!,
              };
              if (points.isNotEmpty) playerPointsByMatchday[playerId] = points;
            } catch (_) {
              // Spieler ohne Performance-Daten zählen für keine Boni.
            }
          }),
        );
      }

      // 4. Ableiten und zusammenführen.
      final eventsByManager = <String, List<AchievementEvent>>{};
      void merge(Map<String, List<AchievementEvent>> derived) {
        for (final entry in derived.entries) {
          eventsByManager.putIfAbsent(entry.key, () => []).addAll(entry.value);
        }
      }

      merge(
        derivation.deriveMatchdayEvents(pointsByMatchday: pointsByMatchday),
      );
      merge(
        derivation.derivePlayerEvents(
          lineupsByMatchday: lineupsByMatchday,
          playerPointsByMatchday: playerPointsByMatchday,
        ),
      );
      // ponytail: Saisonende = 34. Spieltag (Bundesliga-Heuristik).
      merge(
        derivation.deriveSeasonEvents(
          seasonPointsByManager: data.seasonPoints,
          seasonFinished: data.lastFinishedMatchday >= _bundesligaMatchdays,
        ),
      );
      merge(
        derivation.deriveSeasonPointEvents(
          seasonPointsByManager: data.seasonPoints,
        ),
      );
      merge(
        derivation.deriveTeamValueEvents(teamValuesByManager: data.teamValues),
      );

      _logger.i(
        '📊 Erfolgs-Ableitung (Liga $leagueId): ${pointsByMatchday.length} '
        'Spieltage, ${playerPointsByMatchday.length} Spieler mit Punkten, '
        '${eventsByManager.length} Manager mit Ereignissen',
      );

      // 5. Kalibrierung gegen die eigenen exakten Werte (nur Logging).
      //    `ac` ist eine Karriere-Summe → Schrankenvergleich: Minimum aus
      //    `dt` (in dieser Saison erreicht), Maximum = `ac`.
      try {
        final myUserId = await ref.watch(
          myLeagueUserIdProvider(leagueId).future,
        );
        final myAchievements = await ref.watch(
          myLeagueAchievementsProvider(leagueId).future,
        );
        final seasonStart = await ref.watch(
          leagueSeasonStartDateProvider(leagueId).future,
        );
        final achieved = myAchievements
            .where((a) => a.achievedCount > 0 && a.name.isNotEmpty)
            .toList();
        final myEvents = eventsByManager[myUserId] ?? [];
        final mismatches = derivation.calibrate(
          derivedEvents: myEvents,
          // Alle API-Typen (auch ac = 0) – damit ist „mehr abgeleitet als
          // vorhanden" als Überzählen erkennbar.
          actualCountsByName: {
            for (final a in myAchievements)
              if (a.name.isNotEmpty) a.name: a.achievedCount,
          },
          minExpectedByName: derivation.minExpectedInSeason(
            earnedAtByName: {for (final a in achieved) a.name: a.earnedAt},
            seasonStart: seasonStart,
          ),
        );
        // Abgeleitete Namen ohne API-Pendant → Übersetzungs-Lücke.
        final apiNameSet = {for (final a in myAchievements) a.name};
        final unknownNames = myEvents
            .map((e) => e.name)
            .where((name) => !apiNameSet.contains(name))
            .toSet();
        if (unknownNames.isNotEmpty) {
          _logger.w(
            '🧭 Event-Namen ohne API-Pendant (Übersetzung prüfen): '
            '$unknownNames',
          );
        }
        _logger.i(
          '🧭 Achievement-Kalibrierung (Liga $leagueId, User $myUserId): '
          '${(eventsByManager[myUserId] ?? []).length} abgeleitete Ereignisse',
        );
        if (mismatches.isNotEmpty) {
          _logger.w('🧭 Kalibrierung: ${mismatches.join(', ')}');
        } else {
          _logger.i('✅ Achievement-Kalibrierung: im Rahmen der Schranken');
        }
      } catch (e) {
        _logger.i('Achievement-Kalibrierung übersprungen: $e');
      }

      return eventsByManager;
    });

/// Hilfsfunktion: Konvertiere Wert in int
int _asInt(Object? value) => switch (value) {
  int value => value,
  num value => value.toInt(),
  String value => int.tryParse(value) ?? 0,
  _ => 0,
};
