import 'package:flutter/material.dart';
import '../../../data/models/player_model.dart';

/// Player List Tile für KickbaseKumpel
///
/// Kompakte List-Darstellung eines Spielers für Listen-Views.
///
/// **Verwendung:**
/// ```dart
/// PlayerListTile(
///   player: player,
///   onTap: () => Navigator.push(...),
///   showPoints: true,
///   showPrice: true,
/// )
/// ```
class PlayerListTile extends StatelessWidget {
  /// Spieler-Objekt
  final Player player;

  /// Callback wenn Tile getippt wird
  final VoidCallback? onTap;

  /// Zeigt Punkte
  final bool showPoints;

  /// Zeigt Marktwert
  final bool showPrice;

  /// Zeigt Trailing-Icon (z.B. Pfeil)
  final bool showTrailing;

  /// Custom Trailing Widget
  final Widget? trailing;

  const PlayerListTile({
    required this.player,
    this.onTap,
    this.showPoints = true,
    this.showPrice = true,
    this.showTrailing = true,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      leading: _buildPlayerImage(),
      title: Text(
        '${player.firstName} ${player.lastName}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                _getPositionIcon(player.position),
                size: 14,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                player.teamName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (showPoints || showPrice) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                if (showPoints) ...[
                  Icon(
                    Icons.emoji_events,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${player.averagePoints.toStringAsFixed(1)} Ø',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (showPoints && showPrice) const SizedBox(width: 12),
                if (showPrice) ...[
                  Icon(Icons.euro, size: 14, color: colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatCurrency(player.marketValue),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
      trailing:
          trailing ??
          (showTrailing
              ? Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant)
              : null),
    );
  }

  /// Spieler-Bild
  Widget _buildPlayerImage() {
    return CircleAvatar(
      radius: 24,
      backgroundImage: player.profileBigUrl.isNotEmpty
          ? NetworkImage(player.profileBigUrl)
          : null,
      backgroundColor: Colors.grey[300],
      child: player.profileBigUrl.isEmpty
          ? Icon(Icons.person, color: Colors.grey[600])
          : null,
    );
  }

  /// Position-Icon
  IconData _getPositionIcon(int position) {
    switch (position) {
      case 1:
        return Icons.sports; // Torwart
      case 2:
        return Icons.shield; // Abwehr
      case 3:
        return Icons.person; // Mittelfeld
      case 4:
        return Icons.flash_on; // Sturm
      default:
        return Icons.help;
    }
  }

  /// Formatiert Währung
  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toString();
  }
}
