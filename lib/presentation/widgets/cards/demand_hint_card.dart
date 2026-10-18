import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kickbasekumpel/data/services/manager_transfer_history_service.dart';

/// Hinweis-Card zur Nachfrage im aktuellen Zeitfenster (Story #15).
///
/// Zeigt die Nachfrage-Intensität (hoch/mittel/niedrig) des aktuellen
/// Wochentag-/Zeitfensters auf Basis der aggregierten Transferhistorie der
/// Liga – „Verkaufe jetzt" statt „Verkaufe irgendwann".
///
/// Bei zu wenigen Daten ([TransferDemandProfile.intensity] == null) wird
/// nichts angezeigt.
///
/// **Verwendung:**
/// ```dart
/// DemandHintCard(profile: demandProfile)
/// ```
class DemandHintCard extends StatelessWidget {
  const DemandHintCard({super.key, required this.profile});

  /// Aggregierte Nachfrage der Liga (siehe [ManagerTransferHistoryService]).
  final TransferDemandProfile profile;

  @override
  Widget build(BuildContext context) {
    final intensity = profile.intensity;
    if (intensity == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final (icon, color, headline, advice) = switch (intensity) {
      DemandIntensity.high => (
        Icons.trending_up,
        Colors.green,
        'Nachfrage hoch',
        'Guter Zeitpunkt zum Verkaufen – die Liga kauft jetzt '
            'überdurchschnittlich oft.',
      ),
      DemandIntensity.medium => (
        Icons.trending_flat,
        Colors.orange,
        'Nachfrage mittel',
        'Normale Nachfrage – aktuell gibt es keinen klaren Timing-Vorteil.',
      ),
      DemandIntensity.low => (
        Icons.trending_down,
        Colors.blue,
        'Nachfrage niedrig',
        'Aktuell wird wenig gekauft – besser etwas abwarten.',
      ),
    };

    final oldest = profile.oldestPurchase;
    final dataBasis = oldest == null
        ? ''
        : 'Basis: ${profile.totalPurchases} Käufe der Liga seit '
              '${DateFormat('dd.MM.yyyy').format(oldest)}.';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verkaufs-Timing: $headline',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aktuelles Zeitfenster (${profile.currentWindow.label}): '
                    '${profile.currentWindowPurchases} Käufe '
                    '(Ø ${profile.averagePurchasesPerWindow.toStringAsFixed(1)} '
                    'pro Zeitfenster).',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(advice),
                  if (dataBasis.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(dataBasis, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
