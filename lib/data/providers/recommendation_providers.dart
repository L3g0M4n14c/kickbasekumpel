import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transfer_model.dart';
import '../models/player_model.dart';
import '../models/market_value_model.dart';
import '../models/performance_model.dart';
import '../models/ligainsider_model.dart';
import '../models/lineup_model.dart';
import '../services/mistral_recommendation_service.dart';
import '../../domain/repositories/repository_interfaces.dart';
import 'repository_providers.dart';
import 'league_providers.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// RECOMMENDATION STREAM PROVIDERS
// ============================================================================

/// All Recommendations Stream Provider
/// Provides real-time updates of all recommendations
/// Warning: Can be large dataset, prefer filtered versions
final allRecommendationsStreamProvider = StreamProvider<List<Recommendation>>((
  ref,
) async* {
  final recommendationRepo = ref.watch(recommendationRepositoryProvider);

  await for (final result in recommendationRepo.watchAll()) {
    if (result is Success<List<Recommendation>>) {
      yield result.data;
    } else if (result is Failure<List<Recommendation>>) {
      throw Exception((result).message);
    }
  }
});

// ============================================================================
// LEAGUE RECOMMENDATION PROVIDERS
// ============================================================================

/// Recommendations Provider Family
/// Provides real-time updates of recommendations for a specific league
final recommendationsProvider =
    StreamProvider.family<List<Recommendation>, String>((ref, leagueId) async* {
      final recommendationRepo = ref.watch(recommendationRepositoryProvider);

      // Get all recommendations and filter by league
      await for (final result in recommendationRepo.watchAll()) {
        if (result is Success<List<Recommendation>>) {
          final filtered = result.data
              .where((r) => r.leagueId == leagueId)
              .toList();
          yield filtered;
        } else if (result is Failure<List<Recommendation>>) {
          throw Exception((result).message);
        }
      }
    });

/// Recommendations Provider (Future version)
/// Fetches recommendations for a specific league once
final recommendationsFutureProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, leagueId) async {
      final recommendationRepo = ref.watch(recommendationRepositoryProvider);
      final result = await recommendationRepo.getAll();

      if (result is Success<List<Recommendation>>) {
        return result.data.where((r) => r.leagueId == leagueId).toList();
      } else if (result is Failure<List<Recommendation>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching recommendations');
    });

/// Selected League Recommendations Provider
/// Automatically fetches recommendations for currently selected league
final selectedLeagueRecommendationsProvider =
    StreamProvider<List<Recommendation>>((ref) async* {
      final leagueId = ref.watch(selectedLeagueIdProvider);

      if (leagueId == null) {
        yield [];
        return;
      }

      final recommendationRepo = ref.watch(recommendationRepositoryProvider);
      final result = await recommendationRepo.getAll();

      if (result is Success<List<Recommendation>>) {
        final filtered = result.data
            .where((r) => r.leagueId == leagueId)
            .toList();
        yield filtered;
      } else if (result is Failure<List<Recommendation>>) {
        throw Exception((result).message);
      }
    });

// ============================================================================
// TOP RECOMMENDATIONS PROVIDERS
// ============================================================================

/// Top Recommendations Parameters
class TopRecommendationsParams {
  final String leagueId;
  final int limit;
  final String? category;

