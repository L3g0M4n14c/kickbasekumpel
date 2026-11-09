import 'package:flutter/material.dart';

/// Zentrales Design-System „Anstoß“.
///
/// Farbkonzept (Komplementär-Paar Blau/Orange nach der 60-30-10-Regel):
/// - **60 % neutrale Flächen**: echte Grautöne mit nur minimalem Kühl-Stich
///   (Chroma nahe null). Getönte Neutraltöne färben die ganze App ein – das
///   war beim grünen Vorgänger „Sommerrasen“ der Hauptgrund für den Grünstich.
/// - **30 % Primärfarbe Stadionblau**: Buttons, Fokus, Tabs, Fortschritt.
///   Blau ist für das Auge am ruhigsten und kollidiert nicht mit den
///   Bedeutungsfarben.
/// - **10 % Akzent Apricot/Orange** (Komplementärfarbe zu Blau): Navigation,
///   ausgewählte Chips, FAB – also nur dort, wo der Blick hin soll.
/// - **Grün und Rot bleiben reserviert** für Bedeutung (Gewinn/Verlust,
///   Marktwert steigt/fällt) sowie Spielfeld und Mittelfeld-Position. Wäre
///   Grün zugleich Markenfarbe, ließe sich „positiv“ nicht mehr von „Knopf“
///   unterscheiden.
///
/// Alle Text/Hintergrund-Paare erfüllen WCAG AA (≥ 4,5:1), Konturen ≥ 3:1.
/// Die Farbschemata sind handverlesen (kein `ColorScheme.fromSeed`), dazu die
/// runde Hausschrift Nunito.
class AppTheme {
  AppTheme._();

  /// Hausschrift (als Asset in `pubspec.yaml` registriert).
  static const String fontFamily = 'Nunito';

  // Semantische Zusatzfarben (Abwärtskompatibilität)
  static const Color successLight = AppColors.successLight;
  static const Color successDark = AppColors.successDark;
  static const Color warningLight = AppColors.warningLight;
  static const Color warningDark = AppColors.warningDark;

  // ==================== Color Schemes ====================

