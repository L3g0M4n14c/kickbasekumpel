import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';

class TransferPlanCard extends StatelessWidget {
  const TransferPlanCard({
    super.key,
    required this.scenario,
    required this.onTap,
  });

  final TransferPlanScenario scenario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scenario.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(scenario.summary, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      '+${scenario.score.startingElevenGain.toStringAsFixed(1)} Startelf',
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Budget: ${_formatCurrency(scenario.budgetAfter)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
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
