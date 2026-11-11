import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/colors.dart';

class AppTypography {
  // Base Font Sizes (per Antigravity Best Practices)
  static const double _baseDesktop = 16.0;

  // -- Headings --

  /// H1: Page Titles (Desktop: 32px, Mobile: 24px)
  static TextStyle headlineLarge(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? 32 : 24,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  /// H2: Section Headers (Desktop: 24px, Mobile: 20px)
  static TextStyle headlineMedium(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? 24 : 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
        height: 1.3,
      );

  /// H3: Card Titles (Desktop: 18px, Mobile: 16px)
  static TextStyle headlineSmall(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? 18 : 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0,
        height: 1.4,
      );

  // -- Body Text --

  /// Body Large: Primary Content (Desktop: 16px, Mobile: 15px)
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? _baseDesktop : 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  /// Body Medium: Secondary Content / UI Labels (Desktop: 14px, Mobile: 14px)
  static TextStyle bodyMedium(BuildContext context) => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  /// Body Small: Tertiary Content (Desktop: 13px, Mobile: 13px)
  static TextStyle bodySmall(BuildContext context) => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  /// Caption: Small UI elements (Desktop: 12px, Mobile: 12px)
  static TextStyle caption(BuildContext context) => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: 0.2,
      );

  // -- Specialized Styles --

  /// Label Small: Badges, pills, tags (10-11px)20
  static TextStyle labelSmall(BuildContext context) => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
      );

  /// Hero Value: Large numbers on hero cards (Desktop: 48px, Mobile: 40px)
  static TextStyle heroValue(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? 38 : 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.0,
      );

  /// Title Small: Bold labels, chip text, action links (12px, w500, primary color)
  static TextStyle titleSmall(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.appTokens.primary,
        height: 1.3,
      );

  /// Title Small Bold: Bold labels, action links (12px, w700, primary color)
  static TextStyle titleSmallBold(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: context.appTokens.primary,
        height: 1.3,
      );

  /// Display Small: Stat tile values, summary numbers (20/22px, w800)
  static TextStyle displaySmall(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? 22 : 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.1,
      );

  /// Metric Large: Hero card primary metric value (28/32px, w900)
  static TextStyle metricLarge(BuildContext context) => TextStyle(
        fontSize: AdaptiveLayout.isDesktop(context) ? 32 : 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.1,
      );

  /// Status Text: Inline status messages (13px)
  static TextStyle statusText(BuildContext context) => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 1.4,
      );

  /// Label: Small helper/hint text (8px, w400, muted gray)
  static TextStyle label(BuildContext context) => const TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: AppColors.serviceHeaderTitle,
      );

  /// Section Header: Used by SectionHeader widget
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );
}