  /// Helles Farbschema: Stadionblau auf neutralem Hellgrau.
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Stadionblau
    primary: Color(0xFF2B57D6),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDCE4FF),
    onPrimaryContainer: Color(0xFF0A1E5C),
    primaryFixed: Color(0xFFDCE4FF),
    primaryFixedDim: Color(0xFFB3C5FF),
    onPrimaryFixed: Color(0xFF0A1E5C),
    onPrimaryFixedVariant: Color(0xFF1D3FA6),
    // Apricot-Akzent (Komplementär zu Blau), Text in lesbarem Rostorange
    secondary: Color(0xFFA84A00),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFD7AE),
    onSecondaryContainer: Color(0xFF331600),
    secondaryFixed: Color(0xFFFFDCC0),
    secondaryFixedDim: Color(0xFFFFB877),
    onSecondaryFixed: Color(0xFF331600),
    onSecondaryFixedVariant: Color(0xFF7A3600),
    // Violett für Infos (analog zu Blau, beißt sich nicht mit Grün/Rot)
    tertiary: Color(0xFF6A4FC4),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE9DDFF),
    onTertiaryContainer: Color(0xFF22005D),
    tertiaryFixed: Color(0xFFE9DDFF),
    tertiaryFixedDim: Color(0xFFCFBCFF),
    onTertiaryFixed: Color(0xFF22005D),
    onTertiaryFixedVariant: Color(0xFF5136A8),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    // Neutrale Flächen (kein Grün-, kein Gelbstich)
    surface: Color(0xFFF6F7F9),
    onSurface: Color(0xFF1A1C21),
    onSurfaceVariant: Color(0xFF545A66),
    surfaceDim: Color(0xFFD8DAE0),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF1F3F6),
    surfaceContainer: Color(0xFFECEEF2),
    surfaceContainerHigh: Color(0xFFE6E8ED),
    surfaceContainerHighest: Color(0xFFE0E3E8),
    outline: Color(0xFF7C828E),
    outlineVariant: Color(0xFFDCDFE5),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2E3036),
    onInverseSurface: Color(0xFFF0F1F5),
    inversePrimary: Color(0xFFAFC4FF),
    surfaceTint: Color(0x00000000),
  );

  /// Dunkles Farbschema: neutrales Anthrazit mit hellem Blau und Apricot.
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFAFC4FF),
    onPrimary: Color(0xFF0B2A78),
    primaryContainer: Color(0xFF24439E),
    onPrimaryContainer: Color(0xFFDCE4FF),
    primaryFixed: Color(0xFFDCE4FF),
    primaryFixedDim: Color(0xFFB3C5FF),
    onPrimaryFixed: Color(0xFF0A1E5C),
    onPrimaryFixedVariant: Color(0xFF1D3FA6),
    secondary: Color(0xFFFFB877),
    onSecondary: Color(0xFF4A2200),
    secondaryContainer: Color(0xFFFFB366),
    onSecondaryContainer: Color(0xFF2E1400),
    secondaryFixed: Color(0xFFFFDCC0),
    secondaryFixedDim: Color(0xFFFFB877),
    onSecondaryFixed: Color(0xFF331600),
    onSecondaryFixedVariant: Color(0xFF7A3600),
    tertiary: Color(0xFFCFBCFF),
    onTertiary: Color(0xFF381E8C),
    tertiaryContainer: Color(0xFF5136A8),
    onTertiaryContainer: Color(0xFFE9DDFF),
    tertiaryFixed: Color(0xFFE9DDFF),
    tertiaryFixedDim: Color(0xFFCFBCFF),
    onTertiaryFixed: Color(0xFF22005D),
    onTertiaryFixedVariant: Color(0xFF5136A8),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    // Neutrales Anthrazit statt Tannengrün
    surface: Color(0xFF111318),
    onSurface: Color(0xFFE3E5EB),
    onSurfaceVariant: Color(0xFFADB2BD),
    surfaceDim: Color(0xFF111318),
    surfaceBright: Color(0xFF37393F),
    surfaceContainerLowest: Color(0xFF0C0E12),
    surfaceContainerLow: Color(0xFF191C22),
    surfaceContainer: Color(0xFF1D2026),
    surfaceContainerHigh: Color(0xFF272A31),
    surfaceContainerHighest: Color(0xFF32353C),
    outline: Color(0xFF7A808B),
    outlineVariant: Color(0xFF3A3E47),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE3E5EB),
    onInverseSurface: Color(0xFF2E3036),
    inversePrimary: Color(0xFF2B57D6),
    surfaceTint: Color(0x00000000),
  );

  // ==================== Typography ====================

  static TextStyle _style(
    double size,
    FontWeight weight,
    double height,
    Color color, {
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
  );

  /// Text-Theme: kräftige, runde Überschriften, gut lesbarer Fließtext.
  static TextTheme _textTheme(ColorScheme c) => TextTheme(
    displayLarge: _style(
      57,
      FontWeight.w900,
      1.12,
      c.onSurface,
      letterSpacing: -1,
    ),
    displayMedium: _style(
      45,
      FontWeight.w900,
      1.16,
      c.onSurface,
      letterSpacing: -0.5,
    ),
    displaySmall: _style(36, FontWeight.w800, 1.22, c.onSurface),
    headlineLarge: _style(32, FontWeight.w800, 1.25, c.onSurface),
    headlineMedium: _style(28, FontWeight.w800, 1.29, c.onSurface),
    headlineSmall: _style(24, FontWeight.w800, 1.33, c.onSurface),
    titleLarge: _style(22, FontWeight.w800, 1.27, c.onSurface),
    titleMedium: _style(16, FontWeight.w700, 1.5, c.onSurface),
    titleSmall: _style(14, FontWeight.w700, 1.43, c.onSurface),
    bodyLarge: _style(16, FontWeight.w400, 1.5, c.onSurface),
    bodyMedium: _style(14, FontWeight.w400, 1.43, c.onSurface),
    bodySmall: _style(12, FontWeight.w600, 1.33, c.onSurfaceVariant),
    labelLarge: _style(14, FontWeight.w700, 1.43, c.onSurface),
    labelMedium: _style(12, FontWeight.w700, 1.33, c.onSurface),
    labelSmall: _style(
      11,
      FontWeight.w700,
      1.45,
      c.onSurface,
      letterSpacing: 0.3,
    ),
  );

  // ==================== Component Themes ====================

  static const _stadium = StadiumBorder();

  static RoundedRectangleBorder _rounded(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  static const _buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.1,
  );

  static AppBarTheme _appBarTheme(ColorScheme c) => AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: c.surface,
    foregroundColor: c.onSurface,
    surfaceTintColor: Colors.transparent,
    titleSpacing: 20,
    titleTextStyle: _style(22, FontWeight.w900, 1.2, c.onSurface),
    iconTheme: IconThemeData(color: c.onSurface),
    actionsIconTheme: IconThemeData(color: c.onSurfaceVariant),
  );

  static NavigationBarThemeData _navigationBarTheme(ColorScheme c) =>
      NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: c.brightness == Brightness.light
            ? c.surfaceContainerLowest
            : c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        indicatorColor: c.secondaryContainer,
        indicatorShape: _stadium,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? c.onSecondaryContainer
                : c.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => _style(
            12,
            states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            1.3,
            states.contains(WidgetState.selected)
                ? c.onSurface
                : c.onSurfaceVariant,
          ),
        ),
      );

  static NavigationRailThemeData _navigationRailTheme(ColorScheme c) =>
      NavigationRailThemeData(
        backgroundColor: c.brightness == Brightness.light
            ? c.surfaceContainerLowest
            : c.surfaceContainerLow,
        indicatorColor: c.secondaryContainer,
        indicatorShape: _stadium,
        selectedIconTheme: IconThemeData(color: c.onSecondaryContainer),
        unselectedIconTheme: IconThemeData(color: c.onSurfaceVariant),
        selectedLabelTextStyle: _style(13, FontWeight.w800, 1.3, c.onSurface),
        unselectedLabelTextStyle: _style(
          13,
          FontWeight.w600,
          1.3,
          c.onSurfaceVariant,
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme(ColorScheme c) =>
      BottomNavigationBarThemeData(
        backgroundColor: c.surfaceContainerLowest,
        selectedItemColor: c.primary,
        unselectedItemColor: c.onSurfaceVariant,
        selectedLabelStyle: _style(12, FontWeight.w800, 1.3, c.primary),
        unselectedLabelStyle: _style(
          12,
          FontWeight.w600,
          1.3,
          c.onSurfaceVariant,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      );

  /// Karten: flach, großzügig gerundet, mit feiner neutraler Kontur.
  static CardThemeData _cardTheme(ColorScheme c) => CardThemeData(
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
    color: c.brightness == Brightness.light
        ? c.surfaceContainerLowest
        : c.surfaceContainerLow,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      side: BorderSide(color: c.outlineVariant),
    ),
  );

  static FilledButtonThemeData _filledButtonTheme(ColorScheme c) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: _stadium,
          textStyle: _buttonText,
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme c) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: _stadium,
          elevation: 0,
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          textStyle: _buttonText,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme c) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: _stadium,
          side: BorderSide(color: c.outline, width: 1.5),
          textStyle: _buttonText,
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme c) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: _stadium,
          textStyle: _buttonText,
        ),
      );

  static SegmentedButtonThemeData _segmentedButtonTheme(ColorScheme c) =>
      SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: const WidgetStatePropertyAll(_stadium),
          side: WidgetStatePropertyAll(BorderSide(color: c.outlineVariant)),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

  /// Eingabefelder: weich gefüllt, ohne harte Kontur, blauer Fokus.
  static InputDecorationTheme _inputTheme(ColorScheme c) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      filled: true,
      fillColor: c.brightness == Brightness.light
          ? c.surfaceContainerLowest
          : c.surfaceContainerHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: border(c.outlineVariant),
      enabledBorder: border(c.outlineVariant),
      focusedBorder: border(c.primary, 2),
      errorBorder: border(c.error),
      focusedErrorBorder: border(c.error, 2),
      prefixIconColor: c.onSurfaceVariant,
      suffixIconColor: c.onSurfaceVariant,
      labelStyle: _style(16, FontWeight.w600, 1.4, c.onSurfaceVariant),
      floatingLabelStyle: _style(16, FontWeight.w700, 1.4, c.primary),
      hintStyle: _style(
        16,
        FontWeight.w400,
        1.4,
        c.onSurfaceVariant.withValues(alpha: 0.7),
      ),
      errorStyle: _style(12, FontWeight.w600, 1.3, c.error),
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme c) => DialogThemeData(
    backgroundColor: c.brightness == Brightness.light
        ? c.surfaceContainerLowest
        : c.surfaceContainerHigh,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: _rounded(AppRadius.xxl),
    titleTextStyle: _style(22, FontWeight.w800, 1.3, c.onSurface),
    contentTextStyle: _style(15, FontWeight.w400, 1.45, c.onSurfaceVariant),
  );

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme c) =>
      BottomSheetThemeData(
        backgroundColor: c.brightness == Brightness.light
            ? c.surfaceContainerLowest
            : c.surfaceContainerLow,
        modalBackgroundColor: c.brightness == Brightness.light
            ? c.surfaceContainerLowest
            : c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
      );

  /// FAB im Apricot-Akzent – der auffälligste Knopf der App.
  static FloatingActionButtonThemeData _fabTheme(ColorScheme c) =>
      FloatingActionButtonThemeData(
        backgroundColor: c.secondaryContainer,
        foregroundColor: c.onSecondaryContainer,
        elevation: 2,
        focusElevation: 2,
        hoverElevation: 4,
        highlightElevation: 2,
        shape: _rounded(AppRadius.xl),
        extendedTextStyle: _buttonText,
      );

  static ChipThemeData _chipTheme(ColorScheme c) => ChipThemeData(
    backgroundColor: c.brightness == Brightness.light
        ? c.surfaceContainerLowest
        : c.surfaceContainerHigh,
    selectedColor: c.secondaryContainer,
    secondarySelectedColor: c.secondaryContainer,
    checkmarkColor: c.onSecondaryContainer,
    deleteIconColor: c.onSurfaceVariant,
    disabledColor: c.onSurface.withValues(alpha: 0.08),
    side: BorderSide(color: c.outlineVariant),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    labelStyle: _style(13, FontWeight.w700, 1.3, c.onSurface),
    secondaryLabelStyle: _style(
      13,
      FontWeight.w700,
      1.3,
      c.onSecondaryContainer,
    ),
    brightness: c.brightness,
    shape: _stadium,
  );

  static TabBarThemeData _tabBarTheme(ColorScheme c) => TabBarThemeData(
    labelColor: c.onSurface,
    unselectedLabelColor: c.onSurfaceVariant,
    labelStyle: _style(14, FontWeight.w800, 1.3, c.onSurface),
    unselectedLabelStyle: _style(14, FontWeight.w600, 1.3, c.onSurfaceVariant),
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: c.primary, width: 4),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    ),
    dividerColor: c.outlineVariant,
    overlayColor: WidgetStatePropertyAll(c.primary.withValues(alpha: 0.06)),
  );

  static ListTileThemeData _listTileTheme(ColorScheme c) => ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    minVerticalPadding: 10,
    iconColor: c.onSurfaceVariant,
    textColor: c.onSurface,
    selectedColor: c.primary,
    selectedTileColor: c.primaryContainer.withValues(alpha: 0.5),
    shape: _rounded(AppRadius.lg),
    titleTextStyle: _style(16, FontWeight.w700, 1.35, c.onSurface),
    subtitleTextStyle: _style(14, FontWeight.w400, 1.4, c.onSurfaceVariant),
  );

  static SnackBarThemeData _snackBarTheme(ColorScheme c) => SnackBarThemeData(
    backgroundColor: c.inverseSurface,
    contentTextStyle: _style(14, FontWeight.w600, 1.4, c.onInverseSurface),
    actionTextColor: c.inversePrimary,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    shape: _rounded(AppRadius.lg),
  );

  static ProgressIndicatorThemeData _progressTheme(ColorScheme c) =>
      ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.primaryContainer,
        circularTrackColor: Colors.transparent,
        linearMinHeight: 6,
        borderRadius: BorderRadius.circular(AppRadius.full),
      );

  // ==================== Theme-Aufbau ====================

  static ThemeData _build(ColorScheme c) {
    final textTheme = _textTheme(c);
    return ThemeData(
      useMaterial3: true,
      colorScheme: c,
      brightness: c.brightness,
      fontFamily: fontFamily,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: c.surface,
      canvasColor: c.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,

      appBarTheme: _appBarTheme(c),
      navigationBarTheme: _navigationBarTheme(c),
      navigationRailTheme: _navigationRailTheme(c),
      bottomNavigationBarTheme: _bottomNavTheme(c),
      cardTheme: _cardTheme(c),
      filledButtonTheme: _filledButtonTheme(c),
      elevatedButtonTheme: _elevatedButtonTheme(c),
      outlinedButtonTheme: _outlinedButtonTheme(c),
      textButtonTheme: _textButtonTheme(c),
      segmentedButtonTheme: _segmentedButtonTheme(c),
      inputDecorationTheme: _inputTheme(c),
      dialogTheme: _dialogTheme(c),
      bottomSheetTheme: _bottomSheetTheme(c),
      floatingActionButtonTheme: _fabTheme(c),
      chipTheme: _chipTheme(c),
      tabBarTheme: _tabBarTheme(c),
      listTileTheme: _listTileTheme(c),
      snackBarTheme: _snackBarTheme(c),
      progressIndicatorTheme: _progressTheme(c),

      dividerTheme: DividerThemeData(
        color: c.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: c.onSurfaceVariant, size: 24),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.coral,
        textColor: Colors.white,
        textStyle: _style(11, FontWeight.w800, 1.2, Colors.white),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.brightness == Brightness.light
            ? c.surfaceContainerLowest
            : c.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: _rounded(AppRadius.lg),
        textStyle: _style(15, FontWeight.w600, 1.3, c.onSurface),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          shape: WidgetStatePropertyAll(_rounded(AppRadius.lg)),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: _style(12, FontWeight.w600, 1.3, c.onInverseSurface),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : c.outline,
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: c.primary,
        textColor: c.onSurface,
      ),
    );
  }

  /// Helles Theme.
  static ThemeData lightTheme() => _build(lightColorScheme);

  /// Dunkles Theme.
  static ThemeData darkTheme() => _build(darkColorScheme);
}

