import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/player_providers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Player Stats Screen
///
/// Zeigt detaillierte Statistiken eines Spielers an.
class PlayerStatsScreen extends ConsumerWidget {
  final String playerId;

  const PlayerStatsScreen({required this.playerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final playerAsync = ref.watch(playerStatsProvider(playerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiken')),
      body: playerAsync.when(
        data: (player) => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: player.profileBigUrl.isNotEmpty
                          ? NetworkImage(player.profileBigUrl)
                          : null,
                      child: player.profileBigUrl.isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${player.firstName} ${player.lastName}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      player.teamName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats
            Text(
              'Leistungsdaten',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _StatRow(
                      'Ø Punkte',
                      player.averagePoints.toStringAsFixed(2),
                    ),
                    const Divider(),
                    _StatRow('Gesamtpunkte', '${player.totalPoints}'),
                    const Divider(),
                    _StatRow(
                      'Marktwert',
                      '${(player.marketValue / 1000000).toStringAsFixed(2)}M €',
                    ),
                    const Divider(),
                    _StatRow(
                      'Trend',
                      '${player.marketValueTrend > 0 ? '+' : ''}${(player.marketValueTrend / 1000).toStringAsFixed(0)}k',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(playerStatsProvider(playerId)),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
