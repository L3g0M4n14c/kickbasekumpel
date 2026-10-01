import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/squad_benchmark_model.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/providers/squad_benchmark_providers.dart';

/// Kader-Benchmark-Card
///
/// Vergleicht den eigenen Kader positionsweise (TW/ABW/MF/ST) mit dem
/// Durchschnitt aller Manager der Liga:
/// - Gesamt-Marktwert der Position vs. Ligen-Ø
/// - Ø Punkte der Position vs. Ligen-Ø
///
/// Zeilen, in denen der eigene Kader unter dem Ligen-Schnitt liegt, werden
/// rot hervorgehoben – so sieht man auf einen Blick, wo das Budget fehlt.
class SquadBenchmarkCard extends ConsumerWidget {
  const SquadBenchmarkCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final leagueId = selectedLeague?.i;

    if (leagueId == null) return const SizedBox.shrink();

    final benchmarkAsync = ref.watch(leagueSquadBenchmarkProvider(leagueId));

    return benchmarkAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (benchmark) {
        // Ohne Vergleichsmanager ist der Benchmark wertlos.
        if (benchmark.managerCount == 0) return const SizedBox.shrink();
        return _BenchmarkContent(benchmark: benchmark);
      },
    );
  }
}

class _BenchmarkContent extends StatelessWidget {
  final SquadBenchmark benchmark;

  const _BenchmarkContent({required this.benchmark});

  String _formatEuro(num value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} M €';
    }
    return '${(value / 1000).toStringAsFixed(0)} T €';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kader-Benchmark (Ø von ${benchmark.managerCount} Managern)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Dein Gesamt-Kaderwert: ${_formatEuro(benchmark.ownTotalMarketValue)} '
              'vs. Ligen-Ø ${_formatEuro(benchmark.leagueAvgTotalMarketValue)} '
              '(${benchmark.totalMarketValueDelta >= 0 ? '+' : ''}'
              '${_formatEuro(benchmark.totalMarketValueDelta)})',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 20),
            // Kopfzeile
            Row(
              children: [
                const SizedBox(width: 36),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Marktwert',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Ø Punkte',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...benchmark.positions.map((row) => _BenchmarkRow(row: row)),
            const SizedBox(height: 6),
            Text(
              'Rot = unter dem Ligen-Durchschnitt. Kombiniere schwache '
              'Positionen mit dem Transfer-Planer, um das Budget gezielt '
              'einzusetzen.',
              style: theme.textTheme.labelSmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Eine Benchmark-Zeile (eine Position).
class _BenchmarkRow extends StatelessWidget {
  final PositionBenchmark row;

  const _BenchmarkRow({required this.row});

  String _formatEuro(num value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} M €';
    }
    return '${(value / 1000).toStringAsFixed(0)} T €';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Positions-Badge
          Container(
            width: 34,
            padding: const EdgeInsets.symmetric(vertical: 3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              row.label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Marktwert: eigener Wert vs. Ligen-Ø
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatEuro(row.ownMarketValue)} · '
                  'Ø ${_formatEuro(row.leagueAvgMarketValue)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: row.marketValueDelta < 0
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                  ),
                ),
                Text(
                  '${row.marketValueDelta >= 0 ? '+' : ''}'
                  '${_formatEuro(row.marketValueDelta)} '
                  'vs. Ligen-Schnitt',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Ø Punkte: eigene Position vs. Ligen-Ø
          Expanded(
            child: Text(
              '${row.ownAvgPoints.toStringAsFixed(0)} / '
              'Ø ${row.leagueAvgPoints.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: row.pointsDelta < 0
                    ? Colors.red.shade700
                    : Colors.green.shade700,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}