// ==================== Markenfarben ====================

/// Feste Markenfarben, die unabhängig vom Material-Farbschema gebraucht
/// werden (Positionen, Spielfeld, semantische Status-Farben).
class AppColors {
  AppColors._();

  // Kernpalette
  static const Color blue = Color(0xFF2B57D6);
  static const Color blueLight = Color(0xFF4C7BEA);
  static const Color orange = Color(0xFFF08A24);
  static const Color violet = Color(0xFF7B61D9);
  static const Color sun = Color(0xFFFFC233);
  static const Color coral = Color(0xFFFF6B5B);
  static const Color ink = Color(0xFF1A1C21);

  // Rasenfarben – nur noch für Spielfeld/Erfolg, nicht mehr als Markenfarbe
  static const Color grass = Color(0xFF15803D);
  static const Color mint = Color(0xFF4ADE80);

  // Semantik (AA-Kontrast auf hellen bzw. dunklen Flächen)
  static const Color successLight = Color(0xFF15803D);
  static const Color successDark = Color(0xFF4ADE80);
  static const Color warningLight = Color(0xFFB26B00);
  static const Color warningDark = Color(0xFFFFCB45);

  // Spielfeld (Rasenstreifen)
  static const Color pitchDark = Color(0xFF138A4F);
  static const Color pitchLight = Color(0xFF1C9C5C);
  static const Color pitchLine = Color(0xFF0C6B3C);

  // Positionen – überall in der App einheitlich
  static const Color goalkeeper = Color(0xFFF2A100);
  static const Color defender = Color(0xFF2D8CEB);
  static const Color midfielder = Color(0xFF13A05A);
  static const Color forward = Color(0xFFEF4F45);
  static const Color unknownPosition = Color(0xFF8A918B);

  /// Farbe zur Kickbase-Position (1=TW, 2=ABW, 3=MF, 4=ST).
  static Color position(int position) => switch (position) {
    1 => goalkeeper,
    2 => defender,
    3 => midfielder,
    4 => forward,
    _ => unknownPosition,
  };

  /// Weicher Verlauf für Kopfbereiche (Hero-Header).
  static LinearGradient heroGradient(ColorScheme c) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: c.brightness == Brightness.light
        ? const [Color(0xFF1E3FA8), Color(0xFF2B57D6), Color(0xFF4C7BEA)]
        : const [Color(0xFF15255E), Color(0xFF1E3A8A), Color(0xFF2B4FB8)],
  );
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
      ? AppColors.successLight
      : AppColors.successDark;

  /// Warning Color
  Color get warningColor => Theme.of(this).brightness == Brightness.light
      ? AppColors.warningLight
      : AppColors.warningDark;

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
