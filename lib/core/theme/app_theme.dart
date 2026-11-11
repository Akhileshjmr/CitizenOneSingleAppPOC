import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/theme_cubit.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';

class AppTheme {
  static ThemeData lightTheme(ThemeState state) {
    final tokens = AppThemeTokens(
      primary: state.primaryColor,
      accent: state.accentColor,
      background: AppColors.background,
      surface: AppColors.surface,
      surfaceMuted: AppColors.surfaceLight,
      surfaceSoft: AppColors.surfaceSoft,
      textPrimary: AppColors.textPrimary,
      textSecondary: AppColors.textSecondary,
      textMuted: AppColors.textMuted,
      outline: AppColors.outline,
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      heroGradient: LinearGradient(
        colors: [state.primaryColor.withValues(alpha: 0.85), state.primaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowSm: AppColors.shadowSm,
      shadowMd: AppColors.shadowMd,
      spacingXs: 8,
      spacingSm: 12,
      spacingMd: 16,
      spacingLg: 20,
      spacingXl: 24,
      spacing2xl: 32,
      radiusSm: 12,
      radiusMd: state.radiusMd,
      radiusLg: 20,
      radiusXl: 24,
      gradientWealth: const LinearGradient(
        colors: [Color(0xFF312E81), Color(0xFF4338CA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientHealth: const LinearGradient(
        colors: [Color(0xFFF43F5E), Color(0xFFBE123C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientBills: const LinearGradient(
        colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientInsurance: const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientGovt: const LinearGradient(
        colors: [Color(0xFF0E7490), Color(0xFF06B6D4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientBanking: LinearGradient(
        colors: [state.primaryColor.withValues(alpha: 0.85), state.primaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientMobile: const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientSport: const LinearGradient(
        colors: [Color(0xFF0F766E), Color(0xFF114E45)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientLogistics: const LinearGradient(
        colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      gradientMarketplace: const LinearGradient(
        colors: [Color(0xFFDB2777), Color(0xFF9D174D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      brandBlue: AppColors.brandBlue,
      brandPurple: AppColors.brandPurple,
      brandOrange: AppColors.brandOrange,
      brandGreen: AppColors.brandGreen,
      brandRed: AppColors.brandRed,
      brandIndigo: AppColors.brandIndigo,
      brandPink: AppColors.brandPink,
      brandTeal: AppColors.brandTeal,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: state.primaryColor,
      scaffoldBackgroundColor: tokens.background,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: tokens.textPrimary),
        bodyMedium: TextStyle(color: tokens.textSecondary),
      ),
      colorScheme: ColorScheme.light(
        primary: state.primaryColor,
        secondary: state.accentColor,
        surface: tokens.surface,
        error: tokens.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: tokens.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: tokens.textPrimary),
        titleTextStyle: TextStyle(
          color: tokens.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: IconThemeData(
        color: tokens.textPrimary,
        size: 24,
      ),
      dividerColor: tokens.outline,
      extensions: [tokens],
    );
  }
}
