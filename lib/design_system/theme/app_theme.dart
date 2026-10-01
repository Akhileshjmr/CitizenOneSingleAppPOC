import 'package:flutter/material.dart';
import '../tokens/app_color_tokens.dart';
import '../tokens/app_palette.dart';
import '../typography/app_typography.dart';
import 'package:citizenone_app/core/core.dart';

/// AppTheme builds complete Material 3 Light and Dark Themes configured with AppColorTokens and UX4G AppTypography.
class AppTheme {
  // Light Theme Tokens derived from AppPalette
  static const lightColorTokens = AppColorTokens(
    brandPrimary: AppPalette.primary600,
    brandPrimaryHover: AppPalette.primary700,
    brandPrimaryActive: AppPalette.primary800,
    brandPrimaryContainer: AppPalette.primary50,

    brandSecondary: AppPalette.secondary600,
    brandSecondaryHover: AppPalette.secondary700,
    brandSecondaryActive: AppPalette.secondary800,
    brandSecondaryContainer: AppPalette.secondary100,

    statusSuccess: AppPalette.success600,
    statusSuccessContainer: AppPalette.success50,
    statusWarning: AppPalette.warning500,
    statusWarningContainer: AppPalette.warning50,
    statusError: AppPalette.danger600,
    statusDangerContainer: AppPalette.danger50,
    statusInfo: AppPalette.info500,
    statusInfoContainer: AppPalette.info50,

    bgMain: AppPalette.neutral50,
    bgCard: AppPalette.white,
    bgInput: AppPalette.neutral100,
    bgModal: AppPalette.white,
    bgDisabled: AppPalette.neutral200,

    textPrimary: AppPalette.neutral900,
    textSecondary: AppPalette.neutral600,
    textMuted: AppPalette.neutral400,
    textOnPrimary: AppPalette.white,
    textLink: AppPalette.primary600,

    borderDefault: AppPalette.neutral200,
    borderOutline: AppPalette.neutral300,
    borderFocused: AppPalette.primary600,
    borderSubtle: AppPalette.neutral200,
    divider: AppPalette.neutral100,
  );

  // Dark Theme Tokens derived from AppPalette
  static const darkColorTokens = AppColorTokens(
    brandPrimary: AppPalette.primary400,
    brandPrimaryHover: AppPalette.primary300,
    brandPrimaryActive: AppPalette.primary200,
    brandPrimaryContainer: AppPalette.primary950,

    brandSecondary: AppPalette.secondary400,
    brandSecondaryHover: AppPalette.secondary300,
    brandSecondaryActive: AppPalette.secondary200,
    brandSecondaryContainer: AppPalette.secondary900,

    statusSuccess: AppPalette.success400,
    statusSuccessContainer: AppPalette.success950,
    statusWarning: AppPalette.warning400,
    statusWarningContainer: AppPalette.warning950,
    statusError: AppPalette.danger400,
    statusDangerContainer: AppPalette.danger950,
    statusInfo: AppPalette.info400,
    statusInfoContainer: AppPalette.info950,

    bgMain: AppPalette.neutral900,
    bgCard: AppPalette.neutral800,
    bgInput: AppPalette.neutral700,
    bgModal: AppPalette.neutral800,
    bgDisabled: AppPalette.neutral800,

    textPrimary: AppPalette.neutral50,
    textSecondary: AppPalette.neutral300,
    textMuted: AppPalette.neutral500,
    textOnPrimary: AppPalette.white,
    textLink: AppPalette.primary400,

    borderDefault: AppPalette.neutral700,
    borderOutline: AppPalette.neutral600,
    borderFocused: AppPalette.primary400,
    borderSubtle: AppPalette.neutral800,
    divider: AppPalette.neutral800,
  );

