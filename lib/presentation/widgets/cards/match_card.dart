import 'package:flutter/material.dart';

/// Match Card Widget für KickbaseKumpel
///
/// Zeigt ein Spiel mit Teams, Ergebnis und Zeitpunkt.
///
/// **Verwendung:**
/// ```dart
/// MatchCard(
///   homeTeam: 'FC Bayern',
///   awayTeam: 'BVB',
///   homeScore: 3,
///   awayScore: 1,
///   kickoff: DateTime.now(),
///   isLive: false,
/// )
/// ```
class MatchCard extends StatelessWidget {
  /// Name Heimteam
  final String homeTeam;

  /// Name Auswärtsteam
  final String awayTeam;

  /// Tore Heimteam (null wenn nicht gespielt)
  final int? homeScore;

  /// Tore Auswärtsteam (null wenn nicht gespielt)
  final int? awayScore;

  /// Anstoß-Zeit
  final DateTime kickoff;

  /// Spiel läuft gerade
  final bool isLive;

  /// Spiel ist beendet
  final bool isFinished;

  /// Callback wenn Karte getippt wird
  final VoidCallback? onTap;

  const MatchCard({
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    this.homeScore,
    this.awayScore,
    this.isLive = false,
    this.isFinished = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status-Badge (Live/Beendet/Anstoß)
              if (isLive || isFinished) _buildStatusBadge(context),
              if (isLive || isFinished) const SizedBox(height: 12),

              // Teams & Ergebnis
              Row(
                children: [
                  // Heimteam
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeTeam,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Ergebnis oder Zeit
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isLive
                          ? Colors.red.withValues(alpha: 0.1)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: homeScore != null && awayScore != null
                        ? Text(
                            '$homeScore : $awayScore',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isLive
                                  ? Colors.red
                                  : colorScheme.onSurfaceVariant,
                            ),
                          )
                        : Text(
                            _formatKickoffTime(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),

                  // Auswärtsteam
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          awayTeam,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Datum (wenn nicht live)
              if (!isLive && !isFinished) ...[
                const SizedBox(height: 8),
                Text(
                  _formatKickoffDate(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Status-Badge (Live/Beendet)
  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLive ? Colors.red : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          if (isLive) const SizedBox(width: 6),
          Text(
            isLive ? 'LIVE' : 'Beendet',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Formatiert Anstoß-Zeit (HH:mm)
  String _formatKickoffTime() {
    final hour = kickoff.hour.toString().padLeft(2, '0');
    final minute = kickoff.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formatiert Anstoß-Datum
  String _formatKickoffDate() {
    final now = DateTime.now();
    final diff = kickoff.difference(now);

    if (diff.inDays == 0) {
      return 'Heute, ${_formatKickoffTime()} Uhr';
    } else if (diff.inDays == 1) {
      return 'Morgen, ${_formatKickoffTime()} Uhr';
    } else {
      return '${kickoff.day}.${kickoff.month}.${kickoff.year}, ${_formatKickoffTime()} Uhr';
    }
  }
}
