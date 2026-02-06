import 'package:flutter/material.dart';

/// Action Button für KickbaseKumpel
///
/// Wiederverwendbarer Button mit verschiedenen Stilen und Zuständen.
///
/// **Verwendung:**
/// ```dart
/// ActionButton(
///   label: 'Spieler kaufen',
///   onPressed: () => // Handle action
///   style: ActionButtonStyle.filled,
///   icon: Icons.shopping_cart,
/// )
/// ```
class ActionButton extends StatelessWidget {
  /// Button-Label
  final String label;

  /// Callback wenn gedrückt
  final VoidCallback? onPressed;

  /// Button-Style
  final ActionButtonStyle style;

  /// Leading Icon (optional)
  final IconData? icon;

  /// Loading-Zustand
  final bool isLoading;

  /// Full-Width Button
  final bool fullWidth;

  const ActionButton({
    required this.label,
    this.onPressed,
    this.style = ActionButtonStyle.filled,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (style) {
      case ActionButtonStyle.filled:
        button = _buildFilledButton(context);
        break;
      case ActionButtonStyle.outlined:
        button = _buildOutlinedButton(context);
        break;
      case ActionButtonStyle.text:
        button = _buildTextButton(context);
        break;
      case ActionButtonStyle.tonal:
        button = _buildTonalButton(context);
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildFilledButton(BuildContext context) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? _loadingIndicator() : Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _loadingIndicator() : Text(label),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? _loadingIndicator() : Icon(icon),
        label: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _loadingIndicator() : Text(label),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? _loadingIndicator() : Icon(icon),
        label: Text(label),
      );
    }
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _loadingIndicator() : Text(label),
    );
  }

  Widget _buildTonalButton(BuildContext context) {
    if (icon != null) {
      return FilledButton.tonalIcon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? _loadingIndicator() : Icon(icon),
        label: Text(label),
      );
    }
    return FilledButton.tonal(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _loadingIndicator() : Text(label),
    );
  }

  Widget _loadingIndicator() {
    return const SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

/// Action Button Style
enum ActionButtonStyle { filled, outlined, text, tonal }

/// Icon Action Button (nur Icon, kein Text)
class IconActionButton extends StatelessWidget {
  /// Icon
  final IconData icon;

  /// Callback wenn gedrückt
  final VoidCallback? onPressed;

  /// Tooltip
  final String? tooltip;

  /// Button-Style
  final ActionButtonStyle style;

  const IconActionButton({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.style = ActionButtonStyle.filled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (style) {
      case ActionButtonStyle.filled:
        button = FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(12),
            minimumSize: const Size(48, 48),
          ),
          child: Icon(icon),
        );
        break;
      case ActionButtonStyle.outlined:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            minimumSize: const Size(48, 48),
          ),
          child: Icon(icon),
        );
        break;
      case ActionButtonStyle.text:
      case ActionButtonStyle.tonal:
        button = IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          tooltip: tooltip,
        );
        break;
    }

    if (tooltip != null &&
        style != ActionButtonStyle.text &&
        style != ActionButtonStyle.tonal) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
