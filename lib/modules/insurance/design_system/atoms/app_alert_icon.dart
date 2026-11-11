// =============================================================================
// AppAlertType / AppAlertIcon  —  ATOM
// -----------------------------------------------------------------------------
// Shared semantic-type → (icon, background, accent, link) mapping used by
// every alert surface in the app: AppAlertBanner, AppMessageDialog,
// AppConfirmationDialog, and Snack.show(). Colors/icon shape are sampled
// directly from Alert.svg — success uses a check-circle, the other three
// severities intentionally reuse the *same* circle-"!" glyph (not a
// triangle, not an "i"), differentiated only by color, exactly as in the
// reference file.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';

enum AppAlertType { success, warning, error, info }

class AppAlertPalette {
  const AppAlertPalette({
    required this.icon,
    required this.background,
    required this.accent,
    required this.link,
  });

  final IconData icon;
  final Color background;
  final Color accent;
  final Color link;
}

class AppAlertIcon {
  AppAlertIcon._();

  static AppAlertPalette paletteFor(AppAlertType type) {
    switch (type) {
      case AppAlertType.success:
        return const AppAlertPalette(
          icon: Icons.check_circle,
          background: AppColors.alertSuccessBg,
          accent: AppColors.alertSuccessAccent,
          link: AppColors.alertSuccessLink,
        );
      case AppAlertType.warning:
        return const AppAlertPalette(
          icon: Icons.error,
          background: AppColors.alertWarningBg,
          accent: AppColors.alertWarningAccent,
          link: AppColors.alertWarningLink,
        );
      case AppAlertType.error:
        return const AppAlertPalette(
          icon: Icons.error,
          background: AppColors.alertErrorBg,
          accent: AppColors.alertErrorAccent,
          link: AppColors.alertErrorLink,
        );
      case AppAlertType.info:
        return const AppAlertPalette(
          icon: Icons.error,
          background: AppColors.alertInfoBg,
          accent: AppColors.alertInfoAccent,
          link: AppColors.alertInfoLink,
        );
    }
  }
}
