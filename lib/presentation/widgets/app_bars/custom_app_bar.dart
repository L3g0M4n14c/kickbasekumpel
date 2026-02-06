import 'package:flutter/material.dart';

/// Custom AppBar für KickbaseKumpel mit Material Design 3
///
/// Bietet ein konsistentes AppBar-Design mit optionalen Aktionen,
/// Dark Mode Support und anpassbaren Parametern.
///
/// **Verwendung:**
/// ```dart
/// CustomAppBar(
///   title: 'Meine Liga',
///   showBackButton: true,
///   actions: [
///     IconButton(
///       icon: Icon(Icons.settings),
///       onPressed: () => // Navigate to settings
///     ),
///   ],
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Titel der AppBar
  final String title;

  /// Optionale Aktionen in der AppBar (z.B. Settings-Button)
  final List<Widget>? actions;

  /// Zeigt einen Zurück-Button an
  final bool showBackButton;

  /// Custom Leading Widget (überschreibt showBackButton)
  final Widget? leading;

  /// Callback wenn Zurück-Button gedrückt wird
  final VoidCallback? onBackPressed;

  /// Hintergrundfarbe (null = Theme-Farbe)
  final Color? backgroundColor;

  /// Center-Alignment des Titels
  final bool centerTitle;

  /// Elevation (Höhe) der AppBar
  final double? elevation;

  const CustomAppBar({
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.leading,
    this.onBackPressed,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: 'Zurück',
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
