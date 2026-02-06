import 'package:flutter/material.dart';

/// Error Widget für KickbaseKumpel
///
/// Wiederverwendbares Widget für Fehler-Zustände mit Retry-Funktion.
///
/// **Verwendung:**
/// ```dart
/// ErrorWidget(
///   message: 'Fehler beim Laden der Spieler',
///   onRetry: () => // Retry action
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  /// Fehler-Nachricht
  final String message;

  /// Optionale Detail-Nachricht
  final String? details;

  /// Retry-Callback
  final VoidCallback? onRetry;

  /// Custom Icon
  final IconData? icon;

  /// Compact-Modus (kleinere Darstellung)
  final bool compact;

  const AppErrorWidget({
    required this.message,
    this.details,
    this.onRetry,
    this.icon,
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
            // Error Icon
            Container(
              padding: EdgeInsets.all(compact ? 16 : 24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: compact ? 48 : 64,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: compact ? 16 : 24),

            // Error Message
            Text(
              message,
              style:
                  (compact
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleLarge)
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                      ),
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

            // Retry Button
            if (onRetry != null) ...[
              SizedBox(height: compact ? 16 : 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline Error Widget (für kleine Bereiche)
class InlineErrorWidget extends StatelessWidget {
  /// Fehler-Nachricht
  final String message;

  /// Retry-Callback
  final VoidCallback? onRetry;

  const InlineErrorWidget({required this.message, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 20, color: colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: onRetry,
              tooltip: 'Erneut versuchen',
              color: colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}

/// Network Error Widget (speziell für Netzwerk-Fehler)
class NetworkErrorWidget extends StatelessWidget {
  /// Retry-Callback
  final VoidCallback? onRetry;

  const NetworkErrorWidget({this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: 'Keine Internetverbindung',
      details: 'Bitte überprüfe deine Verbindung und versuche es erneut.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}
