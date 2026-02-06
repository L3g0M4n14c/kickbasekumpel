import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  /// Mobile: Single Column Layout
  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(context),
        const SizedBox(height: 16),
        _buildStatsGrid(context, columns: 2),
        const SizedBox(height: 16),
        _buildQuickActionsCard(context),
      ],
    );
  }

  /// Tablet: Split View with larger cards
  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildWelcomeCard(context),
                const SizedBox(height: 24),
                _buildStatsGrid(context, columns: 2),
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
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: ResponsiveContainer(
        desktopMaxWidth: 1600,
        child: Column(
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildStatsGrid(context, columns: 4)),
                const SizedBox(width: 32),
                Expanded(flex: 2, child: _buildQuickActionsCard(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Willkommen zurück!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24 * context.fontSizeMultiplier,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hier findest du deine wichtigsten Statistiken',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, {required int columns}) {
    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _StatCard(
          title: 'Ligen',
          value: '0',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
        _StatCard(
          title: 'Spieler',
          value: '0',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Budget',
          value: '0€',
          icon: Icons.account_balance_wallet,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Punkte',
          value: '0',
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
            onTap: () {
              // TODO: Navigate to leagues
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Zum Markt'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to market
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Transfers verwalten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to transfers
            },
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
