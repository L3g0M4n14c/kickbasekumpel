import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/common/app_logo.dart';

class PlayerHistoryPage extends ConsumerWidget {
  final String playerId;

  const PlayerHistoryPage({required this.playerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spieler-Historie')),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  /// Mobile: Single column scrolling
  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTransferHistory(context),
        const SizedBox(height: 16),
        _buildPerformanceHistory(context),
        const SizedBox(height: 16),
        _buildValueChart(context),
      ],
    );
  }

  /// Tablet: Two column grid
  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: ResponsiveGrid(
        tabletColumns: 2,
        desktopColumns: 2,
        children: [
          Column(
            children: [
              _buildTransferHistory(context),
              const SizedBox(height: 24),
              _buildValueChart(context),
            ],
          ),
          _buildPerformanceHistory(context),
        ],
      ),
    );
  }

  /// Desktop: Three column layout
  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsiveContainer(
      desktopMaxWidth: 1600,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildValueChart(context),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildTransferHistory(context)),
                const SizedBox(width: 32),
                Expanded(child: _buildPerformanceHistory(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferHistory(BuildContext context) {
    return _HistorySection(
      title: 'Transfer-Historie',
      icon: Icon(
        Icons.swap_horiz,
        size: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: List.generate(
        5,
        (index) => _HistoryItem(
          date: '15.0${index + 1}.2024',
          title: 'Transfer ${index + 1}',
          subtitle: 'Manager A → Manager B',
          value: '${5000000 + (index * 100000)}€',
          iconWidget: Icon(Icons.swap_horiz, size: 20),
        ),
      ),
    );
  }

  Widget _buildPerformanceHistory(BuildContext context) {
    return _HistorySection(
      title: 'Leistungs-Historie',
      icon: Icon(
        Icons.trending_up,
        size: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: List.generate(
        10,
        (index) => _HistoryItem(
          date: 'Spieltag ${34 - index}',
          title: 'vs. Verein ${index + 1}',
          subtitle:
              '${(index % 2 == 0) ? 'Sieg' : 'Niederlage'} • ${index % 3}:${(index + 1) % 3}',
          value: '${10 - index} Pkt',
          iconWidget: AppLogo(size: 20),
        ),
      ),
    );
  }

  Widget _buildValueChart(BuildContext context) {
    return _HistorySection(
      title: 'Marktwert-Entwicklung',
      icon: Icon(
        Icons.show_chart,
        size: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        ResponsiveCard(
          child: SizedBox(
            height: context.isMobile ? 200 : 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.show_chart, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Chart kommt bald',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  final String title;
  final Widget icon;
  final List<Widget> children;

  const _HistorySection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date;
  final String title;
  final String subtitle;
  final String value;
  final Widget iconWidget;

  const _HistoryItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(child: iconWidget),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 2),
            Text(
              date,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        isThreeLine: true,
      ),
    );
  }
}
