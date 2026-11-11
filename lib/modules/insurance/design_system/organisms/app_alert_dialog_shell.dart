// =============================================================================
// AppAlertDialogShell — shared internal layout for AppMessageDialog and
// AppConfirmationDialog (not exported from organisms.dart — an implementation
// detail of the two public dialog APIs, kept here once to avoid duplicating
// the icon-badge/title/message card between them).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class AppAlertDialogShell extends StatelessWidget {
  const AppAlertDialogShell({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.actions,
  });

  final AppAlertType type;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final palette = AppAlertIcon.paletteFor(type);
    final isMobile = context.isMobile;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppSpacing.xl : 0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Semantics(
            container: true,
            label: '$title. $message',
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(palette.icon, color: palette.accent, size: 30),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppText(
                    title,
                    style: AppTextStyle.headlineSmall,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    message,
                    style: AppTextStyle.bodyMedium,
                    color: AppColors.alertBodyText,
                    textAlign: TextAlign.center,
                    height: 1.4,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ...actions,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
