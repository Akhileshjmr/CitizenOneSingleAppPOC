import 'package:flutter/material.dart';

abstract class BrandPalette {
  const BrandPalette();

  Color get primary;
  Color get primaryContainer;
  Color get secondary;
  Color get secondaryContainer;
  Color get background;
  Color get surface;
  Color get surfaceVariant;
  Color get border;
  Color get textPrimary;
  Color get textSecondary;
  Color get textDisabled;
  Color get textInverse;
  Color get onPrimary;
  Color get error;
  Color get success;
  Color get info;

  BrandPalette dark();
}

class DefaultBrandPalette extends BrandPalette {
  const DefaultBrandPalette();

  @override
  Color get primary => AppColors.primary;

  @override
  Color get primaryContainer => AppColors.primaryLight;

  @override
  Color get secondary => AppColors.accent;

  @override
  Color get secondaryContainer => AppColors.accentGlow;

  @override
  Color get background => AppColors.background;

  @override
  Color get surface => AppColors.surface;

  @override
  Color get surfaceVariant => AppColors.surfaceLight;

  @override
  Color get border => AppColors.outline;

  @override
  Color get textPrimary => AppColors.textPrimary;

  @override
  Color get textSecondary => AppColors.textSecondary;

  @override
  Color get textDisabled => AppColors.textMuted;

  @override
  Color get textInverse => Colors.white;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get error => AppColors.error;

  @override
  Color get success => AppColors.success;

  @override
  Color get info => AppColors.info;

  @override
  BrandPalette dark() => this;
}

class BankAlphaBrand extends DefaultBrandPalette {
  const BankAlphaBrand();
}

class BankBetaBrand extends DefaultBrandPalette {
  const BankBetaBrand();

  @override
  Color get primary => AppColors.brandPurple;

