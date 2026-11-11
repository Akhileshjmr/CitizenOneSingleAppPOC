import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/mini_service_scaffold.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';

class SportScreen extends StatelessWidget {
  const SportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return MiniServiceScaffold(
      title: context.l10n.serviceSportTitle,
      hero: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: tokens.brandGreen,
          borderRadius: BorderRadius.circular(20),
          gradient: tokens.gradientSport,
          boxShadow: [
            BoxShadow(
              color: tokens.brandGreen.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.serviceSportActiveStreak,
              style: AppTextStyle.headlineSmall,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AppText(
                  '12', // TODO: Fetch from Cubit
                  style: AppTextStyle.heroValue,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                AppText(
                  context.l10n.serviceSportDays,
                  style: AppTextStyle.caption,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              context.l10n.serviceSportStreakMotivation,
              style: AppTextStyle.bodyMedium,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
      quickActions: [
        QuickActionData(
          icon: AppAssets.iconExercise,
          label: context.l10n.serviceSportActionWorkouts,
          color: tokens.brandGreen,
        ),
        QuickActionData(
          icon: AppAssets.iconExercise,
          label: context.l10n.serviceSportActionEvents,
          color: tokens.brandOrange,
        ),
        QuickActionData(
          icon: AppAssets.iconProfileInfo,
          label: context.l10n.serviceSportActionCommunity,
          color: tokens.brandBlue,
        ),
        QuickActionData(
          icon: AppAssets.iconContactSupport,
          label: context.l10n.serviceSportActionBook,
          color: tokens.textSecondary,
        ),
      ],
      services: [
        ServiceListData(
          title: context.l10n.serviceSportFacilities,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceSportWellnessGuides,
          onTap: () {},
        ),
        ServiceListData(
          title: context.l10n.serviceSportMeditation,
          onTap: () {},
        ),
      ],
      aiInsight: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.brandBlue.withValues(alpha: 0.1)),
          boxShadow: tokens.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.serviceSportAiWellnessTip,
              style: AppTextStyle.headlineSmall,
            ),
            const SizedBox(height: 8),
            AppText(
              context.l10n.serviceSportAiWellnessTipDesc,
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
