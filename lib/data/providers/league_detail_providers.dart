import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'kickbase_api_provider.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

// ============================================================================
// LEAGUE DETAIL PROVIDERS - Schritt 5
// ============================================================================

/// League Me Provider
/// GET /v4/leagues/{leagueId}/me
/// Returns own stats in the league
final leagueMeProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getLeagueMe(leagueId);
});

/// My Budget Provider
/// GET /v4/leagues/{leagueId}/me/budget
/// Returns current budget in the league
final myBudgetProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getMyBudget(leagueId);
});

/// My Squad Provider
/// GET /v4/leagues/{leagueId}/squad
/// Returns own squad (players)
final mySquadProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  leagueId,
) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getMySquad(leagueId);
});

/// League Ranking Provider
/// GET /v4/leagues/{leagueId}/ranking
/// Returns league ranking, optionally for a specific matchday
final leagueRankingProvider =
    FutureProvider.family<
      Map<String, dynamic>,
      ({String leagueId, int? matchDay})
    >((ref, params) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getLeagueRanking(
        params.leagueId,
        matchDay: params.matchDay,
      );
    });

/// Convenience provider for current matchday ranking
final currentLeagueRankingProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, leagueId) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);
      return await apiClient.getLeagueRanking(leagueId);
    });

// ============================================================================
// SPIELTAGS-DATEN (Ranking pro Spieltag)
// ============================================================================

/// Spieltags-Ergebnis eines Managers (aus dem Ranking pro Spieltag).
class ManagerMatchday {
  const ManagerMatchday({required this.points, this.lineup = const {}});

  /// Spieltagspunkte des Managers (Feld `mdp`).
  final int points;

  /// Spieler-IDs der Startelf an diesem Spieltag (Feld `lp`).
  final Set<String> lineup;
}

/// Spieltags-Daten einer Liga: pro Spieltag Punkte + Startelf jedes Managers.
class LeagueMatchdayData {
  const LeagueMatchdayData({
    required this.byMatchday,
    required this.seasonPoints,
    required this.teamValues,
    required this.lastFinishedMatchday,
  });

  /// Spieltag → Manager-ID → Punkte + Startelf.
  final Map<int, Map<String, ManagerMatchday>> byMatchday;

  /// Manager-ID → Saisonpunkte (Feld `sp` des aktuellen Rankings).
  final Map<String, int> seasonPoints;

  /// Manager-ID → Teamwert (Feld `tv` des aktuellen Rankings).
  final Map<String, int> teamValues;

  /// Letzter abgeschlossener Spieltag (Feld `lfmd` des aktuellen Rankings).
  final int lastFinishedMatchday;
}

/// Lädt die Startelfen (`lp`) und Spieltagspunkte (`mdp`) aller Manager für
/// jeden abgeschlossenen Spieltag der aktuellen Saison.
///
/// Grundlage ist der Ranking-Endpoint (`?dayNumber=X`) – dieselbe
/// Datenquelle des Tabellen-Tabs. Damit lassen sich Kader-Besitz und
/// Erfolgs-Boni (Spieltagssieger, Spieltagspunkte) pro Spieltag
/// rekonstruieren.
final leagueMatchdayDataProvider =
    FutureProvider.family<LeagueMatchdayData, String>((ref, leagueId) async {
      final apiClient = ref.watch(kickbaseApiClientProvider);

      // Aktuelle Ranking-Response: `lfmd` = letzter abgeschlossener Spieltag,
      // `day` = aktueller Spieltag (Feld der Tabellen-Seite),
      // `us[].sp` = Saisonpunkte.
      final current = await apiClient.getLeagueRanking(leagueId);
      final lastFinished = _asInt(current['lfmd']);
      final currentDay = _asInt(current['day']);
      // Fallback auf `day`, falls `lfmd` fehlt oder 0 ist – sonst würden alle
      // Spieltage übersprungen und die Erfolgs-Ableitung käme überall auf 0.
      final lastDay = lastFinished > 0 ? lastFinished : currentDay;
      final seasonPoints = <String, int>{};
      final teamValues = <String, int>{};
      for (final user
          in (current['us'] as List? ?? []).whereType<Map<String, dynamic>>()) {
        final userId = user['i']?.toString() ?? '';
        if (userId.isNotEmpty) seasonPoints[userId] = _asInt(user['sp']);
        if (userId.isNotEmpty) teamValues[userId] = _asInt(user['tv']);
      }

      final byMatchday = <int, Map<String, ManagerMatchday>>{};
      if (lastDay > 0) {
        const maxConcurrent = 8;
        final days = List<int>.generate(lastDay, (i) => i + 1);
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
            final byUser = <String, ManagerMatchday>{};
            for (final user
                in (ranking['us'] as List? ?? [])
                    .whereType<Map<String, dynamic>>()) {
              final userId = user['i']?.toString() ?? '';
              if (userId.isEmpty) continue;
              final lineup = (user['lp'] as List? ?? [])
                  .map((id) => id.toString())
                  .toSet();
              byUser[userId] = ManagerMatchday(
                points: _asInt(user['mdp']),
                lineup: lineup,
              );
            }
            if (byUser.isNotEmpty) byMatchday[entry.key] = byUser;
          }
        }
      }

      _logger.i(
        '📊 Spieltags-Daten (Liga $leagueId): lfmd=$lastFinished, '
        'day=$currentDay → $lastDay Spieltage, ${byMatchday.length} geladen, '
        '${seasonPoints.length} Manager',
      );
      if (lastDay <= 0) {
        _logger.w(
          '⚠️ Spieltags-Daten (Liga $leagueId): weder lfmd ($lastFinished) '
          'noch day ($currentDay) gesetzt – keine Spieltage geladen',
        );
      }

      return LeagueMatchdayData(
        byMatchday: byMatchday,
        seasonPoints: seasonPoints,
        teamValues: teamValues,
        lastFinishedMatchday: lastDay,
      );
    });

int _asInt(Object? value) => switch (value) {
  int value => value,
  num value => value.toInt(),
  String value => int.tryParse(value) ?? 0,
  _ => 0,
};