  const TopRecommendationsParams({
    required this.leagueId,
    this.limit = 10,
    this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopRecommendationsParams &&
          runtimeType == other.runtimeType &&
          leagueId == other.leagueId &&
          limit == other.limit &&
          category == other.category;

  @override
  int get hashCode => leagueId.hashCode ^ limit.hashCode ^ category.hashCode;
}

/// Top Recommendations Provider Family
/// Fetches top-scoring recommendations for a league
final topRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, TopRecommendationsParams>((
      ref,
      params,
    ) async {
      final recommendationRepo = ref.watch(recommendationRepositoryProvider);
      final result = await recommendationRepo.getTopRecommendations(
        leagueId: params.leagueId,
        limit: params.limit,
        category: params.category,
      );

      if (result is Success<List<Recommendation>>) {
        return result.data;
      } else if (result is Failure<List<Recommendation>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching top recommendations');
    });

/// Top Selected League Recommendations Provider
/// Fetches top recommendations for currently selected league
final topSelectedLeagueRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, int>((ref, limit) async {
      final leagueId = ref.watch(selectedLeagueIdProvider);

      if (leagueId == null) {
        return [];
      }

      final params = TopRecommendationsParams(leagueId: leagueId, limit: limit);
      return ref.watch(topRecommendationsProvider(params).future);
    });

// ============================================================================
// RECOMMENDATION BY ID PROVIDERS
// ============================================================================

/// Recommendation Details Provider Family
/// Fetches specific recommendation by ID
final recommendationDetailsProvider =
    FutureProvider.family<Recommendation, String>((
      ref,
      recommendationId,
    ) async {
      final recommendationRepo = ref.watch(recommendationRepositoryProvider);
      final result = await recommendationRepo.getById(recommendationId);

      if (result is Success<Recommendation>) {
        return result.data;
      } else if (result is Failure<Recommendation>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching recommendation');
    });

/// Recommendation Details Stream Provider Family
/// Provides real-time updates for a specific recommendation
final recommendationDetailsStreamProvider =
    StreamProvider.family<Recommendation, String>((
      ref,
      recommendationId,
    ) async* {
      final recommendationRepo = ref.watch(recommendationRepositoryProvider);

      await for (final result in recommendationRepo.watchById(
        recommendationId,
      )) {
        if (result is Success<Recommendation>) {
          yield result.data;
        } else if (result is Failure<Recommendation>) {
          throw Exception((result).message);
        }
      }
    });

// ============================================================================
// FILTERED RECOMMENDATIONS PROVIDERS
// ============================================================================

/// Buy Recommendations Provider
/// Filters recommendations by 'buy' action
final buyRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, leagueId) async {
      final recommendations = await ref.watch(
        recommendationsFutureProvider(leagueId).future,
      );

      return recommendations
          .where((r) => r.action == 'buy' || r.action == 'strong-buy')
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    });

/// Sell Recommendations Provider
/// Filters recommendations by 'sell' action
final sellRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, leagueId) async {
      final recommendations = await ref.watch(
        recommendationsFutureProvider(leagueId).future,
      );

      return recommendations
          .where((r) => r.action == 'sell' || r.action == 'strong-sell')
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    });

/// High Confidence Recommendations Provider
/// Filters recommendations by confidence threshold
final highConfidenceRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, leagueId) async {
      final recommendations = await ref.watch(
        recommendationsFutureProvider(leagueId).future,
      );

      return recommendations.where((r) => r.confidence >= 0.7).toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));
    });

/// Recommendations by Category Provider
class RecommendationsByCategoryParams {
  final String leagueId;
  final String category;

  const RecommendationsByCategoryParams({
    required this.leagueId,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationsByCategoryParams &&
          runtimeType == other.runtimeType &&
          leagueId == other.leagueId &&
          category == other.category;

  @override
  int get hashCode => leagueId.hashCode ^ category.hashCode;
}

final recommendationsByCategoryProvider =
    FutureProvider.family<
      List<Recommendation>,
      RecommendationsByCategoryParams
    >((ref, params) async {
      final recommendations = await ref.watch(
        recommendationsFutureProvider(params.leagueId).future,
      );

      return recommendations
          .where((r) => r.category == params.category)
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    });

// ============================================================================
// RECOMMENDATION STATISTICS PROVIDERS
// ============================================================================

/// Recommendation Statistics Provider Family
/// Fetches statistics for recommendations in a league
final recommendationStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, leagueId) async {
      final recommendationRepo = ref.watch(recommendationRepositoryProvider);
      final result = await recommendationRepo.getRecommendationStats(leagueId);

      if (result is Success<Map<String, dynamic>>) {
        return result.data;
      } else if (result is Failure<Map<String, dynamic>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching recommendation stats');
    });

/// Selected League Recommendation Statistics Provider
/// Fetches statistics for currently selected league
final selectedLeagueRecommendationStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
      final leagueId = ref.watch(selectedLeagueIdProvider);

      if (leagueId == null) {
        return {};
      }

      return ref.watch(recommendationStatsProvider(leagueId).future);
    });

// ============================================================================
// COMPUTED PROVIDERS
// ============================================================================

