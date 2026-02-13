import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/recommendation_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/models/transfer_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Transfers Screen
///
/// Zeigt Transferempfehlungen und ermöglicht Transfer-Management.
class TransfersScreen extends ConsumerStatefulWidget {
  const TransfersScreen({super.key});

  @override
  ConsumerState<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends ConsumerState<TransfersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLeague = ref.watch(selectedLeagueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Empfehlungen', icon: Icon(Icons.lightbulb_outline)),
            Tab(text: 'Kaufen', icon: Icon(Icons.add_shopping_cart)),
            Tab(text: 'Verkaufen', icon: Icon(Icons.remove_shopping_cart)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(recommendationsProvider),
          ),
        ],
      ),
      body: selectedLeague == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 80,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Keine Liga ausgewählt',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bitte wähle zuerst eine Liga aus',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _RecommendationsTab(),
                _BuyRecommendationsTab(),
                _SellRecommendationsTab(),
              ],
            ),
    );
  }
}

class _RecommendationsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final selectedLeague = ref.watch(selectedLeagueProvider);
    final leagueId = selectedLeague?.i;

    if (leagueId == null) {
      return const SizedBox.shrink();
    }

    final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(recommendationsProvider(leagueId));
      },
      child: recommendationsAsync.when(
        data: (recommendations) {
          if (recommendations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 80,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Keine Empfehlungen verfügbar',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Komm später wieder vorbei für neue Empfehlungen',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return _RecommendationCard(recommendation: rec);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(recommendationsProvider),
        ),
      ),
    );
  }
}

class _BuyRecommendationsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final selectedLeague = ref.watch(selectedLeagueProvider);
    final leagueId = selectedLeague?.i;

    if (leagueId == null) {
      return const SizedBox.shrink();
    }

    final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(recommendationsProvider);
      },
      child: recommendationsAsync.when(
        data: (recommendations) {
          final buyRecs = recommendations
              .where((r) => r.action.toLowerCase() == 'buy')
              .toList();

          if (buyRecs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_shopping_cart,
                      size: 80,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Keine Kauf-Empfehlungen',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            itemCount: buyRecs.length,
            itemBuilder: (context, index) {
              final rec = buyRecs[index];
              return _RecommendationCard(recommendation: rec);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(recommendationsProvider),
        ),
      ),
    );
  }
}

class _SellRecommendationsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final selectedLeague = ref.watch(selectedLeagueProvider);
    final leagueId = selectedLeague?.i;

    if (leagueId == null) {
      return const SizedBox.shrink();
    }

    final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(recommendationsProvider);
      },
      child: recommendationsAsync.when(
        data: (recommendations) {
          final sellRecs = recommendations
              .where((r) => r.action.toLowerCase() == 'sell')
              .toList();

          if (sellRecs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 80,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Keine Verkaufs-Empfehlungen',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            itemCount: sellRecs.length,
            itemBuilder: (context, index) {
              final rec = sellRecs[index];
              return _RecommendationCard(recommendation: rec);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(recommendationsProvider),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;

  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = _getActionColor(recommendation.action);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigate to player detail
          context.push('/player/${recommendation.playerId}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: actionColor,
                    child: Icon(
                      _getActionIcon(recommendation.action),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.playerName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recommendation.action.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: actionColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircularProgressIndicator(
                        value: recommendation.score,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(actionColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(recommendation.score * 100).toInt()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recommendation.reason,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoColumn(
                    label: 'Aktueller Wert',
                    value:
                        '${(recommendation.currentMarketValue / 1000000).toStringAsFixed(2)}M €',
                  ),
                  _InfoColumn(
                    label: 'Geschätzter Wert',
                    value:
                        '${(recommendation.estimatedValue / 1000000).toStringAsFixed(2)}M €',
                  ),
                  if (recommendation.suggestedPrice != null)
                    _InfoColumn(
                      label: 'Empf. Preis',
                      value:
                          '${(recommendation.suggestedPrice! / 1000000).toStringAsFixed(2)}M €',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'buy':
        return Colors.green;
      case 'sell':
        return Colors.red;
      case 'hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'buy':
        return Icons.add_shopping_cart;
      case 'sell':
        return Icons.remove_shopping_cart;
      case 'hold':
        return Icons.pause;
      default:
        return Icons.help_outline;
    }
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
