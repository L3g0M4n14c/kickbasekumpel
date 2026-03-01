import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/player_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/models/lineup_model.dart';
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
    final leagueId = selectedLeague?.i;
    final lineupAsync = leagueId != null
        ? ref.watch(myLineupProvider(leagueId))
        : const AsyncValue<List<LineupPlayer>>.loading();

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
          if (leagueId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(myLineupProvider(leagueId)),
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
                ref.invalidate(myLineupProvider(leagueId!));
              },
              child: lineupAsync.when(
                data: (players) {
                  // Kickbase-Konvention: Torwart hat lo=0, Feldspieler lo=1..11
                  bool isStarter(LineupPlayer p) {
                    if (p.position == 1 && p.lineupOrder == 0) return true;
                    return p.lineupOrder >= 1 && p.lineupOrder <= 11;
                  }

                  final starters = players.where(isStarter).toList()
                    ..sort((a, b) {
                      final aOrder = a.lineupOrder == 0 ? 11 : a.lineupOrder;
                      final bOrder = b.lineupOrder == 0 ? 11 : b.lineupOrder;
                      return aOrder.compareTo(bOrder);
                    });

                  final bench = players.where((p) => !isStarter(p)).toList();

                  // Group starters by position
                  final goalkeepers = starters
                      .where((p) => p.position == 1)
                      .toList();
                  final defenders = starters
                      .where((p) => p.position == 2)
                      .toList();
                  final midfielders = starters
                      .where((p) => p.position == 3)
                      .toList();
                  final forwards = starters
                      .where((p) => p.position == 4)
                      .toList();

                  final avgPoints = starters.isEmpty
                      ? 0.0
                      : starters
                                .map((p) => p.averagePoints)
                                .reduce((a, b) => a + b) /
                            starters.length;

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
                                      Icons.sports_soccer,
                                      size: 20,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                    label: 'Startelf',
                                    value: '${starters.length}',
                                  ),
                                  _InfoChip(
                                    icon: Icon(
                                      Icons.stars,
                                      size: 20,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                    label: 'Ø Punkte',
                                    value: avgPoints.toStringAsFixed(1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lineup sections (starters grouped by position)
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
                      if (bench.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 8),
                        _LineupSection(
                          title: 'Bank',
                          icon: Icon(
                            Icons.weekend,
                            size: 20,
                            color: Colors.grey,
                          ),
                          players: bench,
                          color: Colors.grey,
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const LoadingWidget(),
                error: (error, stack) => ErrorWidgetCustom(
                  error: error,
                  onRetry: () => ref.invalidate(myLineupProvider(leagueId!)),
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
  final List<LineupPlayer> players;
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
  final LineupPlayer player;
  final Color color;

  const _PlayerLineupCard({required this.player, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final positionLabel = switch (player.position) {
      1 => 'TW',
      2 => 'ABW',
      3 => 'MF',
      4 => 'ST',
      _ => '?',
    };

    final statusIcon = switch (player.matchDayStatus) {
      1 => const Icon(Icons.sick, size: 14, color: Colors.red),
      2 => const Icon(Icons.block, size: 14, color: Colors.orange),
      _ => null,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.2),
              child: Text(
                positionLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            if (statusIcon != null)
              Positioned(right: -4, top: -4, child: statusIcon),
          ],
        ),
        title: Text(
          player.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.stars, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text('${player.averagePoints} Ø'),
            const SizedBox(width: 12),
            Icon(
              Icons.event,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text('${player.totalPoints} Pkt'),
            if (player.hasToday) ...[
              const SizedBox(width: 8),
              const Icon(Icons.today, size: 14, color: Colors.green),
            ],
          ],
        ),
        trailing: player.lineupOrder > 0
            ? CircleAvatar(
                radius: 14,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Text(
                  '${player.lineupOrder}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
