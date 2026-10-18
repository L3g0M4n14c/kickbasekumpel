import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/manager_comparison_model.dart';
import '../../data/providers/manager_comparison_providers.dart';
import '../../data/providers/user_providers.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

/// Manager-Direktvergleich („Du vs. Rivale").
///
/// Stellt zwei Manager einer Liga gegenüber: Kaderwert, Punkte der letzten
/// 5 Spieltage, Transfer-Erfolg und Budget sowie ein Stärken/Schwächen-
/// Kurzfazit als Klartext. Die Daten werden über den
/// `managerComparisonProvider` geladen (Kader-Benchmark, Transferhistorie,
/// Performance-Daten).
///
/// Einstieg: Auswahl in der Rangliste (`LeagueStandingsPage`) oder Route
/// `/manager/:leagueId/compare?a=<id>&b=<id>`.
class ManagerComparisonScreen extends ConsumerWidget {
  /// Erstellt den Direktvergleich-Screen.
  const ManagerComparisonScreen({
    required this.leagueId,
    required this.managerAId,
    required this.managerBId,
    super.key,
  });

  /// Liga-ID der beiden Manager.
  final String leagueId;

  /// Manager-ID der Seite A („Du", sofern beteiligt).
  final String managerAId;

  /// Manager-ID der Seite B (Rivale).
  final String managerBId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparisonAsync = ref.watch(
      managerComparisonProvider((
        leagueId: leagueId,
        managerAId: managerAId,
        managerBId: managerBId,
      )),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Direktvergleich')),
      body: comparisonAsync.when(
        data: (comparison) => _buildContent(context, ref, comparison),
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(
              managerComparisonProvider((
                leagueId: leagueId,
                managerAId: managerAId,
                managerBId: managerBId,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ManagerComparison comparison,
  ) {
    final currentUserId = ref.watch(currentUserDataProvider)?.i;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildHeader(context, comparison, currentUserId),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Gegenüberstellung'),
        _buildComparisonCard(context, comparison),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Punkte der letzten 5 Spieltage'),
        _buildLastFiveCard(context, comparison),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Kader nach Positionen'),
        _buildPositionsCard(context, comparison),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Stärken & Schwächen'),
        _buildSummaryCard(context, comparison),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Kopfbereich: beide Manager nebeneinander mit „vs."-Trenner.
  Widget _buildHeader(
    BuildContext context,
    ManagerComparison comparison,
    String? currentUserId,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _buildManagerColumn(context, comparison.a, currentUserId),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'vs.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: _buildManagerColumn(context, comparison.b, currentUserId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerColumn(
    BuildContext context,
    ManagerComparisonSide side,
    String? currentUserId,
  ) {
    final isCurrentUser = side.managerId == currentUserId;
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: isCurrentUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            side.managerName.isNotEmpty
                ? side.managerName[0].toUpperCase()
                : '?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isCurrentUser
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isCurrentUser ? 'Du' : side.managerName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          '${_money(side.teamValue)} Kaderwert',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  /// Gegenüberstellung der Kern-Kennzahlen (je Zeile A links, B rechts).
  Widget _buildComparisonCard(
    BuildContext context,
    ManagerComparison comparison,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (final row in comparison.rows) ...[
              _buildMetricRow(context, row),
              if (!identical(row, comparison.rows.last))
                const Divider(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(BuildContext context, ComparisonRow row) {
    final betterColor = Colors.green.shade700;
    final worseColor = Colors.red.shade700;
    final colorA = row.isTie
        ? null
        : row.aIsBetter
        ? betterColor
        : worseColor;
    final colorB = row.isTie
        ? null
        : row.aIsBetter
        ? worseColor
        : betterColor;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _formatMetric(row.metric, row.valueA),
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: colorA),
              ),
            ),
            SizedBox(
              width: 130,
              child: Text(
                _metricLabel(row.metric),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _formatMetric(row.metric, row.valueB),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: colorB),
              ),
            ),
          ],
        ),
        if (row.note.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              row.note,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  /// Punkte der letzten 5 Spieltage im direkten Vergleich.
  Widget _buildLastFiveCard(
    BuildContext context,
    ManagerComparison comparison,
  ) {
    final pointsA = {
      for (final m in comparison.a.lastMatchdayPoints) m.matchDay: m.points,
    };
    final pointsB = {
      for (final m in comparison.b.lastMatchdayPoints) m.matchDay: m.points,
    };
    final days = <int>{...pointsA.keys, ...pointsB.keys}.toList()
      ..sort((a, b) => b.compareTo(a));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: days.isEmpty
            ? Text(
                'Keine Spieltagspunkte verfügbar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : Column(
                children: [
                  for (final day in days)
                    _buildVersusRow(
                      context,
                      left: '${pointsA[day] ?? 0} Pkt',
                      label: 'Spieltag $day',
                      right: '${pointsB[day] ?? 0} Pkt',
                    ),
                  const Divider(height: 24),
                  _buildVersusRow(
                    context,
                    left: '${comparison.a.pointsLast5} Pkt',
                    label: 'Summe',
                    right: '${comparison.b.pointsLast5} Pkt',
                    bold: true,
                  ),
                ],
              ),
      ),
    );
  }

  /// Positionsweiser Kadervergleich (Punkte + Marktwert je Position).
  Widget _buildPositionsCard(
    BuildContext context,
    ManagerComparison comparison,
  ) {
    final positions = comparison.positionComparisons;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: positions.isEmpty
            ? Text(
                'Keine Kaderdaten verfügbar',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : Column(
                children: [
                  for (final position in positions) ...[
                    _buildVersusRow(
                      context,
                      left: '${position.pointsA} Pkt',
                      label: position.label,
                      right: '${position.pointsB} Pkt',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${_money(position.marketValueA)} vs. '
                        '${_money(position.marketValueB)} Marktwert',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (!identical(position, positions.last))
                      const Divider(height: 24),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildVersusRow(
    BuildContext context, {
    required String left,
    required String label,
    required String right,
    bool bold = false,
  }) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      children: [
        Expanded(
          child: Text(left, textAlign: TextAlign.right, style: style),
        ),
        SizedBox(
          width: 130,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Text(right, style: style)),
      ],
    );
  }

  /// Kurzfazit „Stärken/Schwächen" als Klartext-Liste.
  Widget _buildSummaryCard(BuildContext context, ManagerComparison comparison) {
    final strengths = comparison.strengths;
    final weaknesses = comparison.weaknesses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (strengths.isEmpty && weaknesses.isEmpty)
            ? Text(
                'Kaum Unterschiede – die beiden Manager liegen gleichauf.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (strengths.isNotEmpty) ...[
                    _buildSummaryHeader(
                      context,
                      'Stärken',
                      Icons.check_circle,
                      Colors.green.shade700,
                    ),
                    ...strengths.map(
                      (text) => _buildSummaryLine(
                        context,
                        text,
                        Colors.green.shade700,
                      ),
                    ),
                  ],
                  if (strengths.isNotEmpty && weaknesses.isNotEmpty)
                    const SizedBox(height: 16),
                  if (weaknesses.isNotEmpty) ...[
                    _buildSummaryHeader(
                      context,
                      'Schwächen',
                      Icons.warning,
                      Colors.red.shade700,
                    ),
                    ...weaknesses.map(
                      (text) =>
                          _buildSummaryLine(context, text, Colors.red.shade700),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummaryLine(BuildContext context, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, color: color, size: 20),
          const SizedBox(width: 4),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  String _metricLabel(ComparisonMetric metric) {
    switch (metric) {
      case ComparisonMetric.squadValue:
        return 'Kaderwert';
      case ComparisonMetric.pointsLast5:
        return 'Punkte (letzte 5)';
      case ComparisonMetric.transferSuccess:
        return 'Transfer-Erfolg';
      case ComparisonMetric.budget:
        return 'Budget';
    }
  }

  String _formatMetric(ComparisonMetric metric, double value) {
    switch (metric) {
      case ComparisonMetric.squadValue:
      case ComparisonMetric.budget:
        return _money(value);
      case ComparisonMetric.pointsLast5:
        return '${value.round()} Pkt';
      case ComparisonMetric.transferSuccess:
        return 'Ø ${value >= 0 ? '+' : ''}${_money(value)}';
    }
  }

  String _money(num value) => '${(value / 1000000).toStringAsFixed(1)}M€';
}
