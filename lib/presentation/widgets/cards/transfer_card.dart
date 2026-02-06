import 'package:flutter/material.dart';

/// Transfer Card Widget für KickbaseKumpel
///
/// Zeigt einen Transfer mit Spieler, Preis und Zeitpunkt.
///
/// **Verwendung:**
/// ```dart
/// TransferCard(
///   playerName: 'Max Mustermann',
///   teamName: 'FC Bayern',
///   price: 5000000,
///   type: TransferType.buy,
///   date: DateTime.now(),
/// )
/// ```
class TransferCard extends StatelessWidget {
  /// Name des Spielers
  final String playerName;

  /// Name des Teams
  final String teamName;

  /// Transfer-Preis
  final int price;

  /// Art des Transfers
  final TransferType type;

  /// Datum des Transfers
  final DateTime date;

  /// Spieler-Bild URL
  final String? playerImageUrl;

  /// Callback wenn Karte getippt wird
  final VoidCallback? onTap;

  const TransferCard({
    required this.playerName,
    required this.teamName,
    required this.price,
    required this.type,
    required this.date,
    this.playerImageUrl,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBuy = type == TransferType.buy;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Transfer-Icon (Kauf/Verkauf)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isBuy ? Colors.green : Colors.red).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 24,
                  color: isBuy ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 16),

              // Spieler-Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spieler-Name
                    Text(
                      playerName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Team
                    Text(
                      teamName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Zeitstempel
                    Text(
                      _formatDate(date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Preis
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCurrency(price),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBuy ? 'Kauf' : 'Verkauf',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formatiert das Datum
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return 'vor ${diff.inMinutes} Min';
      }
      return 'vor ${diff.inHours} Std';
    } else if (diff.inDays == 1) {
      return 'Gestern';
    } else if (diff.inDays < 7) {
      return 'vor ${diff.inDays} Tagen';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  /// Formatiert Währung
  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M €';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K €';
    }
    return '$value €';
  }
}

/// Art des Transfers
enum TransferType {
  /// Kauf
  buy,

  /// Verkauf
  sell,
}
