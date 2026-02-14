import 'package:flutter/material.dart';

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
                      color: totalBudget < 0
                          ? Colors.red
                          : (saleValue > 0 ? Colors.green : Colors.black87),
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
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      final kValue = value / 1000;
      return kValue < 10
          ? kValue.toStringAsFixed(1)
          : '${kValue.toStringAsFixed(0)}k';
    }
    return value.toString();
  }
}
