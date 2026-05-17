import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/presentation/widgets/transfers/transfer_plan_formatters.dart';

class TransferPlanDetailSheet extends StatelessWidget {
  const TransferPlanDetailSheet({super.key, required this.scenario});

  final TransferPlanScenario scenario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Szenario-Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              scenario.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(scenario.summary),
            const SizedBox(height: 16),
            _SectionTitle(title: 'Kaeufe'),
            if (scenario.buys.isEmpty)
              const Text('Keine')
            else
              ...scenario.buys.map(
                (move) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(formatPlayerName(move.player)),
                  subtitle: Text(formatTransferCurrency(move.amount)),
                ),
              ),
            const SizedBox(height: 8),
            _SectionTitle(title: 'Verkaeufe'),
            if (scenario.sells.isEmpty)
              const Text('Keine')
            else
              ...scenario.sells.map(
                (move) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(formatPlayerName(move.player)),
                  subtitle: Text(formatTransferCurrency(move.amount)),
                ),
              ),
            const SizedBox(height: 8),
            _SectionTitle(title: 'Resultierende Startelf'),
            if (scenario.resultingStarters.isEmpty)
              const Text('Keine Spieler')
            else
              ...scenario.resultingStarters.map(
                (player) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(formatPlayerName(player)),
                ),
              ),
            const SizedBox(height: 8),
            _SectionTitle(title: 'Budget'),
            Text('Vorher: ${formatTransferCurrency(scenario.budgetBefore)}'),
            Text('Nachher: ${formatTransferCurrency(scenario.budgetAfter)}'),
            const SizedBox(height: 8),
            _SectionTitle(title: 'Warnungen'),
            if (scenario.warnings.isEmpty)
              const Text('Keine Warnungen')
            else
              ...scenario.warnings.map((warning) => Text('• $warning')),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
