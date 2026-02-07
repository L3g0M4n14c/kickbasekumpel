import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/screen_size.dart';
import '../../../data/providers/user_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/models/league_model.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final leaguesAsync = ref.watch(userLeaguesProvider);

    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Notifications
                  },
                ),
              ],
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          ref.invalidate(userLeaguesProvider);
        },
        child: userAsync.when(
          data: (user) {
            return leaguesAsync.when(
              data: (leagues) {
                return ResponsiveLayout(
                  mobile: _buildMobileLayout(context, user, leagues),
                  tablet: _buildTabletLayout(context, user, leagues),
                  desktop: _buildDesktopLayout(context, user, leagues),
                );
              },
              loading: () => const Center(child: LoadingWidget()),
              error: (error, stack) => Center(
                child: ErrorWidgetCustom(
                  error: error,
                  onRetry: () => ref.invalidate(userLeaguesProvider),
                ),
              ),
            );
          },
          loading: () => const Center(child: LoadingWidget()),
          error: (error, stack) => Center(
            child: ErrorWidgetCustom(
              error: error,
              onRetry: () => ref.invalidate(currentUserProvider),
            ),
          ),
        ),
      ),
    );
  }

  /// Mobile: Single Column Layout
  Widget _buildMobileLayout(BuildContext context, user, leagues) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(context, user),
        const SizedBox(height: 16),
        _buildStatsGrid(context, user, leagues, columns: 2),
        const SizedBox(height: 16),
        _buildQuickActionsCard(context),
      ],
    );
  }

  /// Tablet: Split View with larger cards
  Widget _buildTabletLayout(BuildContext context, user, leagues) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildWelcomeCard(context, user),
                const SizedBox(height: 24),
                _buildStatsGrid(context, user, leagues, columns: 2),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildQuickActionsCard(context),
          ),
        ),
      ],
    );
  }

  /// Desktop: Multi-column Layout
  Widget _buildDesktopLayout(BuildContext context, user, leagues) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: ResponsiveContainer(
        desktopMaxWidth: 1600,
        child: Column(
          children: [
            _buildWelcomeCard(context, user),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildStatsGrid(context, user, leagues, columns: 4),
                ),
                const SizedBox(width: 32),
                Expanded(flex: 2, child: _buildQuickActionsCard(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, user) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Willkommen zurück, ${user?.n ?? 'Unbekannt'}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24 * context.fontSizeMultiplier,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user?.em ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    user,
    leagues, {
    required int columns,
  }) {
    final leaguesList = leagues as List<League>?;
    final leagueCount = leaguesList?.length ?? 0;

    // Get stats from first league (if available)
    // The /v4/leagues/selection response includes budget, teamValue, and placement per league
    final firstLeague = (leaguesList != null && leaguesList.isNotEmpty)
        ? leaguesList[0]
        : null;

    final budget = firstLeague?.b ?? 0;
    final teamValue = firstLeague?.tv ?? 0;
    final placement = firstLeague?.pl ?? 0;

    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _StatCard(
          title: 'Ligen',
          value: leagueCount.toString(),
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
        _StatCard(
          title: 'Budget',
          value: '${(budget / 1000000).toStringAsFixed(1)}M€',
          icon: Icons.account_balance_wallet,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Team-Wert',
          value: '${(teamValue / 1000000).toStringAsFixed(1)}M€',
          icon: Icons.trending_up,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Platzierung',
          value: placement > 0 ? '#$placement' : '-',
          icon: Icons.stars,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Schnellzugriff',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Ligen anzeigen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dashboard/leagues'),
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Zum Markt'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dashboard/market'),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Transfers verwalten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dashboard/transfers'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
