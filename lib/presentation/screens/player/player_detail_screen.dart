import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/player_detail_providers.dart';
import '../../../data/providers/kickbase_api_provider.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/performance_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/charts/performance_line_chart.dart';
import '../../widgets/charts/price_chart.dart';

/// Player Detail Screen
///
/// Zeigt detaillierte Informationen zu einem Spieler an.
class PlayerDetailScreen extends ConsumerStatefulWidget {
  final String playerId;
  final String leagueId;

  const PlayerDetailScreen({
    required this.playerId,
    required this.leagueId,
    super.key,
  });

  @override
  ConsumerState<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends ConsumerState<PlayerDetailScreen>
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final playerAsync = ref.watch(
      playerDetailsProvider((
        leagueId: widget.leagueId,
        playerId: widget.playerId,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spieler Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Übersicht', icon: Icon(Icons.info_outline)),
            Tab(text: 'Performance', icon: Icon(Icons.bar_chart)),
            Tab(text: 'Marktwert', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: playerAsync.when(
        data: (playerData) {
          final player = _parsePlayer(playerData);
          return TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(player: player, isTablet: isTablet),
              _PerformanceTab(
                leagueId: widget.leagueId,
                playerId: widget.playerId,
                isTablet: isTablet,
              ),
              _MarketValueTab(
                leagueId: widget.leagueId,
                playerId: widget.playerId,
                isTablet: isTablet,
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            playerDetailsProvider((
              leagueId: widget.leagueId,
              playerId: widget.playerId,
            )),
          ),
        ),
      ),
    );
  }

  Player _parsePlayer(Map<String, dynamic> data) {
    return Player(
      id: data['id'] ?? '',
      firstName: data['fn'] ?? '',
      lastName: data['ln'] ?? '',
      profileBigUrl: data['profileBigUrl'] ?? '',
      teamName: data['tn'] ?? '',
      teamId: data['teamId'] ?? '',
      position: _parseIntField(data, 'position'),
      number: _parseIntField(data, 'number'),
      averagePoints: _parseDoubleField(data, 'averagePoints'),
      totalPoints: _parseIntField(data, 'totalPoints'),
      marketValue: _parseIntField(data, 'marketValue'),
      marketValueTrend: _parseIntField(data, 'marketValueTrend'),
      tfhmvt: _parseIntField(data, 'tfhmvt'),
      prlo: _parseIntField(data, 'prlo'),
      stl: _parseIntField(data, 'stl'),
      status: _parseIntField(data, 'status'),
      userOwnsPlayer: data['userOwnsPlayer'] ?? false,
    );
  }

  int _parseIntField(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is List && value.isNotEmpty) {
      return _parseIntField({'value': value.first}, 'value');
    }
    return 0;
  }

  double _parseDoubleField(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is List && value.isNotEmpty) {
      return _parseDoubleField({'value': value.first}, 'value');
    }
    return 0.0;
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

class _PerformanceTab extends ConsumerWidget {
  final String leagueId;
  final String playerId;
  final bool isTablet;

  const _PerformanceTab({
    required this.leagueId,
    required this.playerId,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return FutureBuilder<PlayerPerformanceResponse>(
      future: ref
          .read(kickbaseApiClientProvider)
          .getPlayerStats(leagueId, playerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Fehler beim Laden der Performance-Daten',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.it.isEmpty) {
          return Center(
            child: Text(
              'Keine Performance-Daten verfügbar',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        final performanceData = snapshot.data!;
        // Nimm die erste Saison (aktuelle Saison)
        final currentSeason = performanceData.it.first;
        final points = currentSeason.ph
            .where((match) => match.p != null)
            .map(
              (match) => PerformancePoint(
                matchDay: match.day,
                points: match.p!.toDouble(),
              ),
            )
            .toList();

        if (points.isEmpty) {
          return Center(
            child: Text(
              'Keine Performance-Daten verfügbar',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          children: [
            Text(
              'Leistungsverlauf',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            PerformanceLineChart(
              data: points,
              title: 'Punkte pro Spieltag',
              height: 300,
            ),
          ],
        );
      },
    );
  }
}

class _MarketValueTab extends ConsumerWidget {
  final String leagueId;
  final String playerId;
  final bool isTablet;

  const _MarketValueTab({
    required this.leagueId,
    required this.playerId,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final marketValueAsync = ref.watch(
      playerMarketValueYearProvider((leagueId: leagueId, playerId: playerId)),
    );

    return marketValueAsync.when(
      data: (data) {
        final marketValues =
            (data['mv'] as List?)?.map((item) {
              return PricePoint(
                date: DateTime.parse(item['d'] as String),
                price: item['m'] as int,
              );
            }).toList() ??
            [];

        if (marketValues.isEmpty) {
          return Center(
            child: Text(
              'Keine Marktwert-Daten verfügbar',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          children: [
            Text(
              'Marktwert-Entwicklung',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            PriceChart(
              data: marketValues,
              title: 'Marktwert (365 Tage)',
              height: 300,
            ),
            const SizedBox(height: 24),
            _buildMarketValueStats(context, marketValues),
          ],
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Text(
          'Fehler beim Laden der Marktwert-Daten',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildMarketValueStats(BuildContext context, List<PricePoint> data) {
    final theme = Theme.of(context);

    if (data.isEmpty) return const SizedBox.shrink();

    final currentValue = data.last.price;
    final oldestValue = data.first.price;
    final change = currentValue - oldestValue;
    final changePercent = (change / oldestValue * 100);
    final maxValue = data.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((p) => p.price).reduce((a, b) => a < b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiken',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Aktueller Wert',
              value: _formatCurrency(currentValue),
              icon: Icons.attach_money,
            ),
            const Divider(),
            _StatRow(
              label: 'Veränderung',
              value:
                  '${change > 0 ? '+' : ''}${_formatCurrency(change)} (${changePercent.toStringAsFixed(1)}%)',
              icon: Icons.trending_up,
              valueColor: change > 0
                  ? Colors.green
                  : change < 0
                  ? Colors.red
                  : null,
            ),
            const Divider(),
            _StatRow(
              label: 'Maximum',
              value: _formatCurrency(maxValue),
              icon: Icons.arrow_upward,
            ),
            const Divider(),
            _StatRow(
              label: 'Minimum',
              value: _formatCurrency(minValue),
              icon: Icons.arrow_downward,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)} M €';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} K €';
    }
    return '$value €';
  }
}

// ignore: unused_element
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
                const Divider(),
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
