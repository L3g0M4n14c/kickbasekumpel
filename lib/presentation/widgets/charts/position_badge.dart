import 'package:flutter/material.dart';

/// Position Badge für KickbaseKumpel
///
/// Zeigt die Position eines Spielers als Badge.
///
/// **Verwendung:**
/// ```dart
/// PositionBadge(
///   position: 1, // Torwart
///   size: PositionBadgeSize.medium,
/// )
/// ```
class PositionBadge extends StatelessWidget {
  /// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
  final int position;

  /// Größe des Badges
  final PositionBadgeSize size;

  /// Zeigt Label (z.B. "TW")
  final bool showLabel;

  const PositionBadge({
    required this.position,
    this.size = PositionBadgeSize.medium,
    this.showLabel = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getPositionConfig(position);
    final dimensions = _getSizeDimensions();

    return Container(
      width: dimensions.size,
      height: dimensions.size,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        border: Border.all(color: config.color, width: dimensions.borderWidth),
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: showLabel
          ? Center(
              child: Text(
                config.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: config.color,
                  fontWeight: FontWeight.bold,
                  fontSize: dimensions.fontSize,
                ),
              ),
            )
          : Icon(config.icon, size: dimensions.iconSize, color: config.color),
    );
  }

  /// Konfiguration für Position
  _PositionConfig _getPositionConfig(int position) {
    switch (position) {
      case 1:
        return _PositionConfig(
          label: 'TW',
          icon: Icons.sports,
          color: Colors.blue,
        );
      case 2:
        return _PositionConfig(
          label: 'ABW',
          icon: Icons.shield,
          color: Colors.green,
        );
      case 3:
        return _PositionConfig(
          label: 'MF',
          icon: Icons.person,
          color: Colors.orange,
        );
      case 4:
        return _PositionConfig(
          label: 'ST',
          icon: Icons.flash_on,
          color: Colors.red,
        );
      default:
        return _PositionConfig(
          label: '?',
          icon: Icons.help,
          color: Colors.grey,
        );
    }
  }

  /// Dimensions basierend auf Größe
  _SizeDimensions _getSizeDimensions() {
    switch (size) {
      case PositionBadgeSize.small:
        return _SizeDimensions(
          size: 32,
          fontSize: 10,
          iconSize: 16,
          borderWidth: 1.5,
          borderRadius: 6,
        );
      case PositionBadgeSize.medium:
        return _SizeDimensions(
          size: 40,
          fontSize: 12,
          iconSize: 20,
          borderWidth: 2,
          borderRadius: 8,
        );
      case PositionBadgeSize.large:
        return _SizeDimensions(
          size: 56,
          fontSize: 14,
          iconSize: 28,
          borderWidth: 2.5,
          borderRadius: 10,
        );
    }
  }
}

/// Position Badge Größe
enum PositionBadgeSize { small, medium, large }

/// Position-Konfiguration
class _PositionConfig {
  final String label;
  final IconData icon;
  final Color color;

  _PositionConfig({
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// Größen-Dimensionen
class _SizeDimensions {
  final double size;
  final double fontSize;
  final double iconSize;
  final double borderWidth;
  final double borderRadius;

  _SizeDimensions({
    required this.size,
    required this.fontSize,
    required this.iconSize,
    required this.borderWidth,
    required this.borderRadius,
  });
}

/// Position Text Helper
String getPositionName(int position) {
  switch (position) {
    case 1:
      return 'Torwart';
    case 2:
      return 'Abwehr';
    case 3:
      return 'Mittelfeld';
    case 4:
      return 'Sturm';
    default:
      return 'Unbekannt';
  }
}
