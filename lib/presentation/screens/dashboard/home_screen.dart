import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/user_providers.dart' as user_prov;
import '../../../data/providers/league_providers.dart';
import '../../../data/providers/recommendation_providers.dart';
import '../../../data/providers/player_providers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Home Screen
///
/// Dashboard-Übersichtsseite mit wichtigsten Statistiken und Quick Actions.
/// Zeigt Benutzerinfo, aktive Liga, Team-Wert und Empfehlungen.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Trigger auto-select of first league
    ref.watch(autoSelectFirstLeagueProvider);

    final userAsync = ref.watch(user_prov.currentUserProvider);
    final leaguesAsync = ref.watch(userLeaguesProvider);
    final selectedLeague = ref.watch(selectedLeagueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/dashboard/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(user_prov.currentUserProvider);
          ref.invalidate(userLeaguesProvider);
        },
        child: ListView(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          children: [
            // Welcome Card
            userAsync.when(
              data: (user) => _WelcomeCard(
                userName: user?.n ?? 'Unbekannt',
                userEmail: user?.em ?? '',
              ),
              loading: () => const LoadingWidget(),
              error: (error, stack) => ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(user_prov.currentUserProvider),
              ),
            ),
            const SizedBox(height: 16),

            // League Selector
            leaguesAsync.when(
              data: (leagues) {
                if (leagues.isEmpty) {
                  return _EmptyLeaguesCard();
                }
                return _LeagueSelector(
                  leagues: leagues,
                  selectedLeague: selectedLeague,
                  onLeagueSelected: (league) {
                    ref.read(selectedLeagueProvider.notifier).select(league);
                  },
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) => ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(userLeaguesProvider),
              ),
            ),
            const SizedBox(height: 16),

            // Lineup Section (only if league selected)
            if (selectedLeague != null) ...[
              _KaderSection(leagueId: selectedLeague.i),
              const SizedBox(height: 16),
            ],

            // Quick Actions
            _QuickActionsSection(),
            const SizedBox(height: 16),

            // Latest Recommendations
            if (selectedLeague != null) _LatestRecommendations(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String userName;
  final String userEmail;

  const _WelcomeCard({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Willkommen zurück!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LeagueSelector extends StatelessWidget {
  final List leagues;
  final dynamic selectedLeague;
  final Function(dynamic) onLeagueSelected;

  const _LeagueSelector({
    required this.leagues,
    required this.selectedLeague,
    required this.onLeagueSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktive Liga',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              initialValue: selectedLeague,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.emoji_events),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              hint: const Text('Liga auswählen'),
              items: leagues
                  .map(
                    (league) =>
                        DropdownMenuItem(value: league, child: Text(league.n)),
                  )
                  .toList(),
              onChanged: (league) => onLeagueSelected(league),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLeaguesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Ligen gefunden',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tritt einer Liga bei oder erstelle eine neue Liga in Kickbase.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      _QuickAction(
        icon: Icons.store,
        label: 'Markt',
        color: Colors.blue,
        onTap: () => context.go('/dashboard/market'),
      ),
      _QuickAction(
        icon: Icons.group,
        label: 'Aufstellung',
        color: Colors.green,
        onTap: () => context.go('/dashboard/lineup'),
      ),
      _QuickAction(
        icon: Icons.swap_horiz,
        label: 'Transfers',
        color: Colors.orange,
        onTap: () => context.go('/dashboard/transfers'),
      ),
      _QuickAction(
        icon: Icons.emoji_events,
        label: 'Ligen',
        color: Colors.purple,
        onTap: () => context.go('/dashboard/leagues'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) => actions[index],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestRecommendations extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final leagueId = selectedLeague?.i;

    if (leagueId == null) {
      return const SizedBox.shrink();
    }

    final recommendationsAsync = ref.watch(recommendationsProvider(leagueId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Empfehlungen',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/dashboard/transfers'),
              child: const Text('Alle anzeigen'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        recommendationsAsync.when(
          data: (recommendations) {
            if (recommendations.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Keine Empfehlungen verfügbar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendations.take(3).length,
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getActionColor(rec.action),
                      child: Icon(
                        _getActionIcon(rec.action),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(rec.playerName),
                    subtitle: Text(rec.reason),
                    trailing: Chip(
                      label: Text(
                        '${(rec.score * 100).toInt()}%',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getActionColor(rec.action),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // TODO: Navigate to player detail
                    },
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, stack) => ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(recommendationsProvider),
          ),
        ),
      ],
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

class _KaderSection extends ConsumerWidget {
  final String leagueId;

  const _KaderSection({required this.leagueId});

  String _getPositionLabel(int position) {
    switch (position) {
      case 1:
        return 'TW';
      case 2:
        return 'AB';
      case 3:
        return 'MF';
      case 4:
        return 'ST';
      default:
        return '?';
    }
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final myLineupAsync = ref.watch(myLineupProvider(leagueId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dein Kader',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        myLineupAsync.when(
          data: (players) {
            if (players.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Keine Spieler in deinem Kader',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }

            final starters =
                players
                    .where((p) => p.lineupOrder > 0 && p.lineupOrder <= 11)
                    .toList()
                  ..sort((a, b) => a.lineupOrder.compareTo(b.lineupOrder));

            final bench = players.where((p) => p.lineupOrder > 11).toList();

            return Column(
              children: [
                // Startelf
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Startelf (${starters.length})',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 600
                                    ? 6
                                    : 4,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: starters.length,
                          itemBuilder: (context, index) {
                            final player = starters[index];
                            return _PlayerCard(
                              name: player.name,
                              position: player.position,
                              points: player.totalPoints,
                              positionLabel: _getPositionLabel(player.position),
                              positionColor: _getPositionColor(player.position),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (bench.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(Icons.group, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bank',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${bench.length} ${bench.length == 1 ? 'Spieler' : 'Spieler'}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, stack) => ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(myLineupProvider(leagueId)),
          ),
        ),
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final String name;
  final int position;
  final int points;
  final String positionLabel;
  final Color positionColor;

  const _PlayerCard({
    required this.name,
    required this.position,
    required this.points,
    required this.positionLabel,
    required this.positionColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameParts = name.split(' ');
    final displayName = nameParts.length > 1 ? nameParts.last : name;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: positionColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  positionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$points Pts',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
