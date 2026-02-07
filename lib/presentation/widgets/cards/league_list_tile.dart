import 'package:flutter/material.dart';
import '../../../data/models/league_model.dart';

/// League List Tile für KickbaseKumpel
///
/// Kompakte List-Darstellung einer Liga für Listen-Views.
///
/// **Verwendung:**
/// ```dart
/// LeagueListTile(
///   league: league,
///   onTap: () => Navigator.push(...),
///   showPlacement: true,
/// )
/// ```
class LeagueListTile extends StatelessWidget {
  /// Liga-Objekt
  final League league;

  /// Callback wenn Tile getippt wird
  final VoidCallback? onTap;

  /// Zeigt Platzierung
  final bool showPlacement;

  /// Zeigt Trailing-Icon
  final bool showTrailing;

  const LeagueListTile({
    required this.league,
    this.onTap,
    this.showPlacement = true,
    this.showTrailing = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = league.cu;
    final placement = user.placement;
    final points = user.points;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      leading: _buildLeagueIcon(colorScheme),
      title: Text(
        league.n,
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
          Text(
            'Spieltag ${league.md}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (showPlacement) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                // Platzierung
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getPlacementColor(placement).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars,
                        size: 12,
                        color: _getPlacementColor(placement),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Platz $placement',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getPlacementColor(placement),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Punkte
                Icon(Icons.emoji_events, size: 14, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  '$points Pkt',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: showTrailing
          ? Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant)
          : null,
    );
  }

  /// Liga-Icon
  Widget _buildLeagueIcon(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.emoji_events,
        size: 24,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }

  /// Farbe basierend auf Platzierung
  Color _getPlacementColor(int placement) {
    if (placement <= 3) {
      return Colors.green;
    } else if (placement <= 6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
