// =============================================================================
// Shared transaction/policy summary widgets — extracted from
// motor_policy_confirmed_page.dart so the payment-failure screen
// (motor_insurance_error_page.dart) can reuse the exact same row and
// action-button styling instead of duplicating it.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

/// A label/value row used inside transaction & policy summary cards.
Widget transactionDetailRow({
  required BuildContext context,
  required String label,
  required String value,
  bool emphasize = false,
}) {
  final isMobile = context.isMobile;

  final labelFontSize = emphasize ? (isMobile ? 11.0 : 16.0) : 14.0;

  final valueFontSize = emphasize ? (isMobile ? 14.0 : 22.0) : 14.0;

  final labelFontWeight = emphasize ? FontWeight.w700 : FontWeight.w400;

  final valueFontWeight = emphasize
      ? (isMobile ? FontWeight.w700 : FontWeight.w800)
      : FontWeight.w500;

  final valueColor = emphasize ? AppColors.primary : AppColors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: AppText(
            label,
            style: AppTextStyle.microLabel,
            fontSize: labelFontSize,
            color: emphasize ? AppColors.k212121 : AppColors.serviceHeaderTitle,
            fontWeight: labelFontWeight,
          ),
        ),
        Expanded(
          flex: 5,
          child: AppText(
            value,
            style: AppTextStyle.bodyMedium,
            fontSize: valueFontSize,
            fontWeight: valueFontWeight,
            color: valueColor,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

/// A circular icon button with a label underneath, used for the row of
/// quick actions below a transaction summary card (Print Receipt, View
/// Details, Share Policy Documents, Add to Digital Wallet, ...).
///
/// Pass [enabled] = false for actions that aren't wired up yet — it renders
/// the same greyed-out, non-interactive look already used for the
/// "Share Policy Documents" placeholder.
Widget transactionActionButton({
  required String iconPath,
  required String label,
  required VoidCallback onTap,
  bool enabled = true,
}) {
  final button = Column(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: SvgPicture.asset(
              package: AppConfig.packageName,
              iconPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.brandBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      AppText(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyle.labelSmall,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
    ],
  );

  if (!enabled) {
    return IgnorePointer(
      ignoring: true,
      child: Opacity(opacity: 0.5, child: button),
    );
  }
  return button;
}