  @override
  Color get primaryContainer => AppColors.accent;
}

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
  static const Color orangeBgLight = Color(0xFFFEF2C9);
  static const Color primayBgLight = Color(0xFFF4F3FD);

  static const Color logoutBg = Color(0xFFFEE2E2);
  static const Color deactivateBg = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blueShade = Color(0xFFBFDBFE);
  static const Color blueBorder = Color(0xFF60A5FA);

  static const Color kFFFCFC = Color(0xFFFFFCFC);
  static const Color kFEFCE8 = Color(0xFFFEFCE8);
  static const Color kFBFFFC = Color(0xFFFBFFFC);
  static const Color kFDAD2FD = Color(0xFFDAD2FD);

  // Glass
  static const Color glass = Color(0xD9FFFFFF);
  static const Color glassWhite = Color(0xD9FFFFFF);
  static const Color glassBorder = Color(0x80FFFFFF);
  static const Color border = Color(0xFFDDDDDD);
  static const Color labelGrey = Color(0xFF868686);

  // Text
  static const Color textPrimary = Color(0xFF000000); // Gray 800
  static const Color textMain = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textBorder = Color(0xFFC6C6C6);
  static const Color serviceHeaderTitle = Color(0xFF727272);
  static const Color horizantalHeaderTitle = Color(0xFF5E5E5E);

  // Status
  static const Color error = Color(0xFFB7131A);
  static const Color errorBg = Color(0xFFFFCDC0);
  static const Color errorBgLight = Color(0xFFFDE2E2);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF1D4ED8);
  static const Color brandYellow = Color(0xFFFEF3C7);
  static const Color statusGreen = Color(0xFFBBF7D0);
  static const Color statusCardGreen = Color(0xFF166534);

  //Divider colors
  static const Color brandMint = Color(0xFFECFDF5);
  static const Color brandLavender = Color(0xFFEFF6FF);
  static const Color dividerColor = Color(0xFF613AF5);
  static const Color starYellowColor = Color(0xFFF0B100);

  // Legacy / Alias
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color black = Colors.black;

  // Shadows
  static const Color shadowColor = Color(0x1F212121);

  //Border
  static const Color borderGray = Color(0xFFD1D5DC);
  static const Color kED1D24 = Color(0xFFED1D24);
  static const Color kF2C300 = Color(0xFFF2C300);
  static const Color k25B74D = Color(0xFF25B74D);
  static const Color k212121 = Color(0xFF212121);
  static const Color k3C9718 = Color(0xFF3C9718);

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

  // ── Desktop shell (sidebar / header) — additive, desktop-only usage ──────
  static const Color sidebarBackground = Color(0xFFF3EFEA);
  static const Color sidebarSelectedBg = Color(0xFF613AF5);
  static const Color sidebarAccentDot = Color(0xFFF59E0B);
  static const Color sidebarTextDefault = Color(0xFF3F3F46);
  static const Color sidebarDivider = Color(0xFFE7E2DA);
  static const Color desktopHeaderBorder = Color(0xFFF1F1F1);
  static const Color bestPracticesGreen = Color(0xFF10B981);

  // ── Alerts (AppAlertBanner / AppMessageDialog / AppConfirmationDialog) ───
  // Colors sampled 1:1 from Alert.svg. Kept separate from AppColors.success/
  // warning/error/info above (those are used by unrelated status badges) so
  // this migration cannot shift any existing, non-alert UI.
  static const Color alertSuccessBg = Color(0xFFE8F5E9);
  static const Color alertSuccessAccent = Color(0xFF43A047);
  static const Color alertSuccessLink = Color(0xFF388E3C);

  static const Color alertWarningBg = Color(0xFFFFF3E0);
  static const Color alertWarningAccent = Color(0xFFFF9800);
  static const Color alertWarningLink = Color(0xFFF57C00);

  static const Color alertErrorBg = Color(0xFFFFEBEE);
  static const Color alertErrorAccent = Color(0xFFF44336);
  static const Color alertErrorLink = Color(0xFFD32F2F);

  static const Color alertInfoBg = Color(0xFFE3F2FD);
  static const Color alertInfoAccent = Color(0xFF2196F3);
  static const Color alertInfoLink = Color(0xFF1976D2);

  static const Color alertBodyText = Color(0xFF546E7A);
  static const Color alertTitleNeutral = Color(0xFF263238);

  // ── Payment flow status colors (Transaction/Policy Processing, Success,
  // Payment Failed, Policy Issuance Failed screens) — sampled 1:1 from the
  // design spec's status color table. Kept separate from the general
  // success/warning/error/info constants above so this payment-flow UI
  // revamp cannot shift any other existing status UI. ─────────────────────
  static const Color processingBg = Color(0xFFEEF4FF);
  static const Color processingBorder = Color(0xFFB8CCFF);
  static const Color processingText = Color(0xFF2F5BFF);
  static const Color processingBadgeBg = Color(0xFFBBB7FC);

  static const Color successFlowBg = Color(0xFFEAF8EE);
  static const Color successFlowBorder = Color(0xFF8ED7A6);
  static const Color successFlowPrimary = Color(0xFF28A745);
  static const Color successFlowText = Color(0xFF1F7A38);
  static const Color successFlowBadgeBg = Color(0xFFD8F5E2);

  static const Color failureFlowBg = Color(0xFFFDECEC);
  static const Color failureFlowBorder = Color(0xFFF3B5B5);
  static const Color failureFlowPrimary = Color(0xFFE53935);
  static const Color failureFlowText = Color(0xFFC62828);
  static const Color failureFlowBadgeBg = Color(0xFFFFE3E3);

  static const Color warningFlowBg = Color(0xFFFFF5E8);
  static const Color warningFlowBorder = Color(0xFFFFD59E);
  static const Color warningFlowPrimary = Color(0xFFF59E0B);
  static const Color warningFlowText = Color(0xFFC97A00);

  static const Color pendingFlowBg = Color(0xFFEDEFF2);
  static const Color pendingFlowBorder = Color(0xFFDDDDDD);
  static const Color pendingFlowPrimary = Color(0xFF9E9E9E);

  // Solid icon-circle fills for ProcessStepCard — sampled from the design
  // reference (darker/richer than the badge tones above, used only for the
  // small round step-icon avatar).
  static const Color iconCircleProcessing = Color(0xFF160E80);
  static const Color iconCircleSuccess = Color(0xFF177429);
  static const Color iconCircleFailed = Color(0xFFD9473D);
}
