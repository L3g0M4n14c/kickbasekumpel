import 'package:flutter/material.dart';

/// Loading Widget für KickbaseKumpel
///
/// Wiederverwendbares Widget für Lade-Zustände mit verschiedenen Stilen.
///
/// **Verwendung:**
/// ```dart
/// LoadingWidget(
///   message: 'Lade Spieler...',
///   size: LoadingSize.large,
/// )
/// ```
class LoadingWidget extends StatelessWidget {
  /// Lade-Nachricht (optional)
  final String? message;

  /// Größe des Loading-Indikators
  final LoadingSize size;

  /// Custom Farbe
  final Color? color;

  const LoadingWidget({
    this.message,
    this.size = LoadingSize.medium,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorSize = _getIndicatorSize();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: size == LoadingSize.small ? 2 : 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  double _getIndicatorSize() {
    switch (size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 40;
      case LoadingSize.large:
        return 56;
    }
  }
}

/// Größe des Loading-Indikators
enum LoadingSize { small, medium, large }

/// Inline Loading Widget (für kleine Bereiche)
class InlineLoadingWidget extends StatelessWidget {
  /// Nachricht neben dem Indikator
  final String? message;

  const InlineLoadingWidget({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(width: 12),
          Text(
            message!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Shimmer Loading Widget (für Skeleton Screens)
class ShimmerLoadingWidget extends StatefulWidget {
  /// Breite des Shimmer-Elements
  final double width;

  /// Höhe des Shimmer-Elements
  final double height;

  /// Border-Radius
  final double borderRadius;

  const ShimmerLoadingWidget({
    required this.width,
    required this.height,
    this.borderRadius = 8,
    super.key,
  });

  @override
  State<ShimmerLoadingWidget> createState() => _ShimmerLoadingWidgetState();
}

class _ShimmerLoadingWidgetState extends State<ShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [Colors.grey[800]!, Colors.grey[700]!, Colors.grey[800]!]
                  : [Colors.grey[300]!, Colors.grey[200]!, Colors.grey[300]!],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}
