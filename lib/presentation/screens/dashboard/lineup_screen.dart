import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/player_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/models/player_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/common/app_logo.dart';
import '../../widgets/error_widget.dart';

/// Lineup Screen
///
/// Zeigt die aktuelle Aufstellung des Teams und ermöglicht Änderungen.
class LineupScreen extends ConsumerWidget {
  const LineupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final selectedLeague = ref.watch(selectedLeagueProvider);
    final playersAsync = ref.watch(allPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aufstellung'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: () {
              // TODO: Auto-optimize lineup
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auto-Optimierung kommt bald!')),
              );
            },
            tooltip: 'Auto-Optimierung',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(allPlayersProvider),
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
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(allPlayersProvider);
              },
              child: playersAsync.when(
                data: (players) {
                  // Filter owned players
                  final ownedPlayers = players
                      .where((p) => p.userOwnsPlayer)
                      .toList();

                  // Group by position
                  final goalkeepers = ownedPlayers
                      .where((p) => p.position == 1)
                      .toList();
                  final defenders = ownedPlayers
                      .where((p) => p.position == 2)
                      .toList();
                  final midfielders = ownedPlayers
                      .where((p) => p.position == 3)
                      .toList();
                  final forwards = ownedPlayers
                      .where((p) => p.position == 4)
                      .toList();

                  return ListView(
                    padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                    children: [
                      // Team Info Card
                      Card(
                        color: theme.colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                selectedLeague.cu.teamName,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _InfoChip(
                                    icon: Icon(
                                      Icons.attach_money,
                                      size: 20,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                    label: 'Team-Wert',
                                    value:
                                        '${(selectedLeague.cu.teamValue / 1000000).toStringAsFixed(1)}M €',
                                  ),
                                  _InfoChip(
                                    icon: Icon(
                                      Icons.people,
                                      size: 20,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                    label: 'Spieler',
                                    value: '${ownedPlayers.length}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lineup sections
                      _LineupSection(
                        title: 'Torwart',
                        icon: AppLogo(size: 20, backgroundColor: Colors.yellow),
                        players: goalkeepers,
                        color: Colors.yellow,
                      ),
                      const SizedBox(height: 16),
                      _LineupSection(
                        title: 'Abwehr',
                        icon: Icon(Icons.shield, size: 20, color: Colors.blue),
                        players: defenders,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      _LineupSection(
                        title: 'Mittelfeld',
                        icon: Icon(Icons.sports, size: 20, color: Colors.green),
                        players: midfielders,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _LineupSection(
                        title: 'Sturm',
                        icon: AppLogo(size: 20, backgroundColor: Colors.red),
                        players: forwards,
                        color: Colors.red,
                      ),
                    ],
                  );
                },
                loading: () => const LoadingWidget(),
                error: (error, stack) => ErrorWidgetCustom(
                  error: error,
                  onRetry: () => ref.invalidate(allPlayersProvider),
                ),
              ),
            ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final Widget icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        icon,
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

class _LineupSection extends StatelessWidget {
  final String title;
  final Widget icon;
  final List<Player> players;
  final Color color;

  const _LineupSection({
    required this.title,
    required this.icon,
    required this.players,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Chip(
              label: Text('${players.length}'),
              backgroundColor: color.withValues(alpha: 0.2),
              labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (players.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'Keine Spieler in dieser Position',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          ...players.map(
            (player) => _PlayerLineupCard(player: player, color: color),
          ),
      ],
    );
  }
}

class _PlayerLineupCard extends StatelessWidget {
  final Player player;
  final Color color;

  const _PlayerLineupCard({required this.player, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: player.profileBigUrl.isNotEmpty
              ? NetworkImage(player.profileBigUrl)
              : null,
          child: player.profileBigUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Text(
          '${player.firstName} ${player.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(player.teamName),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.stars, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text('${player.averagePoints.toStringAsFixed(1)} Ø'),
                const SizedBox(width: 12),
                Icon(
                  Icons.event,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text('${player.totalPoints} Punkte'),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(player.marketValue / 1000000).toStringAsFixed(2)}M',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (player.marketValueTrend != 0)
              Text(
                '${player.marketValueTrend > 0 ? '+' : ''}${(player.marketValueTrend / 1000).toStringAsFixed(0)}k',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: player.marketValueTrend > 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to player detail
        },
      ),
    );
  }
}
