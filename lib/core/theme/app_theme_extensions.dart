import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'theme_cubit.dart';

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color  textMuted;
  final Color outline;
  final Color success;
  final Color warning;
  final Color error;
  final LinearGradient heroGradient;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double spacingXl;
  final double spacing2xl;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  
  // Service Specific Gradients
  final LinearGradient gradientWealth;
  final LinearGradient gradientHealth;
  final LinearGradient gradientBills;
  final LinearGradient gradientInsurance;
  final LinearGradient gradientGovt;
  final LinearGradient gradientBanking;
  final LinearGradient gradientMobile;
  final LinearGradient gradientSport;
  final LinearGradient gradientLogistics;
  final LinearGradient gradientMarketplace;

  // Brand Colors
  final Color brandBlue;
  final Color brandPurple;
  final Color brandOrange;
  final Color brandGreen;
  final Color brandRed;
  final Color brandIndigo;
  final Color brandPink;
  final Color brandTeal;

  const AppThemeTokens({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.outline,
    required this.success,
    required this.warning,
    required this.error,
    required this.heroGradient,
    required this.shadowSm,
    required this.shadowMd,
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.spacingXl,
    required this.spacing2xl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.gradientWealth,
    required this.gradientHealth,
    required this.gradientBills,
    required this.gradientInsurance,
    required this.gradientGovt,
    required this.gradientBanking,
    required this.gradientMobile,
    required this.gradientSport,
    required this.gradientLogistics,
    required this.gradientMarketplace,
    required this.brandBlue,
    required this.brandPurple,
    required this.brandOrange,
    required this.brandGreen,
    required this.brandRed,
    required this.brandIndigo,
    required this.brandPink,
    required this.brandTeal,
  });

  @override
  AppThemeTokens copyWith({
    Color? primary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceSoft,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? outline,
    Color? success,
    Color? warning,
    Color? error,
    LinearGradient? heroGradient,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? spacingXl,
    double? spacing2xl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    LinearGradient? gradientWealth,
    LinearGradient? gradientHealth,
    LinearGradient? gradientBills,
    LinearGradient? gradientInsurance,
    LinearGradient? gradientGovt,
    LinearGradient? gradientBanking,
    LinearGradient? gradientMobile,
    LinearGradient? gradientSport,
    LinearGradient? gradientLogistics,
    LinearGradient? gradientMarketplace,
    Color? brandBlue,
    Color? brandPurple,
    Color? brandOrange,
    Color? brandGreen,
    Color? brandRed,
    Color? brandIndigo,
    Color? brandPink,
    Color? brandTeal,
  }) {
    return AppThemeTokens(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      outline: outline ?? this.outline,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      heroGradient: heroGradient ?? this.heroGradient,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      spacingXl: spacingXl ?? this.spacingXl,
      spacing2xl: spacing2xl ?? this.spacing2xl,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      gradientWealth: gradientWealth ?? this.gradientWealth,
      gradientHealth: gradientHealth ?? this.gradientHealth,
      gradientBills: gradientBills ?? this.gradientBills,
      gradientInsurance: gradientInsurance ?? this.gradientInsurance,
      gradientGovt: gradientGovt ?? this.gradientGovt,
      gradientBanking: gradientBanking ?? this.gradientBanking,
      gradientMobile: gradientMobile ?? this.gradientMobile,
      gradientSport: gradientSport ?? this.gradientSport,
      gradientLogistics: gradientLogistics ?? this.gradientLogistics,
      gradientMarketplace: gradientMarketplace ?? this.gradientMarketplace,
      brandBlue: brandBlue ?? this.brandBlue,
      brandPurple: brandPurple ?? this.brandPurple,
      brandOrange: brandOrange ?? this.brandOrange,
      brandGreen: brandGreen ?? this.brandGreen,
      brandRed: brandRed ?? this.brandRed,
      brandIndigo: brandIndigo ?? this.brandIndigo,
      brandPink: brandPink ?? this.brandPink,
      brandTeal: brandTeal ?? this.brandTeal,
    );
  }

  @override
  AppThemeTokens lerp(ThemeExtension<AppThemeTokens>? other, double t) {
    if (other is! AppThemeTokens) return this;
    return AppThemeTokens(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t) ?? surfaceMuted,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t) ?? surfaceSoft,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      outline: Color.lerp(outline, other.outline, t) ?? outline,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      error: Color.lerp(error, other.error, t) ?? error,
      heroGradient: heroGradient,
      shadowSm: t < 0.5 ? shadowSm : other.shadowSm,
      shadowMd: t < 0.5 ? shadowMd : other.shadowMd,
      spacingXs: lerpDouble(spacingXs, other.spacingXs, t)!,
      spacingSm: lerpDouble(spacingSm, other.spacingSm, t)!,
      spacingMd: lerpDouble(spacingMd, other.spacingMd, t)!,
      spacingLg: lerpDouble(spacingLg, other.spacingLg, t)!,
      spacingXl: lerpDouble(spacingXl, other.spacingXl, t)!,
      spacing2xl: lerpDouble(spacing2xl, other.spacing2xl, t)!,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
      radiusXl: lerpDouble(radiusXl, other.radiusXl, t)!,
      gradientWealth: LinearGradient.lerp(gradientWealth, other.gradientWealth, t)!,
      gradientHealth: LinearGradient.lerp(gradientHealth, other.gradientHealth, t)!,
      gradientBills: LinearGradient.lerp(gradientBills, other.gradientBills, t)!,
      gradientInsurance: LinearGradient.lerp(gradientInsurance, other.gradientInsurance, t)!,
      gradientGovt: LinearGradient.lerp(gradientGovt, other.gradientGovt, t)!,
      gradientBanking: LinearGradient.lerp(gradientBanking, other.gradientBanking, t)!,
      gradientMobile: LinearGradient.lerp(gradientMobile, other.gradientMobile, t)!,
      gradientSport: LinearGradient.lerp(gradientSport, other.gradientSport, t)!,
      gradientLogistics: LinearGradient.lerp(gradientLogistics, other.gradientLogistics, t)!,
      gradientMarketplace: LinearGradient.lerp(gradientMarketplace, other.gradientMarketplace, t)!,
      brandBlue: Color.lerp(brandBlue, other.brandBlue, t)!,
      brandPurple: Color.lerp(brandPurple, other.brandPurple, t)!,
      brandOrange: Color.lerp(brandOrange, other.brandOrange, t)!,
      brandGreen: Color.lerp(brandGreen, other.brandGreen, t)!,
      brandRed: Color.lerp(brandRed, other.brandRed, t)!,
      brandIndigo: Color.lerp(brandIndigo, other.brandIndigo, t)!,
      brandPink: Color.lerp(brandPink, other.brandPink, t)!,
      brandTeal: Color.lerp(brandTeal, other.brandTeal, t)!,
    );
  }
}

AppThemeTokens? _cachedFallback;

AppThemeTokens _getFallbackTokens() {
  return _cachedFallback ??=
      AppTheme.lightTheme(const ThemeState()).extension<AppThemeTokens>()!;
}

extension AppThemeContextX on BuildContext {
  AppThemeTokens get appTokens {
    final extension = Theme.of(this).extension<AppThemeTokens>();
    return extension ?? _getFallbackTokens();
  }
}
