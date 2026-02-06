import 'package:flutter/material.dart';

/// Empty State Widget für KickbaseKumpel
///
/// Widget für leere Zustände (keine Daten vorhanden).
///
/// **Verwendung:**
/// ```dart
/// EmptyStateWidget(
///   message: 'Keine Spieler gefunden',
///   icon: Icons.people_outline,
///   actionLabel: 'Spieler hinzufügen',
///   onAction: () => // Add player
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// Haupt-Nachricht
  final String message;

  /// Optionale Detail-Nachricht
  final String? details;

  /// Icon
  final IconData icon;

  /// Action-Button Label (optional)
  final String? actionLabel;

  /// Action-Button Callback (optional)
  final VoidCallback? onAction;

  /// Compact-Modus
  final bool compact;

  const EmptyStateWidget({
    required this.message,
    required this.icon,
    this.details,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(compact ? 20 : 32),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: compact ? 56 : 80,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
            SizedBox(height: compact ? 16 : 24),

            // Message
            Text(
              message,
              style:
                  (compact
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleLarge)
                      ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Details (optional)
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button (optional)
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? 16 : 24),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// No Results Widget (für Such-Ergebnisse)
class NoResultsWidget extends StatelessWidget {
  /// Such-Query
  final String? searchQuery;

  /// Callback zum Löschen der Suche
  final VoidCallback? onClear;

  const NoResultsWidget({this.searchQuery, this.onClear, super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: 'Keine Ergebnisse',
      details: searchQuery != null
          ? 'Für "$searchQuery" wurden keine Ergebnisse gefunden.'
          : 'Versuche es mit anderen Suchbegriffen.',
      icon: Icons.search_off,
      actionLabel: onClear != null ? 'Suche löschen' : null,
      onAction: onClear,
    );
  }
}

/// No Data Widget (für Listen ohne Daten)
class NoDataWidget extends StatelessWidget {
  /// Daten-Typ (z.B. "Spieler", "Ligen")
  final String dataType;

  /// Callback zum Hinzufügen
  final VoidCallback? onAdd;

  const NoDataWidget({required this.dataType, this.onAdd, super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: 'Keine $dataType',
      details: 'Es sind noch keine $dataType vorhanden.',
      icon: Icons.inbox_outlined,
      actionLabel: onAdd != null ? '$dataType hinzufügen' : null,
      onAction: onAdd,
    );
  }
}
