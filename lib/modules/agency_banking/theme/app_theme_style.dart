import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

/// Design tokens extracted from the CitizenOne "Loan EMI Repayment" search
/// screen, kept in one place so the mobile and web layouts render pixel-
/// consistent colors, spacing and radii instead of drifting apart.
class AppThemeStyle {
  AppThemeStyle._();



  // Radii
  static const double cardRadius = 20;
  static const double inputRadius = 12;
  static const double buttonRadius = 14;
  static const double listTileRadius = 14;

  // Text styles
  static const TextStyle headerTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle pageTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    height: 1.25,
  );

  static const TextStyle pageSubtitle = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle fieldHint = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.hintText,
  );

  static const TextStyle orDivider = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  static const TextStyle infoBannerText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Color(0xFF33415C),
    height: 1.4,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
    letterSpacing: 0.2,
  );

  static const TextStyle listTileText = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
}
