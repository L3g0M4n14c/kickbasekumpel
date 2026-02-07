import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  /// Background circle color (optional)
  final Color? backgroundColor;

  /// If true, the image is colorized using [tintColor].
  final bool tint;
  final Color? tintColor;

  /// If true, the image itself is circularly cropped to fit the container.
  final bool cropToCircle;

  /// Relative scale of the inner image compared to the outer size (0.0-1.0).
  /// A value closer to 1.0 fills the circle more; default is 0.9.
  final double scale;
  final String assetPath;

  const AppLogo({
    super.key,
    this.size = 48,
    this.backgroundColor,
    this.tint = false,
    this.tintColor,
    this.cropToCircle = true,
    this.scale = 0.9,
    this.assetPath = 'assets/images/logo/icon-1024.png',
  }) : assert(scale > 0 && scale <= 1);

  @override
  Widget build(BuildContext context) {
    final innerSize = size * scale;

    Widget image = Image.asset(
      assetPath,
      width: innerSize,
      height: innerSize,
      fit: BoxFit.cover,
      color: tint ? tintColor ?? Theme.of(context).colorScheme.primary : null,
      colorBlendMode: tint ? BlendMode.srcIn : null,
    );

    if (cropToCircle) {
      image = ClipOval(
        child: SizedBox(width: innerSize, height: innerSize, child: image),
      );
    } else {
      image = SizedBox(width: innerSize, height: innerSize, child: image);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: image,
        ),
      ),
    );
  }
}
