import 'package:flutter/material.dart';
import '../../../data/models/player_model.dart';

/// Player Card Widget für KickbaseKumpel
///
/// Zeigt einen Spieler mit Bild, Name, Team und optionalen Statistiken.
/// Material Design 3 mit Dark Mode Support.
///
/// **Verwendung:**
/// ```dart
/// PlayerCard(
///   player: player,
///   onTap: () => Navigator.push(...),
///   showStats: true,
///   compact: false,
/// )
/// ```
class PlayerCard extends StatelessWidget {
  /// Spieler-Objekt
  final Player player;

  /// Callback wenn Karte getippt wird
  final VoidCallback? onTap;

  /// Zeigt Statistiken (Punkte, Marktwert)
  final bool showStats;

  /// Kompakte Darstellung
  final bool compact;

  /// Zeigt Trend-Icon
  final bool showTrend;

  /// Custom Elevation
  final double? elevation;

  const PlayerCard({
    required this.player,
    this.onTap,
    this.showStats = true,
    this.compact = false,
    this.showTrend = true,
    this.elevation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: elevation ?? 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Row(
            children: [
              // Spieler-Bild
              _buildPlayerImage(),
              const SizedBox(width: 16),

              // Spieler-Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    Text(
                      '${player.firstName} ${player.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Team & Position
                    Row(
                      children: [
                        Icon(
                          _getPositionIcon(player.position),
                          size: 16,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            player.teamName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Statistiken (optional)
                    if (showStats && !compact) ...[
                      const SizedBox(height: 8),
                      _buildStats(context),
                    ],
                  ],
                ),
              ),

              // Trend-Icon (optional)
              if (showTrend && player.marketValueTrend != 0)
                _buildTrendIcon(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Spieler-Bild mit Fallback
  Widget _buildPlayerImage() {
    return Container(
      width: compact ? 48 : 60,
      height: compact ? 48 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: _isValidHttpUrl(player.profileBigUrl)
            ? DecorationImage(
                image: NetworkImage(player.profileBigUrl),
                fit: BoxFit.cover,
                onError: (_, __) {},
              )
            : null,
        color: Colors.grey[300],
      ),
      child: !_isValidHttpUrl(player.profileBigUrl)
          ? Icon(Icons.person, size: compact ? 24 : 30, color: Colors.grey[600])
          : null,
    );
  }

  /// Statistiken-Anzeige
  Widget _buildStats(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildStatChip(
          context,
          icon: Icons.emoji_events,
          label: '${player.averagePoints.toStringAsFixed(1)} Ø',
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          context,
          icon: Icons.euro,
          label: _formatCurrency(player.marketValue),
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }

  /// Stat Chip Widget
  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Trend-Icon (Auf-/Abwärtspfeil)
  Widget _buildTrendIcon(ColorScheme colorScheme) {
    final isUp = player.marketValueTrend > 0;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isUp ? Colors.green : Colors.red).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUp ? Icons.trending_up : Icons.trending_down,
        size: 20,
        color: isUp ? Colors.green : Colors.red,
      ),
    );
  }

  /// Gibt das Icon für die Position zurück
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

  /// Formatiert Währung (z.B. 5.5M, 500K)
  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toString();
  }

  /// Überprüft, ob eine URL gültig für NetworkImage ist
  bool _isValidHttpUrl(String url) {
    if (url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }
}
