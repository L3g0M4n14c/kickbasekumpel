import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Team Budget Header - Zeigt aktuelles Budget und Verkaufs-Summe
class TeamBudgetHeader extends StatelessWidget {
  final int currentBudget;
  final int saleValue;

  const TeamBudgetHeader({
    required this.currentBudget,
    required this.saleValue,
    super.key,
  });

  int get totalBudget => currentBudget + saleValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktuelles Budget',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '€${_formatValue(currentBudget)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: currentBudget < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget + Verkäufe',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '€${_formatValue(totalBudget)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: totalBudget >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(int value) {
    // Ungerundete Ganzzahl mit Tausendertrennzeichen
    final formatter = NumberFormat.decimalPattern('de_DE');
    return formatter.format(value);
  }
}
