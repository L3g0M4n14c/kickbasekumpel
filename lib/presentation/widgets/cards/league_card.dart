import 'package:flutter/material.dart';
import '../../../data/models/league_model.dart';

/// League Card Widget für KickbaseKumpel
///
/// Zeigt eine Liga mit Name, Teilnehmern und aktueller Platzierung.
///
/// **Verwendung:**
/// ```dart
/// LeagueCard(
///   league: league,
///   onTap: () => Navigator.push(...),
///   showDetails: true,
/// )
/// ```
class LeagueCard extends StatelessWidget {
  /// Liga-Objekt
  final League league;

  /// Callback wenn Karte getippt wird
  final VoidCallback? onTap;

  /// Zeigt Details (Platzierung, Punkte)
  final bool showDetails;

  /// Custom Elevation
  final double? elevation;

  const LeagueCard({
    required this.league,
    this.onTap,
    this.showDetails = true,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Liga-Name
              Row(
                children: [
                  // Liga-Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 24,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Liga-Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          league.n,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Spieltag ${league.md}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pfeil-Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),

              // Details (optional)
              if (showDetails) ...[
                const SizedBox(height: 16),
                Divider(color: colorScheme.outlineVariant),
                const SizedBox(height: 16),
                _buildDetails(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Details-Bereich mit Statistiken
  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);
    final user = league.cu;
    final placement = user.placement;
    final points = user.points;
    final teamValue = user.teamValue;

    return Row(
      children: [
        // Platzierung
        Expanded(
          child: _buildDetailItem(
            context,
            icon: Icons.stars,
            label: 'Platz',
            value: '#$placement',
            color: _getPlacementColor(placement),
          ),
        ),

        // Punkte
        Expanded(
          child: _buildDetailItem(
            context,
            icon: Icons.emoji_events,
            label: 'Punkte',
            value: '$points',
            color: theme.colorScheme.primary,
          ),
        ),

        // Teamwert
        Expanded(
          child: _buildDetailItem(
            context,
            icon: Icons.euro,
            label: 'Teamwert',
            value: _formatCurrency(teamValue),
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  /// Detail-Item Widget
  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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
