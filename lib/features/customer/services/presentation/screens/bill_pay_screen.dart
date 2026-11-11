import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/mini_service_scaffold.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:flutter_svg/svg.dart';

class BillPayScreen extends StatelessWidget {
  const BillPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return MiniServiceScaffold(
      title: context.l10n.serviceBillPayTitle,
      hero: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tokens.brandOrange.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.serviceBillPayTotalDue,
              style: AppTextStyle.labelSmall,
              color: tokens.textSecondary,
            ),
            const SizedBox(height: 8),
            const AppText('ZK 1,450.00', style: AppTextStyle.heroValue),
            const SizedBox(height: 4),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                context.l10n.serviceBillPayDueNote(3),
                style: AppTextStyle.labelSmall,
                color: tokens.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              height: 40,
              backgroundColor: AppColors.brandOrange,
              text: context.l10n.serviceBillPayActionPayAll,
              onPressed: () {},
            ),
          ],
        ),
      ),
      quickActions: [
        QuickActionData(
          icon: AppAssets.iconElectricBolt,
          label: context.l10n.serviceBillPayActionElectricity,
          backgroundColor: AppColors.serviceOrangeBg,
        ),
        QuickActionData(
          icon: AppAssets.iconWaterDrop,
          label: context.l10n.serviceBillPayActionWater,
          backgroundColor: AppColors.serviceBlueBg,
        ),
        QuickActionData(
          icon: AppAssets.iconMobile,
          label: context.l10n.serviceBillPayActionMobile,
          backgroundColor: AppColors.serviceLightPinkBg,
        ),
        QuickActionData(
          icon: AppAssets.iconAdd,
          label: context.l10n.serviceBillPayActionAddNew,
          backgroundColor: AppColors.surfaceBg,
        ),
      ],
      services: [
        ServiceListData(
          title: context.l10n.serviceBillPayHistory,
          onTap: () {},
        ),
        ServiceListData(title: context.l10n.serviceBillPayManage, onTap: () {}),
        ServiceListData(
          title: context.l10n.serviceBillPayAutoPay,
          onTap: () {},
        ),
      ],
      aiInsight: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.iconAdd,
                colorFilter: ColorFilter.mode(
                  AppColors.brandOrange,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              AppText(
                'AI Assistants',
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.w700,
                color: AppColors.brandOrange,
                letterSpacing: 0.8,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: tokens.brandOrange.withValues(alpha: 0.1),
              ),
              boxShadow: tokens.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tokens.brandOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(AppAssets.iconAddOrange),
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      'Citizen AI Insights',
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppText(
                  context.l10n.serviceBillPayPrediction,
                  style: AppTextStyle.headlineSmall,
                ),
                const SizedBox(height: 8),
                AppText(
                  context.l10n.serviceBillPayAiUsageDesc,
                  style: AppTextStyle.bodyMedium,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  height: 40,
                  backgroundColor: tokens.brandOrange,
                  text: context.l10n.serviceActionViewUsage,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
