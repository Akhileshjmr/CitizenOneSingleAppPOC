// =============================================================================
// BalanceCardMolecule  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: AppCard + typography + visibility-toggle (icon) + secondary
// action button. The molecule exposes data via constructor parameters
// (no business logic) and emits user intents through callbacks.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class BalanceCardMolecule extends StatelessWidget {
  const BalanceCardMolecule({
    super.key,
    required this.accountLabel,
    required this.balanceFormatted,
    required this.maskedAccount,
    this.isHidden = false,
    this.onToggleVisibility,
    this.onActionTap,
    this.actionLabel = 'View',
    this.gradient,
  });

  final String accountLabel;
  final String balanceFormatted;
  final String maskedAccount;
  final bool isHidden;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onActionTap;
  final String actionLabel;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final defaultGradient = LinearGradient(
      colors: [c.primary, c.primary.withValues(alpha: 0.78)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      gradient: gradient ?? defaultGradient,
      borderColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  accountLabel,
                  variant: AppTextVariant.label,
                  color: c.onPrimary.withValues(alpha: 0.85),
                ),
              ),
              if (onToggleVisibility != null)
                InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  onTap: onToggleVisibility,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Icon(
                      isHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: c.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const AppSpacer.sm(),
          AppText(
            isHidden ? '••••••' : balanceFormatted,
            variant: AppTextVariant.displayLarge,
            color: c.onPrimary,
          ),
          const AppSpacer.md(),
          Row(
            children: [
              Expanded(
                child: AppText(
                  maskedAccount,
                  variant: AppTextVariant.body,
                  color: c.onPrimary.withValues(alpha: 0.9),
                ),
              ),
              if (onActionTap != null)
                AppButton(
                  label: actionLabel,
                  onPressed: onActionTap,
                  variant: AppButtonVariant.text,
                  size: AppButtonSize.sm,
                  trailingIcon: Icons.arrow_forward_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
