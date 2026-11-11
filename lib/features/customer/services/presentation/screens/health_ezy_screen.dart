import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/mini_service_scaffold.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:flutter_svg/svg.dart';

class HealthEzyScreen extends StatelessWidget {
  const HealthEzyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return MiniServiceScaffold(
      title: context.l10n.serviceHealthTitle,
      hero: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceBgRed,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: tokens.brandRed.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      context.l10n.serviceHealthTitle,
                      style: AppTextStyle.metricLarge,
                      color: tokens.background,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      context.l10n.serviceHealthPassport,
                      style: AppTextStyle.titleSmall,
                      color: tokens.background,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.heart, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(children: [_buildTag(context, 'BP: 120/80')]),
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
          title: context.l10n.serviceHealthSymptomChecker,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceHealthVaccination,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceHealthHospitals,
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
                  AppColors.surfaceBgRed,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              AppText(
                'AI Assistants',
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.w700,
                color: AppColors.surfaceBgRed,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.iconAdd,
                        colorFilter: ColorFilter.mode(
                          AppColors.surfaceBgRed,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      'Citizen AI Alert',
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppText(
                  context.l10n.serviceHealthCheckupDue,
                  style: AppTextStyle.headlineSmall,
                ),
                const SizedBox(height: 8),
                AppText(
                  context.l10n.serviceHealthAiCheckupDesc,
                  style: AppTextStyle.bodyMedium,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: context.l10n.serviceActionViewDetails,
                  backgroundColor: AppColors.surfaceBgRed,
                  icon: LucideIcons.arrow_right,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        label,
        style: AppTextStyle.labelSmall,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
