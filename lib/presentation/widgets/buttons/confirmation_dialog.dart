import 'package:flutter/material.dart';

/// Confirmation Dialog für KickbaseKumpel
///
/// Wiederverwendbarer Bestätigungs-Dialog mit anpassbaren Aktionen.
///
/// **Verwendung:**
/// ```dart
/// await showConfirmationDialog(
///   context: context,
///   title: 'Spieler verkaufen?',
///   message: 'Möchtest du Max Mustermann wirklich verkaufen?',
///   confirmText: 'Verkaufen',
///   onConfirm: () => // Handle confirm
/// );
/// ```
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Bestätigen',
  String cancelText = 'Abbrechen',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool isDangerous = false,
  IconData? icon,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: isDangerous,
      icon: icon,
    ),
  );
}

/// Confirmation Dialog Widget
class ConfirmationDialog extends StatelessWidget {
  /// Dialog-Titel
  final String title;

  /// Dialog-Nachricht
  final String message;

  /// Bestätigen-Text
  final String confirmText;

  /// Abbrechen-Text
  final String cancelText;

  /// Bestätigen-Callback
  final VoidCallback? onConfirm;

  /// Abbrechen-Callback
  final VoidCallback? onCancel;

  /// Gefährliche Aktion (z.B. Löschen)
  final bool isDangerous;

  /// Optional Icon
  final IconData? icon;

  const ConfirmationDialog({
    required this.title,
    required this.message,
    this.confirmText = 'Bestätigen',
    this.cancelText = 'Abbrechen',
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      icon: icon != null
          ? Icon(
              icon,
              size: 32,
              color: isDangerous ? colorScheme.error : colorScheme.primary,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        // Abbrechen-Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),

        // Bestätigen-Button
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: isDangerous
              ? FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Info Dialog (nur Information, kein Confirm)
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
  IconData? icon,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: icon != null
          ? Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary)
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}

/// Error Dialog
Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.error_outline,
        size: 32,
        color: Theme.of(context).colorScheme.error,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}

/// Success Dialog
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(
        Icons.check_circle_outline,
        size: 32,
        color: Colors.green,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}

/// Bottom Sheet Alternative (für längere Inhalte)
Future<bool?> showConfirmationBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Bestätigen',
  String cancelText = 'Abbrechen',
  VoidCallback? onConfirm,
  bool isDangerous = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(message, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(cancelText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm?.call();
                      },
                      style: isDangerous
                          ? FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                            )
                          : null,
                      child: Text(confirmText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
