import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/daily_bonus_providers.dart';

/// Dezentes Tagesbonus-Banner mit Tap-to-Collect (Story #17).
///
/// Zeigt sich nur, wenn ein Tagesbonus verfügbar ist. Ein Tippen auf das
/// Banner sammelt den Bonus ein und zeigt eine Bestätigung mit dem
/// Bonus-Betrag; bis zum nächsten Tag bleibt das Banner ausgeblendet.
class DailyBonusBanner extends ConsumerWidget {
  const DailyBonusBanner({super.key});

  /// Formatiert einen Geldbetrag kompakt (z. B. `10k€`, `1.2M€`).
  static String formatAmount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M€';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k€';
    }
    return '$value€';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyBonusProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Bestätigung nach dem Einsammeln (einmalig pro Vorgang)
    ref.listen(dailyBonusProvider, (previous, next) {
      final result = next.lastResult;
      if (result == null || previous?.lastResult == result) return;
      final collected = result.collections.isNotEmpty;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            collected
                ? 'Tagesbonus eingesammelt: ${formatAmount(result.totalValue)}'
                      '${result.maxDay > 0 ? ' (Tag ${result.maxDay})' : ''}'
                : 'Heute ist kein Tagesbonus verfügbar.',
          ),
          backgroundColor: collected ? Colors.green : Colors.orange,
        ),
      );
    });

    if (!state.isAvailable) return const SizedBox.shrink();

    return Semantics(
      button: true,
      label: 'Tagesbonus verfügbar – tippen zum Einsammeln',
      child: Card(
        color: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: state.isCollecting
              ? null
              : () => ref.read(dailyBonusProvider.notifier).collect(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tagesbonus verfügbar',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(color: colorScheme.onPrimaryContainer),
                      ),
                      Text(
                        state.isCollecting
                            ? 'Wird eingesammelt …'
                            : 'Tippen zum Einsammeln',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.isCollecting)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  )
                else
                  Icon(
                    Icons.touch_app,
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.7,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
