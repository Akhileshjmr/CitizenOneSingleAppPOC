import 'package:flutter/material.dart';
import '../tokens/app_color_tokens.dart';
import '../tokens/app_palette.dart';
import '../typography/app_typography.dart';

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
}
