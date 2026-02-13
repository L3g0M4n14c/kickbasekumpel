import 'package:flutter/material.dart';

/// App Theme Configuration
///
/// Zentrales Theme-System für die gesamte App mit Material Design 3.
class AppTheme {
  // Seed Color
  static const Color _seedColor = Color(0xFF6366F1); // Indigo

  // Custom Semantic Colors
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);

  // ==================== Color Schemes ====================

  /// Light Mode Color Scheme
  static ColorScheme _lightColorScheme() =>
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light);

  /// Dark Mode Color Scheme
  static ColorScheme _darkColorScheme() =>
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark);

  // ==================== Typography ====================

  /// Text Theme mit Roboto Font
  static TextTheme _textTheme(ColorScheme colorScheme) => TextTheme(
    // Display Styles
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),

    // Headline Styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),

    // Title Styles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.27,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),

    // Body Styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      fontFamily: 'Roboto',
      color: colorScheme.onSurfaceVariant,
    ),

    // Label Styles
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
  );

  // ==================== Component Themes ====================

  /// AppBar Theme
  static AppBarTheme _appBarTheme(ColorScheme colorScheme) => AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 3,
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    surfaceTintColor: colorScheme.surfaceTint,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
      color: colorScheme.onSurface,
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
  );

  /// Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData _bottomNavTheme(
    ColorScheme colorScheme,
  ) => BottomNavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: colorScheme.onSurfaceVariant,
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 3,
  );

  /// Card Theme
  static CardThemeData _cardTheme(ColorScheme colorScheme) => CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    clipBehavior: Clip.antiAlias,
    color: colorScheme.surface,
    surfaceTintColor: colorScheme.surfaceTint,
  );

  /// Filled Button Theme
  static FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 40),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontFamily: 'Roboto',
          ),
        ),
      );

  /// Outlined Button Theme
  static OutlinedButtonThemeData _outlinedButtonTheme(
    ColorScheme colorScheme,
  ) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(64, 40),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: colorScheme.outline),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        fontFamily: 'Roboto',
      ),
    ),
  );

  /// Text Button Theme
  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontFamily: 'Roboto',
          ),
        ),
      );

  /// Input Decoration Theme
  static InputDecorationTheme _inputTheme(ColorScheme colorScheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        errorStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.error,
        ),
      );

  /// Dialog Theme
  static DialogThemeData _dialogTheme(ColorScheme colorScheme) =>
      DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant,
        ),
      );

  /// Floating Action Button Theme
  static FloatingActionButtonThemeData _fabTheme(ColorScheme colorScheme) =>
      FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  /// Chip Theme
  static ChipThemeData _chipTheme(ColorScheme colorScheme) => ChipThemeData(
    backgroundColor: colorScheme.surfaceContainerHighest,
    deleteIconColor: colorScheme.onSurfaceVariant,
    disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
    selectedColor: colorScheme.secondaryContainer,
    secondarySelectedColor: colorScheme.secondaryContainer,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      color: colorScheme.onSurfaceVariant,
    ),
    secondaryLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      color: colorScheme.onSecondaryContainer,
    ),
    brightness: colorScheme.brightness,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // ==================== Main Theme Definitions ====================

  /// Light Theme
  static ThemeData lightTheme() {
    final colorScheme = _lightColorScheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      fontFamily: 'Roboto',

      // Typography
      textTheme: _textTheme(colorScheme),

      // Component Themes
      appBarTheme: _appBarTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),

      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),

      // Navigation Rail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          color: colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minVerticalPadding: 12,
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  /// Dark Theme
  static ThemeData darkTheme() {
    final colorScheme = _darkColorScheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',

      // Typography
      textTheme: _textTheme(colorScheme),

      // Component Themes
      appBarTheme: _appBarTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),

      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),

      // Navigation Rail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          color: colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minVerticalPadding: 12,
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

// ==================== Custom Extensions ====================

/// Theme Extension für einfachen Zugriff auf Theme-Farben
extension ThemeExtension on BuildContext {
  /// Aktuelles Theme
  ThemeData get theme => Theme.of(this);

  /// Aktuelles ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Aktuelles TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Primary Color
  Color get primaryColor => colorScheme.primary;

  /// Secondary Color
  Color get secondaryColor => colorScheme.secondary;

  /// Error Color
  Color get errorColor => colorScheme.error;

  /// Success Color
  Color get successColor => Theme.of(this).brightness == Brightness.light
      ? AppTheme.successLight
      : AppTheme.successDark;

  /// Warning Color
  Color get warningColor => Theme.of(this).brightness == Brightness.light
      ? AppTheme.warningLight
      : AppTheme.warningDark;

  /// Surface Color
  Color get surfaceColor => colorScheme.surface;

  /// Background Color
  Color get backgroundColor => colorScheme.surface;

  /// On Primary Color
  Color get onPrimaryColor => colorScheme.onPrimary;

  /// On Surface Color
  Color get onSurfaceColor => colorScheme.onSurface;

  /// Ist Dark Mode aktiv?
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

// ==================== Custom Spacing Constants ====================

/// Spacing Constants für konsistente Abstände
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border Radius Constants
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static const double full = 999.0;
}

/// Elevation Constants
class AppElevation {
  AppElevation._();

  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 3.0;
  static const double lg = 6.0;
  static const double xl = 8.0;
}
