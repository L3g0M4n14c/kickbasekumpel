import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';

class PlayerStatsPage extends ConsumerWidget {
  final String playerId;

  const PlayerStatsPage({required this.playerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spieler-Statistiken'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share player
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  /// Mobile: Single column scrolling layout
  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildPlayerHeader(context),
        const SizedBox(height: 16),
        _buildStatsSection(context),
        const SizedBox(height: 16),
        _buildActionButtons(context),
      ],
    );
  }

  /// Tablet: Split view with header/stats on left, details on right
  Widget _buildTabletLayout(BuildContext context) {
    return ResponsiveSplitView(
      listFlex: 2,
      detailFlex: 3,
      list: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildPlayerHeader(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildStatsSection(context),
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
            _buildPlayerHeader(context),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildStatsSection(context)),
                const SizedBox(width: 32),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildActionButtons(context),
                      const SizedBox(height: 24),
                      _buildAdditionalInfo(context),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerHeader(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: context.isMobile ? 50 : 60,
            child: Icon(Icons.person, size: context.isMobile ? 50 : 60),
          ),
          const SizedBox(height: 16),
          Text(
            'Spieler-Name',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24 * context.fontSizeMultiplier,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Verein • Position',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: $playerId',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _StatBadge(
                label: 'Marktwert',
                value: '5.0M€',
                color: Colors.green,
              ),
              _StatBadge(label: 'Punkte', value: '125', color: Colors.blue),
              _StatBadge(label: 'Ø/Spiel', value: '8.5', color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      children: [
        _StatsSection(
          title: 'Saison-Statistiken',
          stats: [
            _StatRow(label: 'Spiele', value: '15'),
            _StatRow(label: 'Tore', value: '5'),
            _StatRow(label: 'Assists', value: '3'),
            _StatRow(label: 'Gelbe Karten', value: '2'),
            _StatRow(label: 'Rote Karten', value: '0'),
          ],
        ),
        const SizedBox(height: 16),
        _StatsSection(
          title: 'Form',
          stats: [
            _StatRow(label: 'Letzte 5 Spiele', value: '45 Pkt'),
            _StatRow(label: 'Durchschnitt', value: '9.0'),
            _StatRow(label: 'Trend', value: '↗'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              // TODO: Buy player
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Kaufen'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              // TODO: View history
            },
            icon: const Icon(Icons.history),
            label: const Text('Historie'),
            style: FilledButton.styleFrom(backgroundColor: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Zusatzinformationen',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Vertragsende: 2025'),
          const SizedBox(height: 8),
          const Text('Nationalität: Deutschland'),
          const SizedBox(height: 8),
          const Text('Größe: 180 cm'),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  final String title;
  final List<Widget> stats;

  const _StatsSection({required this.title, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...stats,
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
