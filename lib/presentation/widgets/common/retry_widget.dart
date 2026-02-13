import 'package:flutter/material.dart';

/// Retry Widget für KickbaseKumpel
///
/// Widget für Fehler mit Retry-Funktion (vereinfacht).
///
/// **Verwendung:**
/// ```dart
/// RetryWidget(
///   message: 'Laden fehlgeschlagen',
///   onRetry: () => // Retry action
/// )
/// ```
class RetryWidget extends StatelessWidget {
  /// Fehler-Nachricht
  final String message;

  /// Retry-Callback
  final VoidCallback onRetry;

  /// Optionale Detail-Nachricht
  final String? details;

  /// Custom Icon
  final IconData? icon;

  const RetryWidget({
    required this.message,
    required this.onRetry,
    this.details,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              icon ?? Icons.refresh,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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

            const SizedBox(height: 24),

            // Retry Button
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline Retry Widget (für kleine Bereiche)
class InlineRetryWidget extends StatelessWidget {
  /// Fehler-Nachricht
  final String message;

  /// Retry-Callback
  final VoidCallback onRetry;

  const InlineRetryWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Wiederholen'),
          ),
        ],
      ),
    );
  }
}
