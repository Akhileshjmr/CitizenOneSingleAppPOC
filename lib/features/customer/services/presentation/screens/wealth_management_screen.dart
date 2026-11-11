import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/mini_service_scaffold.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

class WealthManagementScreen extends StatelessWidget {
  const WealthManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return MiniServiceScaffold(
      title: context.l10n.serviceWealthTitle,
      hero: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: tokens.brandPurple,
          borderRadius: BorderRadius.circular(20),
          gradient: tokens.gradientWealth,
          boxShadow: [
            BoxShadow(
              color: tokens.brandPurple.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            AppText(
              context.l10n.serviceWealthPortfolioLabel,
              style: AppTextStyle.caption,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            AppText(
              'ZK 582,400.00', // TODO: Use dynamic currency formatter
              style: AppTextStyle.heroValue,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up, color: tokens.brandGreen, size: 16),
                  const SizedBox(width: 4),
                  AppText(
                    context.l10n.serviceBankingBalanceChange('+8.4%'),
                    style: AppTextStyle.labelSmall,
                    color: tokens.brandGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      quickActions: [
        QuickActionData(
          icon: AppAssets.iconSavings,
          label: context.l10n.serviceWealthActionInvest,
          color: tokens.brandIndigo,
        ),
        QuickActionData(
          icon: AppAssets.iconPay,
          label: context.l10n.serviceWealthActionFunds,
          color: tokens.brandGreen,
        ),
        QuickActionData(
          icon: AppAssets.iconSavings,
          label: context.l10n.serviceWealthActionSIPs,
          color: tokens.brandPurple,
        ),
        QuickActionData(
          icon: AppAssets.iconAccountBalanceWallet,
          label: context.l10n.serviceWealthActionAdvisory,
          color: tokens.textSecondary,
        ),
      ],
      services: [
        ServiceListData(
          title: context.l10n.serviceWealthMutualFunds,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceWealthFixedDeposits,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceWealthPensionPlans,
          onTap: () {},
        ),
      ],
      aiInsight: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.warning.withValues(alpha: 0.1)),
          boxShadow: tokens.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.serviceWealthGoalAnalysis,
              style: AppTextStyle.headlineSmall,
            ),
            const SizedBox(height: 8),
            AppText(
              context.l10n.serviceWealthAiGoalDesc,
              style: AppTextStyle.bodyMedium,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.serviceActionViewDetails,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
