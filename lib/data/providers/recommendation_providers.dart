import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transfer_model.dart';
import '../../domain/repositories/repository_interfaces.dart';
import 'repository_providers.dart';
import 'league_providers.dart';

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
// USAGE EXAMPLES
// ============================================================================

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
