import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'position_badge.dart';

/// Spieler-Reihe mit Verkaufs-Toggle
class PlayerRowWithSale extends StatelessWidget {
  final Player player;
  final bool isSelectedForSale;
  final Function(bool) onToggleSale;

  const PlayerRowWithSale({
    required this.player,
    required this.isSelectedForSale,
    required this.onToggleSale,
    super.key,
  });

  String get fullName => '${player.firstName} ${player.lastName}';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Position Badge
            PositionBadge(position: player.position),
            const SizedBox(width: 12),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player.teamName,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      player.averagePoints.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '€${_formatValue(player.marketValue)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Sale Toggle
            Checkbox(
              value: isSelectedForSale,
              onChanged: (value) => onToggleSale(value ?? false),
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
          ? '${kValue.toStringAsFixed(1)}k'
          : '${kValue.toStringAsFixed(0)}k';
    }
    return value.toString();
  }
}
