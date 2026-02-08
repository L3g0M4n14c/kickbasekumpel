import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class ManagerDetailScreen extends ConsumerStatefulWidget {
  final String leagueId;
  final String userId;

  const ManagerDetailScreen({
    required this.leagueId,
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<ManagerDetailScreen> createState() => _ManagerDetailScreenState();
}

class _ManagerDetailScreenState extends ConsumerState<ManagerDetailScreen>
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
    final dashboardAsync = ref.watch(
      managerDashboardProvider((leagueId: widget.leagueId, userId: widget.userId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager-Profil'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Kader', icon: Icon(Icons.people)),
            Tab(text: 'Performance', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: dashboardAsync.when(
        data: (dashboardData) {
          return Column(
            children: [
              _buildManagerHeader(context, dashboardData),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSquadTab(context),
                    _buildPerformanceTab(context),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(
              managerDashboardProvider((leagueId: widget.leagueId, userId: widget.userId)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManagerHeader(BuildContext context, Map<String, dynamic> dashboardData) {
    final name = dashboardData['userName'] ?? dashboardData['name'] ?? 'Unbekannt';
    final teamValue = dashboardData['teamValue'] ?? dashboardData['tv'] ?? 0;
    final budget = dashboardData['budget'] ?? dashboardData['b'] ?? 0;
    final points = dashboardData['points'] ?? dashboardData['p'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                context,
                'Teamwert',
                '${(teamValue / 1000000).toStringAsFixed(2)}M€',
                Icons.workspace_premium,
              ),
              _buildStatCard(
                context,
                'Budget',
                '${(budget / 1000000).toStringAsFixed(2)}M€',
                Icons.account_balance_wallet,
              ),
              _buildStatCard(
                context,
                'Punkte',
                '$points',
                Icons.emoji_events,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSquadTab(BuildContext context) {
    final squadAsync = ref.watch(
      managerSquadProvider((leagueId: widget.leagueId, userId: widget.userId)),
    );

    return squadAsync.when(
      data: (squadData) {
        final players = squadData['p'] as List? ?? squadData['players'] as List? ?? [];

        if (players.isEmpty) {
          return const Center(
            child: Text('Keine Spieler im Kader'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return _buildPlayerCard(context, player);
          },
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerSquadProvider((leagueId: widget.leagueId, userId: widget.userId)),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, dynamic player) {
    final firstName = player['firstName'] ?? player['fn'] ?? '';
    final lastName = player['lastName'] ?? player['ln'] ?? '';
    final name = '$firstName $lastName'.trim();
    final position = player['position'] ?? player['pos'] ?? '';
    final marketValue = player['marketValue'] ?? player['mv'] ?? 0;
    final points = player['totalPoints'] ?? player['points'] ?? player['p'] ?? 0;
    final teamName = player['teamName'] ?? player['t'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(
            position.toString().toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(teamName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(marketValue / 1000000).toStringAsFixed(1)}M€',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '$points Pkt',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab(BuildContext context) {
    final performanceAsync = ref.watch(
      managerPerformanceProvider((leagueId: widget.leagueId, userId: widget.userId)),
    );

    return performanceAsync.when(
      data: (performanceData) {
        final performances = performanceData['performances'] as List? ?? [];

        if (performances.isEmpty) {
          return const Center(
            child: Text('Keine Performance-Daten verfügbar'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: performances.length,
          itemBuilder: (context, index) {
            final performance = performances[index];
            return _buildPerformanceCard(context, performance);
          },
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerPerformanceProvider((leagueId: widget.leagueId, userId: widget.userId)),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context, dynamic performance) {
    final matchDay = performance['matchDay'] ?? performance['md'] ?? 0;
    final points = performance['points'] ?? performance['p'] ?? 0;
    final rank = performance['rank'] ?? performance['r'] ?? 0;
    final teamValue = performance['teamValue'] ?? performance['tv'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '$matchDay',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          'Spieltag $matchDay',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Platz $rank'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$points Pkt',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '${(teamValue / 1000000).toStringAsFixed(1)}M€',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
