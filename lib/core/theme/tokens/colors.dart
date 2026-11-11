import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF613AF5);
  // Color(0xFF10B981); // Emerald Green
  static const Color primaryDark = Color(0xFF047857);
  static const Color primaryLight = Color(0xFF34D399);

  // Accent
  static const Color accent = Color(0xFF8B5CF6); // Violet
  static const Color accentGlow = Color(0x668B5CF6);

  // Role Based
  static const Color roleCitizen = Color(0xFF65A30D);
  static const Color roleAgent = Color(0xFF7C3AED); // Purple
  static const Color roleFarmer = Color(0xFF16A34A); // Green

  // Brand / Semantic Actions
  static const Color brandBlue = Color(0xFF3B82F6);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandGreen = Color(0xFF10B981);
  static const Color brandRed = Color(0xFFEF4444);
  static const Color brandTeal = Color(0xFF14B8A6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color brandPink = Color(0xFFDB2777);

  // Service Based
  static const Color serviceWealth = Color(0xFF7C3AED);
  static const Color serviceHealth = Color(0xFFE91E63);
  static const Color serviceSport = Color(0xFF14B8A6);
  static const Color serviceBills = Color(0xFFF97316);
  static const Color serviceInsurance = Color(0xFFEF4444);
  static const Color serviceGovt = Color(0xFF3B82F6);
  static const Color serviceCommon = Color(0xFF3B82F6);
  static const Color serviceBanking = Color(0xFF3B82F6);
  static const Color serviceMobile = Color(0xFF8B5CF6);
  static const Color serviceMarket = Color(0xFFEC4899);
  static const Color serviceAgri = Color(0xFF10B981);
  static const Color serviceLogistics = Color(0xFFF97316);
  static const Color serviceSme = Color(0xFF6366F1);
  static const Color serviceBlueBg = Color(0xFFE2EFFF);
  static const Color servicePinkBg = Color(0xFFE2EFFF);
  static const Color serviceOrangeBg = Color(0xFFFEF1E7);
  static const Color serviceLightPinkBg = Color(0xFFFAEFFF);
  static const Color serviceTealBg = Color(0xFF0891B2);
  static const Color serviceBlue = Color(0xFF2563EB);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceTranslucent = Color(0xE6FFFFFF);
  static const Color surfaceLight = Color(0xFFE5E7EB);
  static const Color surfaceSoft = Color(0xFFF8FAFC);
  static const Color outline = Color(0xFFE2E8F0);
  static const Color surfaceBg = Color(0xFFF3F3F3);
  static const Color surfaceBgPurple = Color(0xFF613AF5);
  static const Color surfaceBgPurpleTranslucent = Color(0xFF6664FF);
  static const Color surfaceBgRed = Color(0xFFFF2056);
  static const Color serviceLightBlue = Color(0xFF0092B8);
  static const Color serviceMobileBg = Color(0xFFAD46FF);
  static const Color serviceMarketBg = Color(0xFFF6339A);

  static const Color logoutBg = Color(0xFFFEE2E2);
  static const Color deactivateBg = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color blue700 = Color(0xFF1D4ED8);

  // Glass
  static const Color glass = Color(0xD9FFFFFF);
  static const Color glassWhite = Color(0xD9FFFFFF);
  static const Color glassBorder = Color(0x80FFFFFF);
  static const Color border = Color(0xFFDDDDDD);

  // Text
  static const Color textPrimary = Color(0xFF000000); // Gray 800
  static const Color textMain = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color serviceHeaderTitle = Color(0xFF727272);
  static const Color horizantalHeaderTitle = Color(0xFF5E5E5E);

  // Status
  static const Color error = Color(0xFFB7131A);
  static const Color errorBg = Color(0xFFFFCDC0);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF1D4ED8);
  static const Color brandYellow = Color(0xFFFEF3C7);

  //Divider colors
  static const Color brandMint = Color(0xFFECFDF5);
  static const Color brandLavender = Color(0xFFEFF6FF);
  static const Color dividerColor = Color(0xFF613AF5);

  // Legacy / Alias
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color black = Colors.black;


  // Shadows
  static const Color shadowColor = Color(0x1F212121);

  static const List<BoxShadow> shadowXs = [
    BoxShadow(
      color: shadowColor,
      offset: Offset(0, 2),
      blurRadius: 3,
      spreadRadius: 1,
    ),
  ];
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
  static const List<BoxShadow> shadowGlow = [
    BoxShadow(color: Color(0x3310B981), blurRadius: 20, spreadRadius: 0),
  ];

  static const LinearGradient primaryHeroGradient = LinearGradient(
    colors: [Color(0xFF047857), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
