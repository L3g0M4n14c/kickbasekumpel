import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/league_detail_providers.dart';
import '../../data/providers/league_providers.dart';
import '../../data/models/player_model.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/charts/position_badge.dart';
import 'player/player_detail_screen.dart';

class SquadScreen extends ConsumerWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    
    if (selectedLeague == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mein Kader')),
        body: const Center(child: Text('Keine Liga ausgewählt')),
      );
    }

    final squadAsync = ref.watch(mySquadProvider(selectedLeague.i));
    final budgetAsync = ref.watch(myBudgetProvider(selectedLeague.i));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Kader'),
      ),
      body: squadAsync.when(
        data: (squadData) {
          final players = (squadData['it'] as List?)
              ?.map((json) => Player.fromJson(json as Map<String, dynamic>))
              .toList() ?? [];

          if (players.isEmpty) {
            return const Center(child: Text('Keine Spieler im Kader'));
          }

          return Column(
            children: [
              _BudgetHeader(budgetAsync: budgetAsync),
              Expanded(
                child: _SquadList(
                  players: players,
                  leagueId: selectedLeague.i,
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(mySquadProvider(selectedLeague.i)),
        ),
      ),
    );
  }
}

class _BudgetHeader extends StatelessWidget {
  final AsyncValue<Map<String, dynamic>> budgetAsync;

  const _BudgetHeader({required this.budgetAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return budgetAsync.when(
      data: (budgetData) {
        final budget = budgetData['budget'] as int? ?? 0;
        final teamValue = budgetData['teamValue'] as int? ?? 0;
        
        return Card(
          margin: const EdgeInsets.all(16),
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BudgetItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Budget',
                  value: '${(budget / 1000000).toStringAsFixed(2)} M €',
                  color: theme.colorScheme.primary,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
                _BudgetItem(
                  icon: Icons.groups,
                  label: 'Teamwert',
                  value: '${(teamValue / 1000000).toStringAsFixed(2)} M €',
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 80),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BudgetItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _BudgetItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

class _SquadList extends StatelessWidget {
  final List<Player> players;
  final String leagueId;

  const _SquadList({required this.players, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    final groupedPlayers = _groupPlayersByPosition(players);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildPositionSection(context, 'Torwart', groupedPlayers[1] ?? [], leagueId),
        _buildPositionSection(context, 'Abwehr', groupedPlayers[2] ?? [], leagueId),
        _buildPositionSection(context, 'Mittelfeld', groupedPlayers[3] ?? [], leagueId),
        _buildPositionSection(context, 'Sturm', groupedPlayers[4] ?? [], leagueId),
      ],
    );
  }

  Map<int, List<Player>> _groupPlayersByPosition(List<Player> players) {
    final Map<int, List<Player>> grouped = {};
    for (var player in players) {
      grouped.putIfAbsent(player.position, () => []).add(player);
    }
    return grouped;
  }

  Widget _buildPositionSection(
    BuildContext context,
    String title,
    List<Player> players,
    String leagueId,
  ) {
    if (players.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...players.map((player) => _PlayerTile(player: player, leagueId: leagueId)),
      ],
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final Player player;
  final String leagueId;

  const _PlayerTile({required this.player, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerDetailScreen(
                playerId: player.id,
                leagueId: leagueId,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: player.profileBigUrl.isNotEmpty
                    ? NetworkImage(player.profileBigUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: player.profileBigUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.grey[600])
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${player.firstName} ${player.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        PositionBadge(
                          position: player.position,
                          size: PositionBadgeSize.small,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            player.teamName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '${(player.marketValue / 1000000).toStringAsFixed(2)} M €',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (player.marketValueTrend != 0)
                        Icon(
                          player.marketValueTrend > 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 16,
                          color: player.marketValueTrend > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.emoji_events, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        'Ø ${player.averagePoints.toStringAsFixed(1)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${player.totalPoints}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
