import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/screen_size.dart';
import '../../../data/providers/league_detail_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/models/player_model.dart';
import '../../screens/squad_screen.dart';
import '../../screens/live_screen.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/charts/position_badge.dart';
import 'lineup_page.dart';

/// Team Page with tabs for Kader, Empfohlene Aufstellung, Verkaufen, and Live
class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
              title: const Text('Team'),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Kader', icon: Icon(Icons.people)),
                  Tab(text: 'Empfohlene Aufstellung', icon: Icon(Icons.auto_awesome)),
                  Tab(text: 'Verkaufen', icon: Icon(Icons.remove_shopping_cart)),
                  Tab(text: 'Live', icon: Icon(Icons.sports_soccer)),
                ],
              ),
            )
          : AppBar(
              title: const Text('Team'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Kader', icon: Icon(Icons.people)),
                  Tab(text: 'Empfohlene Aufstellung', icon: Icon(Icons.auto_awesome)),
                  Tab(text: 'Verkaufen', icon: Icon(Icons.remove_shopping_cart)),
                  Tab(text: 'Live', icon: Icon(Icons.sports_soccer)),
                ],
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SquadScreen(), // Kader
          LineupPage(), // Empfohlene Aufstellung
          _SellTab(), // Verkaufen
          LiveScreen(), // Live
        ],
      ),
    );
  }
}

/// Sell Tab - shows squad players with sell options
class _SellTab extends ConsumerWidget {
  const _SellTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLeague = ref.watch(selectedLeagueProvider);
    
    if (selectedLeague == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 80,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Keine Liga ausgewählt',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Bitte wähle zuerst eine Liga aus',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final squadAsync = ref.watch(mySquadProvider(selectedLeague.i));

    return squadAsync.when(
      data: (squadData) {
        final players = (squadData['it'] as List?)
            ?.map((json) => Player.fromJson(json as Map<String, dynamic>))
            .toList() ?? [];

        if (players.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keine Spieler im Kader',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: PositionBadge(position: player.position),
                ),
                title: Text('${player.firstName} ${player.lastName}'),
                subtitle: Text(
                  'Marktwert: ${(player.marketValue / 1000000).toStringAsFixed(2)} M €',
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    _showSellDialog(context, player);
                  },
                  icon: const Icon(Icons.sell, size: 16),
                  label: const Text('Verkaufen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                    foregroundColor: theme.colorScheme.onErrorContainer,
                  ),
                ),
                onTap: () {
                  // Navigate to player details
                  context.push('/player/${player.i}/stats');
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: CustomErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(mySquadProvider(selectedLeague.i)),
        ),
      ),
    );
  }

  void _showSellDialog(BuildContext context, Player player) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Spieler verkaufen'),
        content: Text(
          'Möchtest du ${player.firstName} ${player.lastName} wirklich verkaufen?\n\n'
          'Verkaufspreis: ${(player.marketValue / 1000000).toStringAsFixed(2)} M €',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sell logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Verkauf von ${player.firstName} ${player.lastName} wurde initiiert'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Ja, verkaufen'),
          ),
        ],
      ),
    );
  }
}
