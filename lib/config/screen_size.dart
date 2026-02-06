import 'package:flutter/widgets.dart';

/// Screen size breakpoints and utility methods for responsive design
class ScreenSize {
  /// Mobile breakpoint: screens smaller than 600dp
  static const double mobileMaxWidth = 600;

  /// Tablet breakpoint: screens between 600dp and 1200dp
  static const double tabletMaxWidth = 1200;

  /// Check if current screen is mobile size
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  /// Check if current screen is tablet size
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  /// Check if current screen is desktop size
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  /// Get the current screen type
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMaxWidth) return ScreenType.mobile;
    if (width < tabletMaxWidth) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  /// Get appropriate number of columns based on screen size
  static int getGridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get appropriate horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Get appropriate card width based on screen size
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isMobile(context)) return width - 32;
    if (isTablet(context)) return 400;
    return 450;
  }

  /// Get appropriate font size multiplier based on screen size
  static double getFontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 1.1;
    return 1.2;
  }
}

/// Enum representing different screen types
enum ScreenType { mobile, tablet, desktop }

/// Extension on BuildContext for easier access to screen size utilities
extension ScreenSizeExtension on BuildContext {
  bool get isMobile => ScreenSize.isMobile(this);
  bool get isTablet => ScreenSize.isTablet(this);
  bool get isDesktop => ScreenSize.isDesktop(this);
  ScreenType get screenType => ScreenSize.getScreenType(this);
  double get horizontalPadding => ScreenSize.getHorizontalPadding(this);
  double get cardWidth => ScreenSize.getCardWidth(this);
  double get fontSizeMultiplier => ScreenSize.getFontSizeMultiplier(this);
}
