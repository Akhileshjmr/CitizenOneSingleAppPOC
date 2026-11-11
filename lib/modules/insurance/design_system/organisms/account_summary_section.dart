// =============================================================================
// AccountSummarySection  —  ORGANISM
// -----------------------------------------------------------------------------
// Composes BalanceCardMolecule + greeting text + secondary action buttons.
// Pure presentation — caller injects the data and callbacks. No knowledge
// of where balances come from.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

class AccountSummaryAction {
  const AccountSummaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class AccountSummarySection extends StatelessWidget {
  const AccountSummarySection({
    super.key,
    required this.greeting,
    required this.accountLabel,
    required this.balanceFormatted,
    required this.maskedAccount,
    required this.actions,
    required this.lastUpdatedLabel,
    this.isHidden = false,
    this.onToggleVisibility,
    this.onCardTap,
  });

  final String greeting;
  final String accountLabel;
  final String balanceFormatted;
  final String maskedAccount;
  final List<AccountSummaryAction> actions;
  final String lastUpdatedLabel;
  final bool isHidden;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(greeting,
            variant: AppTextVariant.subtitle,
            color: context.colors.textSecondary),
        const AppSpacer.sm(),
        BalanceCardMolecule(
          accountLabel: accountLabel,
          balanceFormatted: balanceFormatted,
          maskedAccount: maskedAccount,
          isHidden: isHidden,
          onToggleVisibility: onToggleVisibility,
          onActionTap: onCardTap,
        ),
        const AppSpacer.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: actions
              .map((a) => Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: AppButton(
                        label: a.label,
                        onPressed: a.onTap,
                        variant: AppButtonVariant.outlined,
                        leadingIcon: a.icon,
                        size: AppButtonSize.sm,
                        isFullWidth: true,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const AppSpacer.sm(),
        AppText.caption('Last updated $lastUpdatedLabel'),
      ],
    );
  }
}
