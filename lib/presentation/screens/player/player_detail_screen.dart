import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/player_providers.dart';
import '../../../data/models/player_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Player Detail Screen
///
/// Zeigt detaillierte Informationen zu einem Spieler an.
class PlayerDetailScreen extends ConsumerStatefulWidget {
  final String playerId;

  const PlayerDetailScreen({required this.playerId, super.key});

  @override
  ConsumerState<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends ConsumerState<PlayerDetailScreen>
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final playerAsync = ref.watch(playerDetailsProvider(widget.playerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spieler Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Übersicht', icon: Icon(Icons.info_outline)),
            Tab(text: 'Statistiken', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: playerAsync.when(
        data: (player) => TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(player: player, isTablet: isTablet),
            _StatsTab(player: player, isTablet: isTablet),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(playerDetailsProvider(widget.playerId)),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Player player;
  final bool isTablet;

  const _OverviewTab({required this.player, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      children: [
        // Player Header Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: player.profileBigUrl.isNotEmpty
                      ? NetworkImage(player.profileBigUrl)
                      : null,
                  child: player.profileBigUrl.isEmpty
                      ? const Icon(Icons.person, size: 64)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${player.firstName} ${player.lastName}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  player.teamName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Chip(
                  label: Text(_getPositionName(player.position)),
                  backgroundColor: _getPositionColor(player.position),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Market Value Card
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Marktwert',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(player.marketValue / 1000000).toStringAsFixed(2)} M €',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      player.marketValueTrend > 0
                          ? Icons.trending_up
                          : player.marketValueTrend < 0
                          ? Icons.trending_down
                          : Icons.remove,
                      color: player.marketValueTrend > 0
                          ? Colors.green
                          : player.marketValueTrend < 0
                          ? Colors.red
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${player.marketValueTrend > 0 ? '+' : ''}${(player.marketValueTrend / 1000).toStringAsFixed(0)}k',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: player.marketValueTrend > 0
                            ? Colors.green
                            : player.marketValueTrend < 0
                            ? Colors.red
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Stats Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard(
              icon: Icons.stars,
              label: 'Ø Punkte',
              value: player.averagePoints.toStringAsFixed(1),
              color: Colors.amber,
            ),
            _StatCard(
              icon: Icons.event,
              label: 'Gesamtpunkte',
              value: '${player.totalPoints}',
              color: Colors.blue,
            ),
            _StatCard(
              icon: Icons.confirmation_number,
              label: 'Trikotnummer',
              value: '${player.number}',
              color: Colors.green,
            ),
            _StatCard(
              icon: Icons.health_and_safety,
              label: 'Status',
              value: _getStatusName(player.status),
              color: _getStatusColor(player.status),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Ownership Status
        if (player.userOwnsPlayer)
          Card(
            color: Colors.green.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Du besitzt diesen Spieler',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.yellow.shade700;
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

  String _getPositionName(int position) {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusName(int status) {
    switch (status) {
      case 0:
        return 'Fit';
      case 1:
        return 'Fraglich';
      case 2:
        return 'Verletzt';
      default:
        return 'Unbekannt';
    }
  }
}

class _StatsTab extends StatelessWidget {
  final Player player;
  final bool isTablet;

  const _StatsTab({required this.player, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      children: [
        Text(
          'Leistungsdaten',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Performance Stats
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _StatRow(
                  label: 'Durchschnittspunkte',
                  value: player.averagePoints.toStringAsFixed(2),
                  icon: Icons.stars,
                ),
                const Divider(),
                _StatRow(
                  label: 'Gesamtpunkte',
                  value: '${player.totalPoints}',
                  icon: Icons.event,
                ),
                const Divider(),
                _StatRow(
                  label: 'Marktwert',
                  value:
                      '${(player.marketValue / 1000000).toStringAsFixed(2)}M €',
                  icon: Icons.attach_money,
                ),
                const Divider(),
                _StatRow(
                  label: 'Trend',
                  value:
                      '${player.marketValueTrend > 0 ? '+' : ''}${(player.marketValueTrend / 1000).toStringAsFixed(0)}k',
                  icon: Icons.trending_up,
                  valueColor: player.marketValueTrend > 0
                      ? Colors.green
                      : player.marketValueTrend < 0
                      ? Colors.red
                      : Colors.grey,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Additional Info
        Text(
          'Weitere Informationen',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _StatRow(
                  label: 'Verein',
                  value: player.teamName,
                  icon: Icons.shield,
                ),
                const Divider(),
                _StatRow(
                  label: 'Position',
                  value: _getPositionName(player.position),
                  icon: Icons.sports,
                ),
                const Divider(),
                _StatRow(
                  label: 'Trikotnummer',
                  value: '${player.number}',
                  icon: Icons.confirmation_number,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getPositionName(int position) {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
