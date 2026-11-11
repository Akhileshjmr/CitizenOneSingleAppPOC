import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/mini_service_scaffold.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:flutter_svg/svg.dart';

class MobileRechargeScreen extends StatelessWidget {
  const MobileRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return MiniServiceScaffold(
      title: context.l10n.serviceMobileTitle,
      hero: Container(
        decoration: BoxDecoration(
          color: AppColors.serviceMobileBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: tokens.brandPurple.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.serviceMobileMyNumber,
                        style: AppTextStyle.titleSmall,
                        color: tokens.background,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        '+1 987 654 3210',
                        style: AppTextStyle.metricLarge,
                        color: tokens.background,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        context.l10n.serviceMobileExpiryNote(12),
                        style: AppTextStyle.titleSmall,
                        color: tokens.background,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    AppAssets.iconMobile,
                    colorFilter: ColorFilter.mode(
                      tokens.background,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(
                color: AppColors.dividerColor.withValues(alpha: 0.5),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: AppText(
                context.l10n.serviceMobileDataLeft('1.2'),
                style: AppTextStyle.bodyLarge,
                color: tokens.background,
                fontWeight: FontWeight.w500,
              ),
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
          title: context.l10n.serviceMobilePopularPlans,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceMobileFamilyAccounts,
          onTap: () {},
        ),
        ServiceListData(title: context.l10n.serviceMobileRoaming, onTap: () {}),
      ],
      aiInsight: Column(
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.iconAdd,
                colorFilter: ColorFilter.mode(
                  AppColors.serviceMobileBg,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              AppText(
                'AI Assistants',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w700,
                color: AppColors.serviceMobileBg,
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
                color: tokens.brandBlue.withValues(alpha: 0.1),
              ),
              boxShadow: tokens.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.serviceMobileBg.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.iconAdd,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          AppColors.serviceMobileBg,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    SizedBox(width: 8),
                    AppText(
                      context.l10n.heroCardCitizenLabel,
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppText(
                  context.l10n.serviceMobilePlanExpiring,
                  style: AppTextStyle.headlineSmall,
                ),
                const SizedBox(height: 8),
                AppText(
                  context.l10n.serviceMobileAiPlanExpiringDesc,
                  style: AppTextStyle.bodyMedium,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: context.l10n.serviceActionViewDetails,
                  onPressed: () {},
                  height: 40,
                  backgroundColor: AppColors.serviceMobileBg,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
