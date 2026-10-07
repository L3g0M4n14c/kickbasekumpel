import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/achievement_model.dart';
import '../services/achievement_budget_service.dart';
import 'kickbase_api_provider.dart';
import 'squad_benchmark_providers.dart' show myLeagueUserIdProvider;

// ============================================================================
// ACHIEVEMENT PROVIDERS
// ============================================================================

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

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
final myLeagueAchievementsProvider = FutureProvider.family<
    List<KickbaseAchievement>, String>((ref, leagueId) async {
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
        // Ohne Detail bleibt der Katalog-Fallback über den Namen aktiv.
        return a;
      }
    }),
  );

  return enriched;
});

/// Belohnung pro Erfolgs-Typ-ID in der Liga (aus der eigenen Achievements-
/// Liste; die Belohnungen sind ligaweit identisch).
final achievementRewardByTypeProvider =
    FutureProvider.family<Map<String, int>, String>((ref, leagueId) async {
  final achievements = await ref.watch(myLeagueAchievementsProvider(leagueId).future);
  return {
    for (final a in achievements)
      if (a.earnedReward > 0) a.typeId: a.earnedReward,
  };
});

/// Lädt den Aktivitäten-Feed einer Liga (max. 5000 Einträge).
final leagueActivitiesFeedProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, leagueId) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return apiClient.getLeagueActivitiesFeed(leagueId);
});

/// Budget-Einnahmen durch Erfolge, aufgeteilt pro Manager.
///
/// - Der eigene Manager (ID via [myLeagueUserIdProvider]) bekommt die
///   EXAKTE Summe aus der eigenen Achievements-Liste (`ac × er`).
/// - Fremd-Manager werden über die ligaweiten Feed-Ereignisse
///   (`activitiesFeed`, Einträge `t == 26`) attribuiert.
///
/// Returns: `Map<managerId, AchievementIncomeSummary>`. Unattribuierte
/// Feed-Einträge sind NICHT in den Summen enthalten.
final leagueAchievementIncomeByManagerProvider =
    FutureProvider.family<Map<String, AchievementIncomeSummary>, String>((
  ref,
  leagueId,
) async {
  final service = ref.watch(achievementBudgetServiceProvider);

  // 1. Belohnungen pro Typ laden (aus eigener Achievements-Liste).
  Map<String, int> rewardByType;
  try {
    rewardByType = await ref.watch(
      achievementRewardByTypeProvider(leagueId).future,
    );
  } catch (e) {
    _logger.w('⚠️ Achievements: Belohnungen nicht ladbar: $e');
    return {};
  }

  // 2. Feed-Ereignisse laden und ligaweit attribuieren.
  var incomeByManager = <String, AchievementIncomeSummary>{};
  try {
    final feed = await ref.watch(leagueActivitiesFeedProvider(leagueId).future);
    final events = service.parseFeedEvents(feed);
    incomeByManager = service.attributeFeedIncome(
      events: events,
      rewardByType: rewardByType,
    );
  } catch (e) {
    _logger.w('⚠️ Achievements: Feed nicht ladbar: $e');
  }

  // 3. Eigenen Manager exakt überschreiben (ac × er aus der eigenen Liste).
  try {
    final myUserId = await ref.watch(myLeagueUserIdProvider(leagueId).future);
    if (myUserId.isNotEmpty) {
      final achievements = await ref.watch(
        myLeagueAchievementsProvider(leagueId).future,
      );
      final exact = service.exactOwnIncome(achievements);
      if (exact.totalIncome > 0) {
        incomeByManager[myUserId] = exact.copyWith(managerId: myUserId);
      }
    }
  } catch (e) {
    _logger.w('⚠️ Achievements: Exakte eigene Summe nicht ladbar: $e');
  }

  return incomeByManager;
});