/// Recommendations Count Provider
/// Counts total recommendations for selected league
final recommendationsCountProvider = Provider<int>((ref) {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return 0;

  final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));
  return recommendationsAsync.when(
    data: (recommendations) => recommendations.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Average Recommendation Score Provider
/// Calculates average score for selected league recommendations
final averageRecommendationScoreProvider = Provider<double>((ref) {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return 0.0;

  final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));
  return recommendationsAsync.when(
    data: (recommendations) {
      if (recommendations.isEmpty) return 0.0;
      final total = recommendations.fold<double>(
        0.0,
        (sum, r) => sum + r.score,
      );
      return total / recommendations.length;
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

/// Best Recommendation Provider
/// Returns highest scoring recommendation for selected league
final bestRecommendationProvider = Provider<Recommendation?>((ref) {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return null;

  final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));
  return recommendationsAsync.when(
    data: (recommendations) {
      if (recommendations.isEmpty) return null;
      return recommendations.reduce(
        (best, current) => current.score > best.score ? current : best,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Recommendations by Action Count Provider
/// Counts recommendations grouped by action
final recommendationsByActionCountProvider = Provider<Map<String, int>>((ref) {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return {};

  final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));
  return recommendationsAsync.when(
    data: (recommendations) {
      final counts = <String, int>{};
      for (var rec in recommendations) {
        counts[rec.action] = (counts[rec.action] ?? 0) + 1;
      }
      return counts;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

// ============================================================================
// KI-EMPFEHLUNGEN GENERIEREN (Gemini / Firebase Vertex AI)
// ============================================================================

/// Zustand des AI-Generierungs-Notifiers
class GenerateAIRecommendationsState {
  /// Ob gerade ein Generierungsvorgang läuft
  final bool isGenerating;

  /// Anzahl bereits generierter Empfehlungen im aktuellen Durchlauf
  final int generatedCount;

  /// Gesamtanzahl der zu analysierenden Spieler
  final int totalCount;

  /// Fehlermeldung (null wenn kein Fehler)
  final String? errorMessage;

  /// Ob der letzte Vorgang erfolgreich war
  final bool? lastRunSucceeded;

  /// Die generierten Empfehlungen für die aktuelle Liga
  final List<Recommendation> recommendations;

  /// Die League-ID für die die aktuellen Empfehlungen gelten
  final String? leagueId;

  const GenerateAIRecommendationsState({
    this.isGenerating = false,
    this.generatedCount = 0,
    this.totalCount = 0,
    this.errorMessage,
    this.lastRunSucceeded,
    this.recommendations = const [],
    this.leagueId,
  });

  GenerateAIRecommendationsState copyWith({
    bool? isGenerating,
    int? generatedCount,
    int? totalCount,
    String? errorMessage,
    bool? lastRunSucceeded,
    List<Recommendation>? recommendations,
    String? leagueId,
  }) => GenerateAIRecommendationsState(
    isGenerating: isGenerating ?? this.isGenerating,
    generatedCount: generatedCount ?? this.generatedCount,
    totalCount: totalCount ?? this.totalCount,
    errorMessage: errorMessage,
    lastRunSucceeded: lastRunSucceeded ?? this.lastRunSucceeded,
    recommendations: recommendations ?? this.recommendations,
    leagueId: leagueId ?? this.leagueId,
  );
}

/// Notifier, der KI-Empfehlungen via Mistral generiert und in Firestore schreibt.
///
/// Die bestehenden [recommendationsProvider]-Stream-Provider lesen die Daten
/// automatisch aus Firestore – kein Umbau der UI nötig.
///
/// Verwendung:
/// ```dart
/// // Einzelner Spieler
/// await ref.read(generateAIRecommendationsNotifierProvider(leagueId).notifier)
///     .generateForPlayer(player);
///
/// // Komplette Spielerliste
/// await ref.read(generateAIRecommendationsNotifierProvider.notifier)
///     .generateForPlayers(leagueId, players);
/// ```
class GenerateAIRecommendationsNotifier
    extends Notifier<GenerateAIRecommendationsState> {
  @override
  GenerateAIRecommendationsState build() =>
      const GenerateAIRecommendationsState();

  /// Generiert eine KI-Empfehlung für einen einzelnen Spieler.
  Future<void> generateForPlayer(
    String leagueId,
    Player player, {
    List<MarketValueEntry>? marketValueHistory,
    List<MatchPerformance>? recentPerformances,
    LigainsiderPlayer? ligainsiderData,
  }) async {
    state = state.copyWith(
      isGenerating: true,
      generatedCount: 0,
      totalCount: 1,
      leagueId: leagueId,
      recommendations: [],
    );

    final repo = ref.read(recommendationRepositoryProvider);
    final apiClient = ref.read(kickbaseApiClientProvider);
    final promptContext = await _loadRecommendationPromptContext(
      apiClient,
      leagueId,
    );
    final resolvedPlayer = promptContext.resolvePlayer(player);
    final result = await repo.generateAIRecommendation(
      leagueId: leagueId,
      player: resolvedPlayer,
      marketValueHistory: marketValueHistory,
      recentPerformances: recentPerformances,
      ligainsiderData: ligainsiderData,
      fixtureContext: promptContext.fixtureContextFor(resolvedPlayer),
      lineupContext: promptContext.lineupContextFor(resolvedPlayer),
    );

    if (result is Failure<Recommendation>) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: result.message,
        lastRunSucceeded: false,
      );
      return;
    }

    // Empfehlung direkt im State speichern
    final recommendation = (result as Success<Recommendation>).data;
    state = state.copyWith(
      isGenerating: false,
      generatedCount: 1,
      lastRunSucceeded: true,
      recommendations: [recommendation],
    );
  }

  /// Generiert KI-Empfehlungen für eine Liste von Spielern per Batch-Aufruf.
  ///
  /// Verwendet standardmäßig die bereits geladenen [Player]-Stammdaten.
  /// Optionale Zusatzdaten wie Marktwert-Verläufe oder letzte Performances
  /// werden nur genutzt, wenn sie vom Aufrufer bereits mitgegeben wurden.
  /// Lädt globale Kontextdaten nur einmal und überspringt lokale Shortcut-Fälle.
  Future<void> generateForPlayers(
    String leagueId,
    List<Player> players, {
    Map<String, List<MarketValueEntry>>? marketValueHistories,
    Map<String, List<MatchPerformance>>? recentPerformances,
    Map<String, LigainsiderPlayer>? ligainsiderData,
  }) async {
    if (players.isEmpty) {
      state = state.copyWith(
        isGenerating: false,
        generatedCount: 0,
        totalCount: 0,
        leagueId: leagueId,
        recommendations: const [],
        lastRunSucceeded: true,
        errorMessage: null,
      );
      return;
    }

    state = state.copyWith(
      isGenerating: true,
      generatedCount: 0,
      totalCount: players.length,
      leagueId: leagueId,
      recommendations: [],
      errorMessage: null,
    );

    final repo = ref.read(recommendationRepositoryProvider);
    // Alte Empfehlungen dieser Liga vor dem neuen Lauf löschen
    debugPrint(
      '🗑️ generateForPlayers: Lösche alte Empfehlungen für Liga $leagueId...',
    );
    await repo.deleteByLeague(leagueId);
    debugPrint('✅ generateForPlayers: Alte Empfehlungen gelöscht.');
    final apiClient = ref.read(kickbaseApiClientProvider);
    final promptContext = await _loadRecommendationPromptContext(
      apiClient,
      leagueId,
    );
    final resolvedPlayers = players.map(promptContext.resolvePlayer).toList();

    final localShortcutPlayerIds = resolvedPlayers
        .where(
          (player) => MistralRecommendationService.shouldUseLocalRecommendation(
            player: player,
            ligainsiderData: ligainsiderData?[player.id],
          ),
        )
        .map((player) => player.id)
        .toSet();

    final swapCandidatesByPosition = <int, List<Player>>{};
    for (final candidate in resolvedPlayers) {
      if (candidate.userOwnsPlayer ||
          localShortcutPlayerIds.contains(candidate.id)) {
        continue;
      }
      swapCandidatesByPosition
          .putIfAbsent(candidate.position, () => [])
          .add(candidate);
    }
    for (final candidates in swapCandidatesByPosition.values) {
      candidates.sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
    }

    final playerInputs = <PlayerAnalysisInput>[];

    for (final player in resolvedPlayers) {
      if (!state.isGenerating) break;

      final playerLigainsiderData = ligainsiderData?[player.id];

      List<MarketValueEntry> mvHistory = marketValueHistories?[player.id] ?? [];
      List<MatchPerformance> performances =
          recentPerformances?[player.id] ?? [];
      final nextFixture = promptContext.nextFixtureFor(player);

      // Swap-Kandidaten für eigene Spieler: Top-3 nicht-eigene Alternativen
      // gleicher Position, sortiert nach Durchschnittspunkten
      List<Player>? swapCandidates;
      if (player.userOwnsPlayer) {
        final candidates =
            swapCandidatesByPosition[player.position] ?? const [];
        if (candidates.isNotEmpty) {
          swapCandidates = candidates.take(3).toList();
        }
      }

      playerInputs.add(
        PlayerAnalysisInput(
          player: player,
          marketValueHistory: mvHistory.isNotEmpty ? mvHistory : null,
          recentPerformances: performances.isNotEmpty ? performances : null,
          ligainsiderData: playerLigainsiderData,
          fixtureContext: promptContext.fixtureContextFor(player),
          lineupContext: promptContext.lineupContextFor(player),
          swapCandidates: swapCandidates,
          nextOpponent: nextFixture?.opponentName,
          nextOpponentTablePosition: nextFixture?.opponentTablePosition,
          ownTeamTablePosition:
              nextFixture?.ownTeamTablePosition ??
              promptContext.teamPositionFor(player),
          nextMatchLocation: nextFixture?.matchLocationLabel,
        ),
      );

      state = state.copyWith(generatedCount: playerInputs.length);
    }

    if (!state.isGenerating) {
      return;
    }

    final result = await repo.generateAIBatchRecommendations(
      leagueId: leagueId,
      players: playerInputs,
    );

    if (result is Failure<List<Recommendation>>) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: result.message,
        lastRunSucceeded: false,
      );
      return;
    }

    final newRecommendations = (result as Success<List<Recommendation>>).data;

    state = state.copyWith(
      isGenerating: false,
      generatedCount: newRecommendations.length,
      lastRunSucceeded: newRecommendations.isNotEmpty,
      recommendations: newRecommendations,
      errorMessage: null,
    );
  }

  /// Bricht einen laufenden Generierungsvorgang ab.
  void cancel() {
    state = state.copyWith(isGenerating: false);
  }
}

// =============================================================================
// Hilfsfunktionen (privat, modul-global)
// =============================================================================

/// Schwierigkeitsbewertung eines Gegners anhand seiner Tabellenposition.
String _fixtureDifficulty(int tablePosition) {
  if (tablePosition == 0) return 'Schwierigkeit unbekannt';
  if (tablePosition <= 4) return 'sehr schwer (Top-4-Team)';
  if (tablePosition <= 8) return 'schwer';
  if (tablePosition <= 12) return 'mittel';
  return 'leicht';
}

Future<_RecommendationPromptContext> _loadRecommendationPromptContext(
  dynamic apiClient,
  String leagueId,
) async {
  final globalData = await Future.wait<Object?>([
    _loadTable(apiClient),
    _loadMatchdays(apiClient),
    _loadLineup(apiClient, leagueId),
  ]);
  final tableData = globalData[0]! as Map<String, dynamic>;
  final matchdaysData = globalData[1]! as Map<String, dynamic>;
  final lineupData = globalData[2] as LineupResponse?;

  final teamPositions = <String, int>{};
  final teamNamesByKey = <String, String>{};
  try {
    final tableEntries = (tableData['it'] as List<dynamic>?) ?? [];
    for (final entry in tableEntries) {
      final m = entry as Map<String, dynamic>;
      final teamId = (m['tid'] as String?) ?? '';
      final teamPosition = (m['tp'] as int?) ?? 0;
      final teamName = (m['tn'] as String?) ?? '';
      if (teamId.isNotEmpty) {
        teamNamesByKey[teamId] = teamName;
        if (teamPosition > 0) teamPositions[teamId] = teamPosition;
      }
      if (teamName.isNotEmpty) {
        teamNamesByKey[teamName] = teamName;
        if (teamPosition > 0) teamPositions[teamName] = teamPosition;
      }
    }
  } catch (_) {}

  final nextFixtures = <String, List<String>>{};
  final nextFixtureByKey = <String, _NextFixtureInfo>{};
  try {
    final matchdays = (matchdaysData['it'] as List<dynamic>?) ?? [];
    for (final md in matchdays) {
      final m = md as Map<String, dynamic>;
      final day = (m['day'] as int?) ?? 0;
      final finished = (m['finished'] as bool?) ?? (m['f'] as bool?) ?? false;
      if (finished) continue;
      final matches =
          (m['ms'] as List<dynamic>?) ?? (m['m'] as List<dynamic>?) ?? [];
      for (final match in matches) {
        final mm = match as Map<String, dynamic>;
        final homeTeamId =
            (mm['t1id'] as String?) ?? (mm['t1i'] as String?) ?? '';
        final awayTeamId =
            (mm['t2id'] as String?) ?? (mm['t2i'] as String?) ?? '';
        final homeTeamName =
            (mm['t1n'] as String?) ?? (mm['t1'] as String?) ?? '';
        final awayTeamName =
            (mm['t2n'] as String?) ?? (mm['t2'] as String?) ?? '';

        if (homeTeamId.isNotEmpty && homeTeamName.isNotEmpty) {
          teamNamesByKey[homeTeamId] = homeTeamName;
        }
        if (awayTeamId.isNotEmpty && awayTeamName.isNotEmpty) {
          teamNamesByKey[awayTeamId] = awayTeamName;
        }
        if (homeTeamName.isNotEmpty) {
          teamNamesByKey[homeTeamName] = homeTeamName;
        }
        if (awayTeamName.isNotEmpty) {
          teamNamesByKey[awayTeamName] = awayTeamName;
        }

        final awayPosition =
            teamPositions[awayTeamId] ?? teamPositions[awayTeamName];
        final homePosition =
            teamPositions[homeTeamId] ?? teamPositions[homeTeamName];

        _addNextFixture(
          nextFixtures: nextFixtures,
          nextFixtureByKey: nextFixtureByKey,
          keys: [homeTeamId, homeTeamName],
          summary:
              'Spieltag $day: vs $awayTeamName '
              '(Heimspiel, Platz ${awayPosition ?? 0} – ${_fixtureDifficulty(awayPosition ?? 0)})',
          fixtureInfo: _NextFixtureInfo(
            opponentName: awayTeamName,
            opponentTablePosition: awayPosition,
            ownTeamTablePosition: homePosition,
            isHomeGame: true,
          ),
        );
        _addNextFixture(
          nextFixtures: nextFixtures,
          nextFixtureByKey: nextFixtureByKey,
          keys: [awayTeamId, awayTeamName],
          summary:
              'Spieltag $day: vs $homeTeamName '
              '(Auswärtsspiel, Platz ${homePosition ?? 0} – ${_fixtureDifficulty(homePosition ?? 0)})',
          fixtureInfo: _NextFixtureInfo(
            opponentName: homeTeamName,
            opponentTablePosition: homePosition,
            ownTeamTablePosition: awayPosition,
            isHomeGame: false,
          ),
        );
      }
    }
  } catch (_) {}

  String? lineupSummary;
  if (lineupData != null) {
    final positionCounts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0};
    for (final lp in lineupData.players) {
      if (lp.lineupOrder > 0 && lp.position > 0) {
        positionCounts[lp.position] = (positionCounts[lp.position] ?? 0) + 1;
      }
    }
    lineupSummary =
        'Mein aktuell gesetzter Kader – '
        'TW: ${positionCounts[1]}, '
        'ABW: ${positionCounts[2]}, '
        'MF: ${positionCounts[3]}, '
        'ST: ${positionCounts[4]}';
  }

  return _RecommendationPromptContext(
    teamPositions: teamPositions,
    teamNamesByKey: teamNamesByKey,
    nextFixtures: nextFixtures,
    nextFixtureByKey: nextFixtureByKey,
    lineupSummary: lineupSummary,
  );
}

void _addNextFixture({
  required Map<String, List<String>> nextFixtures,
  required Map<String, _NextFixtureInfo> nextFixtureByKey,
  required List<String> keys,
  required String summary,
  required _NextFixtureInfo fixtureInfo,
}) {
  for (final key in keys) {
    if (key.isEmpty) continue;
    nextFixtures.putIfAbsent(key, () => []);
    if (nextFixtures[key]!.length < 3) {
      nextFixtures[key]!.add(summary);
    }
    nextFixtureByKey.putIfAbsent(key, () => fixtureInfo);
  }
}

class _RecommendationPromptContext {
  final Map<String, int> teamPositions;
  final Map<String, String> teamNamesByKey;
  final Map<String, List<String>> nextFixtures;
  final Map<String, _NextFixtureInfo> nextFixtureByKey;
  final String? lineupSummary;

  const _RecommendationPromptContext({
    required this.teamPositions,
    required this.teamNamesByKey,
    required this.nextFixtures,
    required this.nextFixtureByKey,
    required this.lineupSummary,
  });

  Player resolvePlayer(Player player) {
    final resolvedTeamName = _resolveTeamName(player);
    if (resolvedTeamName.isEmpty || resolvedTeamName == player.teamName) {
      return player;
    }
    return player.copyWith(teamName: resolvedTeamName);
  }

  int? teamPositionFor(Player player) {
    final resolvedPlayer = resolvePlayer(player);
    final byId = teamPositions[resolvedPlayer.teamId];
    if (byId != null && byId > 0) return byId;
    final byName = teamPositions[resolvedPlayer.teamName];
    if (byName != null && byName > 0) return byName;
    return null;
  }

  _NextFixtureInfo? nextFixtureFor(Player player) {
    final resolvedPlayer = resolvePlayer(player);
    return nextFixtureByKey[resolvedPlayer.teamId] ??
        nextFixtureByKey[resolvedPlayer.teamName];
  }

  String? fixtureContextFor(Player player) {
    final resolvedPlayer = resolvePlayer(player);
    final teamFixtures =
        nextFixtures[resolvedPlayer.teamId] ??
        nextFixtures[resolvedPlayer.teamName];
    if (teamFixtures == null || teamFixtures.isEmpty) {
      return null;
    }
    return teamFixtures.join('\n');
  }

  String? lineupContextFor(Player player) {
    final summary = lineupSummary;
    if (summary == null) {
      return null;
    }
    const posNames = {
      1: 'Torwart',
      2: 'Abwehrspieler',
      3: 'Mittelfeldspieler',
      4: 'Stürmer',
    };
    final posName = posNames[player.position] ?? 'Unbekannte Position';
    return '$summary. '
        'Dieser Spieler ist ein $posName (Position ${player.position}). '
        'Beachte ob ein Kauf/Verkauf die Positionsverteilung verbessert.';
  }

  String _resolveTeamName(Player player) {
    final byId = teamNamesByKey[player.teamId];
    if (byId != null && byId.isNotEmpty) {
      return byId;
    }
    final byName = teamNamesByKey[player.teamName];
    if (byName != null && byName.isNotEmpty) {
      return byName;
    }
    return player.teamName;
  }
}

class _NextFixtureInfo {
  final String opponentName;
  final int? opponentTablePosition;
  final int? ownTeamTablePosition;
  final bool isHomeGame;

  const _NextFixtureInfo({
    required this.opponentName,
    required this.opponentTablePosition,
    required this.ownTeamTablePosition,
    required this.isHomeGame,
  });

  String get matchLocationLabel => isHomeGame ? 'Heimspiel' : 'Auswärtsspiel';
}

/// Lädt die Bundesliga-Tabelle. Gibt leere Map bei Fehler zurück.
Future<Map<String, dynamic>> _loadTable(dynamic apiClient) async {
  try {
    return await apiClient.getCompetitionTable('1') as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

/// Lädt die Bundesliga-Spieltage. Gibt leere Map bei Fehler zurück.
Future<Map<String, dynamic>> _loadMatchdays(dynamic apiClient) async {
  try {
    return await apiClient.getCompetitionMatchdays('1') as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

/// Lädt den aktuellen Lineup. Gibt null bei Fehler zurück.
Future<LineupResponse?> _loadLineup(dynamic apiClient, String leagueId) async {
  try {
    return await apiClient.getLineup(leagueId) as LineupResponse;
  } catch (_) {
    return null;
  }
}

/// Provider für [GenerateAIRecommendationsNotifier].
final generateAIRecommendationsNotifierProvider =
    NotifierProvider<
      GenerateAIRecommendationsNotifier,
      GenerateAIRecommendationsState
    >(GenerateAIRecommendationsNotifier.new);

/// Provider, der die aktuellen AI-Empfehlungen für die ausgewählte Liga zurückgibt.
/// Diese werden aus dem Notifier-State gelesen, da Mistral-Ergebnisse nicht in Firestore gespeichert werden.
final currentAIPredictionsProvider = Provider<List<Recommendation>>((ref) {
  final genState = ref.watch(generateAIRecommendationsNotifierProvider);
  return genState.recommendations;
});

/// Provider, der die aktuellen AI-Empfehlungen für eine spezifische Liga zurückgibt.
final aiRecommendationsForLeagueProvider =
    Provider.family<List<Recommendation>, String>((ref, leagueId) {
      final genState = ref.watch(generateAIRecommendationsNotifierProvider);
      // Nur zurückgeben, wenn die League-ID übereinstimmt
      if (genState.leagueId == leagueId) {
        return genState.recommendations;
      }
      return [];
    });

/*
/// Example 1: Display recommendations for selected league
class RecommendationsListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(selectedLeagueRecommendationsProvider);

    return recommendationsAsync.when(
      data: (recommendations) {
        if (recommendations.isEmpty) {
          return Center(child: Text('No recommendations available'));
        }

        return ListView.builder(
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final rec = recommendations[index];
            return ListTile(
              leading: _getActionIcon(rec.action),
              title: Text(rec.playerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rec.reason),
                  Text('Confidence: ${(rec.confidence * 100).toStringAsFixed(0)}%'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${rec.score.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(rec.score),
                    ),
                  ),
                  Text('Score'),
                ],
              ),
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Widget _getActionIcon(String action) {
    switch (action) {
      case 'buy':
      case 'strong-buy':
        return Icon(Icons.trending_up, color: Colors.green);
      case 'sell':
      case 'strong-sell':
        return Icon(Icons.trending_down, color: Colors.red);
      default:
        return Icon(Icons.horizontal_rule, color: Colors.grey);
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green.shade700;
    if (score >= 60) return Colors.green;
    if (score >= 40) return Colors.orange;
    if (score >= 20) return Colors.red;
    return Colors.red.shade700;
  }
}

/// Example 2: Top recommendations widget
class TopRecommendationsWidget extends ConsumerWidget {
  final int limit;

  const TopRecommendationsWidget({this.limit = 5});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topRecsAsync = ref.watch(
      topSelectedLeagueRecommendationsProvider(limit),
    );

    return topRecsAsync.when(
      data: (recommendations) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top $limit Recommendations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          ...recommendations.map((rec) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getScoreColor(rec.score),
                child: Text(
                  '${rec.score.toInt()}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(rec.playerName),
              subtitle: Text(rec.reason),
              trailing: Chip(
                label: Text(rec.action.toUpperCase()),
                backgroundColor: rec.action.contains('buy')
                    ? Colors.green.shade100
                    : Colors.red.shade100,
              ),
            ),
          )),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green.shade700;
    if (score >= 60) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}

/// Example 3: Buy vs Sell recommendations
class BuySellRecommendationsWidget extends ConsumerWidget {
  final String leagueId;

  const BuySellRecommendationsWidget({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyRecsAsync = ref.watch(buyRecommendationsProvider(leagueId));
    final sellRecsAsync = ref.watch(sellRecommendationsProvider(leagueId));

    return Row(
      children: [
        Expanded(
          child: _RecommendationSection(
            title: 'Buy',
            recommendationsAsync: buyRecsAsync,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _RecommendationSection(
            title: 'Sell',
            recommendationsAsync: sellRecsAsync,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  final String title;
  final AsyncValue<List<Recommendation>> recommendationsAsync;
  final Color color;

  const _RecommendationSection({
    required this.title,
    required this.recommendationsAsync,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, color: color)),
        recommendationsAsync.when(
          data: (recommendations) => Column(
            children: recommendations.take(5).map((rec) => ListTile(
              dense: true,
              title: Text(rec.playerName),
              trailing: Text('${rec.score.toInt()}'),
            )).toList(),
          ),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error'),
        ),
      ],
    );
  }
}

/// Example 4: Recommendation detail view
class RecommendationDetailWidget extends ConsumerWidget {
  final String recommendationId;

  const RecommendationDetailWidget({required this.recommendationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recAsync = ref.watch(recommendationDetailsProvider(recommendationId));

    return recAsync.when(
      data: (rec) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rec.playerName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DetailCard('Score', '${rec.score.toStringAsFixed(1)}'),
              _DetailCard('Action', rec.action.toUpperCase()),
              _DetailCard(
                'Confidence',
                '${(rec.confidence * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reason', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(rec.reason),
                  SizedBox(height: 16),
                  Text('Values', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Current: €${rec.currentMarketValue}'),
                  Text('Estimated: €${rec.estimatedValue}'),
                  if (rec.suggestedPrice != null)
                    Text('Suggested: €${rec.suggestedPrice}'),
                ],
              ),
            ),
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

Widget _DetailCard(String label, String value) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

/// Example 5: Recommendation statistics dashboard
class RecommendationStatsDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(selectedLeagueRecommendationStatsProvider);
    final count = ref.watch(recommendationsCountProvider);
    final avgScore = ref.watch(averageRecommendationScoreProvider);
    final byAction = ref.watch(recommendationsByActionCountProvider);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn('Total', '$count'),
                    _StatColumn('Avg Score', avgScore.toStringAsFixed(1)),
                  ],
                ),
                SizedBox(height: 16),
                Text('By Action'),
                Wrap(
                  spacing: 8,
                  children: byAction.entries.map((entry) => Chip(
                    label: Text('${entry.key}: ${entry.value}'),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
        statsAsync.when(
          data: (stats) => Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detailed Statistics'),
                  ...stats.entries.map((entry) => ListTile(
                    title: Text(entry.key),
                    trailing: Text(entry.value.toString()),
                  )),
                ],
              ),
            ),
          ),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error loading stats'),
        ),
      ],
    );
  }
}

Widget _StatColumn(String label, String value) {
  return Column(
    children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text(label),
    ],
  );
}

/// Example 6: High confidence recommendations
class HighConfidenceRecommendationsWidget extends ConsumerWidget {
  final String leagueId;

  const HighConfidenceRecommendationsWidget({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recsAsync = ref.watch(highConfidenceRecommendationsProvider(leagueId));

    return recsAsync.when(
      data: (recommendations) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'High Confidence (≥70%)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return ListTile(
                leading: Icon(
                  Icons.verified,
                  color: Colors.blue,
                ),
                title: Text(rec.playerName),
                subtitle: Text(
                  'Confidence: ${(rec.confidence * 100).toStringAsFixed(0)}%',
                ),
                trailing: Chip(
                  label: Text('${rec.score.toInt()}'),
                  backgroundColor: Colors.green.shade100,
                ),
              );
            },
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 7: Listen to new recommendations
class RecommendationNotifier extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<Recommendation>>>(
      selectedLeagueRecommendationsProvider,
      (previous, next) {
        if (previous?.hasValue == true && next.hasValue) {
          final prevCount = previous!.value!.length;
          final newCount = next.value!.length;

          if (newCount > prevCount) {
            final newRecs = next.value!.skip(prevCount).toList();
            for (var rec in newRecs) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'New recommendation: ${rec.playerName} (${rec.action})',
                  ),
                  action: SnackBarAction(
                    label: 'View',
                    onPressed: () {
                      // Navigate to recommendation details
                    },
                  ),
                ),
              );
            }
          }
        }
      },
    );

    return Container();
  }
}

/// Example 8: Filter by category
class RecommendationsByCategoryWidget extends ConsumerWidget {
  final String leagueId;
  final String category;

  const RecommendationsByCategoryWidget({
    required this.leagueId,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = RecommendationsByCategoryParams(
      leagueId: leagueId,
      category: category,
    );
    final recsAsync = ref.watch(recommendationsByCategoryProvider(params));

    return recsAsync.when(
      data: (recommendations) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category: $category (${recommendations.length})',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return ListTile(
                title: Text(rec.playerName),
                subtitle: Text(rec.reason),
                trailing: Text('${rec.score.toInt()}'),
              );
            },
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
*/