  /// Builds TextTheme using UX4G Typography spec and text token colors
  static TextTheme _buildTextTheme(Color defaultTextColor) {
    return TextTheme(
      displayLarge: AppTypography.display1.copyWith(color: defaultTextColor),
      displayMedium: AppTypography.display2.copyWith(color: defaultTextColor),
      displaySmall: AppTypography.display3.copyWith(color: defaultTextColor),
      headlineLarge: AppTypography.headline1.copyWith(color: defaultTextColor),
      headlineMedium: AppTypography.headline2.copyWith(color: defaultTextColor),
      headlineSmall: AppTypography.headline3.copyWith(color: defaultTextColor),
      titleLarge: AppTypography.headline4.copyWith(color: defaultTextColor),
      titleMedium: AppTypography.headline5.copyWith(color: defaultTextColor),
      titleSmall: AppTypography.headline6.copyWith(color: defaultTextColor),
      bodyLarge: AppTypography.body1.copyWith(color: defaultTextColor),
      bodyMedium: AppTypography.body2.copyWith(color: defaultTextColor),
      bodySmall: AppTypography.body3.copyWith(color: defaultTextColor),
      labelLarge: AppTypography.label1.copyWith(color: defaultTextColor),
      labelMedium: AppTypography.label2.copyWith(color: defaultTextColor),
      labelSmall: AppTypography.label3.copyWith(color: defaultTextColor),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: lightColorTokens.bgMain,
      textTheme: _buildTextTheme(lightColorTokens.textPrimary),
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightColorTokens.brandPrimary,
        primary: lightColorTokens.brandPrimary,
        secondary: lightColorTokens.brandSecondary,
        surface: lightColorTokens.bgCard,
        error: lightColorTokens.statusError,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorTokens.brandPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: AppTypography.headline5.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightColorTokens.bgCard,
        elevation: 1,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: lightColorTokens.borderDefault),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorTokens.bgInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorTokens.borderOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorTokens.borderOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorTokens.borderFocused, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: lightColorTokens.divider,
        space: 1,
        thickness: 1,
      ),
      extensions: const [lightColorTokens],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: darkColorTokens.bgMain,
      textTheme: _buildTextTheme(darkColorTokens.textPrimary),
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkColorTokens.brandPrimary,
        primary: darkColorTokens.brandPrimary,
        secondary: darkColorTokens.brandSecondary,
        surface: darkColorTokens.bgCard,
        error: darkColorTokens.statusError,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorTokens.brandPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: AppTypography.headline5.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkColorTokens.bgCard,
        elevation: 1,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: darkColorTokens.borderDefault),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorTokens.bgInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkColorTokens.borderOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkColorTokens.borderOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkColorTokens.borderFocused, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: darkColorTokens.divider,
        space: 1,
        thickness: 1,
      ),
      extensions: const [darkColorTokens],
    );
  }

  /// Builds a cohesive ThemeData tailored for a specific business module using its brand seed color.
  static ThemeData buildModuleTheme(
    Color seedColor, {
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      primary: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: isDark ? AppPalette.neutral900 : AppPalette.neutral50,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: AppTypography.headline5.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppPalette.neutral800 : AppPalette.white,
        elevation: 1.5,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: seedColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppPalette.neutral700 : AppPalette.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seedColor.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seedColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seedColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: seedColor,
        secondarySelectedColor: seedColor,
        labelStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Configuration flag notifier to toggle between Central Theme and Module-Specific Themes.
  /// When set to [true], all modules adopt the central Design System theme.
  /// When set to [false] (default), modules adopt their respective module-specific brand themes.
  static final ValueNotifier<bool> useCentralThemeNotifier = ValueNotifier<bool>(false);

  /// Convenient static getter for the central theme configuration flag.
  static bool get useCentralTheme => useCentralThemeNotifier.value;

  /// Convenient static setter for the central theme configuration flag.
  static set useCentralTheme(bool value) => useCentralThemeNotifier.value = value;

  /// Map of module IDs to their respective primary brand colors.
  static const Map<String, Color> moduleBrandColors = {
    'root': Color(0xFF1E3A8A),
    'common': Color(0xFF1E3A8A),
    'citizen_one': Color(0xFF1E3A8A),
    'agency_banking': Color(0xFF0F766E),
    'kyc': Color(0xFF6B21A8),
    'loans': Color(0xFF1E40AF),
    'insurance': Color(0xFFC2410C),
  };

  static final Map<String, ThemeData> _lightModuleThemeCache = {};
  static final Map<String, ThemeData> _darkModuleThemeCache = {};

  /// Retrieves a module-specific theme based on module ID or module instance, respecting [useCentralTheme].
  static ThemeData getThemeForModule(
    String moduleId, {
    AppModule? module,
    Brightness brightness = Brightness.light,
  }) {
    if (useCentralTheme) {
      return brightness == Brightness.dark ? darkTheme : lightTheme;
    }

    final cache =
        brightness == Brightness.dark ? _darkModuleThemeCache : _lightModuleThemeCache;

    return cache.putIfAbsent(moduleId, () {
      if (module != null && module.theme != null) {
        return module.theme!;
      }
      final brandColor = moduleBrandColors[moduleId];
      if (brandColor == null) {
        return brightness == Brightness.dark ? darkTheme : lightTheme;
      }
      return buildModuleTheme(brandColor, brightness: brightness);
    });
  }
}

