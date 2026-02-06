import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';

class LineupPage extends ConsumerWidget {
  const LineupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Aufstellung'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Edit lineup
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

  /// Mobile: Full width single column with drag & drop
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLineupField(context, compact: true),
          const SizedBox(height: 16),
          _buildPlayersList(context),
        ],
      ),
    );
  }

  /// Tablet: Split view - Field on left, players list on right
  Widget _buildTabletLayout(BuildContext context) {
    return ResponsiveSplitView(
      listFlex: 3,
      detailFlex: 2,
      list: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildLineupField(context, compact: false),
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildPlayersList(context),
      ),
    );
  }

  /// Desktop: Three columns - Field, Players, Stats
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _buildLineupField(context, compact: false),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _buildPlayersList(context),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _buildStatsPanel(context),
          ),
        ),
      ],
    );
  }

  Widget _buildLineupField(BuildContext context, {required bool compact}) {
    return ResponsiveCard(
      child: Column(
        children: [
          Text('Spielfeld', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Container(
            height: compact ? 300 : 500,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[300]!),
            ),
            child: const Center(child: Text('Aufstellungsfeld (TODO)')),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verfügbare Spieler',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ResponsiveCard(
          child: Column(
            children: [
              _buildPlayerItem('Torwart', Icons.sports_handball),
              const Divider(),
              _buildPlayerItem('Abwehr', Icons.shield),
              const Divider(),
              _buildPlayerItem('Mittelfeld', Icons.sports_soccer),
              const Divider(),
              _buildPlayerItem('Sturm', Icons.offline_bolt),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerItem(String position, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(position),
      subtitle: const Text('0 Spieler'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Show players by position
      },
    );
  }

  Widget _buildStatsPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistiken', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ResponsiveCard(
          child: Column(
            children: [
              _buildStatRow('Gesamtwert', '0€'),
              const Divider(),
              _buildStatRow('Punkte (Gesamt)', '0'),
              const Divider(),
              _buildStatRow('Ø Punkte', '0'),
              const Divider(),
              _buildStatRow('Form', '0%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
