import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../../data/providers/recommendation_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/models/transfer_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../screens/dashboard/market_screen.dart';

/// Markt Page with tabs for Transfermarkt and Transfer-Tipps
class MarktPage extends ConsumerStatefulWidget {
  const MarktPage({super.key});

  @override
  ConsumerState<MarktPage> createState() => _MarktPageState();
}

class _MarktPageState extends ConsumerState<MarktPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Markt'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Transfermarkt', icon: Icon(Icons.store)),
                  Tab(text: 'Transfer-Tipps', icon: Icon(Icons.lightbulb_outline)),
                ],
              ),
            )
          : AppBar(
              title: const Text('Markt'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Transfermarkt', icon: Icon(Icons.store)),
                  Tab(text: 'Transfer-Tipps', icon: Icon(Icons.lightbulb_outline)),
                ],
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MarketScreen(), // Transfermarkt with its own tabs
          _TransferTipsTab(), // Transfer recommendations
        ],
      ),
    );
  }
}

/// Transfer Tips Tab - shows transfer recommendations
class _TransferTipsTab extends ConsumerWidget {
  const _TransferTipsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLeague = ref.watch(selectedLeagueProvider);

    if (selectedLeague == null) {
      return Center(
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
      );
    }

    final recommendationsAsync = ref.watch(recommendationsProvider);

    return recommendationsAsync.when(
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
                  const SizedBox(height: 16),
                  Text(
                    'Keine Empfehlungen verfügbar',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aktuell gibt es keine Transfer-Empfehlungen',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(recommendationsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getActionColor(rec.action, theme),
                    child: Icon(
                      _getActionIcon(rec.action),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(rec.playerName ?? 'Unbekannt'),
                  subtitle: Text(rec.reasoning ?? 'Keine Beschreibung'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to player details
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: CustomErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(recommendationsProvider),
        ),
      ),
    );
  }

  Color _getActionColor(String action, ThemeData theme) {
    switch (action.toLowerCase()) {
      case 'buy':
        return Colors.green;
      case 'sell':
        return Colors.red;
      case 'hold':
        return Colors.blue;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'buy':
        return Icons.add_shopping_cart;
      case 'sell':
        return Icons.remove_shopping_cart;
      case 'hold':
        return Icons.pause_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}
