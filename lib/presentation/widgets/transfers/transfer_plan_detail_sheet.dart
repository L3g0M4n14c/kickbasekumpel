import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';

class TransferPlanDetailSheet extends StatelessWidget {
  const TransferPlanDetailSheet({super.key, required this.scenario});

  final TransferPlanScenario scenario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
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
            Text('Verkaeufe: ${scenario.sells.length}'),
            Text('Kaeufe: ${scenario.buys.length}'),
            const SizedBox(height: 8),
            Text('Budget vorher: ${_formatCurrency(scenario.budgetBefore)}'),
            Text('Budget nachher: ${_formatCurrency(scenario.budgetAfter)}'),
            const SizedBox(height: 8),
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

String _formatCurrency(int value) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs();
  final raw = abs.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }

  return '$sign${buffer.toString()} €';
}
