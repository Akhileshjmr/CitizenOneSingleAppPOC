import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/theme/tokens/dimensions.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/shared/service_section_card.dart';
import 'package:citizenone_app/components/shared/service_grid_row.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

class GovtServicesScreen extends StatelessWidget {
  const GovtServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      backgroundColor: tokens.surfaceSoft,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          context.l10n.serviceGovtTitle,
          style: AppTextStyle.headlineSmall,
        ),
        centerTitle: false,
        backgroundColor: tokens.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: tokens.outline, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.serviceLightBlue,
              ),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.serviceGovtHeroTitle,
                        style: AppTextStyle.metricLarge,
                        color: tokens.background,
                      ),
                      const SizedBox(height: 6),
                      AppText(
                        context.l10n.serviceGovtSubtitle,
                        style: AppTextStyle.titleSmall,
                        color: tokens.background,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppDimensions.sectionVerticalSpacing),

            // ── Quick Actions ──
            QuickActionsWidget(
              sectionTitle: context.l10n.dashboardSectionQuickActions,
              showContainerBackground: true,
              sectionPadding: EdgeInsets.zero,
              itemsPerRow: 4,
              items: [
                QuickActionItem(
                  title: context.l10n.serviceGovtActionTaxes,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconBalance,
                      colorFilter: ColorFilter.mode(
                        tokens.brandBlue,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceGovtActionCertificates,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconWaterDrop,
                      colorFilter: ColorFilter.mode(
                        tokens.brandOrange,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceGovtActionLandRecords,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconDoc,
                      colorFilter: ColorFilter.mode(
                        tokens.brandGreen,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceGovtActionMyDocs,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconFileCopy,
                      colorFilter: ColorFilter.mode(
                        tokens.brandPurple,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 40),
            // ── Health ──
            ServiceSectionCard(
              title: 'Categories',
              subTitle: 'Health',
              showDivider: true,
              child: ServiceGridRow(
                items: [
                  SvcItem(
                    icon: AppAssets.iconHealthAndSafety,
                    label: context.l10n.serviceGovtHealthInsurance,
                  ),
                  SvcItem(
                    icon: AppAssets.iconChild,
                    label: context.l10n.serviceGovtBirthCertificate,
                  ),
                  SvcItem(
                    icon: AppAssets.iconPay,
                    label: context.l10n.serviceGovtDeathCertificate,
                  ),
                  SvcItem(
                    icon: AppAssets.iconExercise,
                    label: context.l10n.serviceGovtFitness,
                  ),
                ],
              ),
            ),

            // ── Education ──
            ServiceSectionCard(
              subTitle: context.l10n.serviceGovtSectionEducation,
              showDivider: true,
              child: ServiceGridRow(
                items: [
                  SvcItem(
                    icon: AppAssets.iconSchool,
                    label: context.l10n.serviceGovtScholarships,
                  ),
                  SvcItem(
                    icon: AppAssets.iconMenuBook,
                    label: context.l10n.serviceGovtAdmissions,
                  ),
                  SvcItem(
                    icon: AppAssets.iconExercise,
                    label: context.l10n.serviceGovtSkillCertificates,
                    iconColor: AppColors.serviceTealBg,
                  ),
                  SvcItem(
                    icon: AppAssets.iconPay,
                    label: context.l10n.serviceGovtDigitalLibrary,
                    iconColor: AppColors.serviceBlue,
                  ),
                ],
              ),
            ),

            // ── Land & Property ──
            ServiceSectionCard(
              subTitle: context.l10n.serviceGovtSectionLand,
              showDivider: true,
              child: ServiceGridRow(
                items: [
                  SvcItem(
                    icon: AppAssets.iconMap,
                    label: context.l10n.serviceGovtActionLandRecords,
                  ),
                  SvcItem(
                    icon: AppAssets.iconHome,
                    label: context.l10n.serviceGovtPropertyTax,
                    iconColor: tokens.brandOrange,
                  ),
                  SvcItem(
                    icon: AppAssets.iconTask,
                    label: context.l10n.serviceGovtEncumbrance,
                  ),
                  SvcItem(
                    icon: AppAssets.iconPay,
                    iconColor: tokens.brandPurple,
                    label: context.l10n.serviceGovtSurveyMutation,
                  ),
                ],
              ),
            ),

            // ── Civic & Welfare ──
            ServiceSectionCard(
              subTitle: context.l10n.serviceGovtSectionCivic,
              showDivider: true,
              child: ServiceGridRow(
                items: [
                  SvcItem(
                    icon: AppAssets.iconIdCard,
                    label: context.l10n.serviceGovtAadhaar,
                    iconColor: tokens.brandRed,
                  ),
                  SvcItem(
                    icon: AppAssets.iconFavoriteBorder,
                    label: context.l10n.serviceGovtVoterId,
                    iconColor: tokens.brandBlue,
                  ),
                  SvcItem(
                    icon: AppAssets.iconHandVolunteer,
                    label: context.l10n.serviceGovtPension,
                    iconColor: tokens.brandOrange,
                  ),
                  SvcItem(
                    icon: AppAssets.iconPay,
                    label: context.l10n.serviceGovtRti,
                    iconColor: AppColors.textMain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Related Updates ──
            AppText(
              context.l10n.serviceGovtRelatedUpdates,
              style: AppTextStyle.titleSmall,
              color: AppColors.serviceHeaderTitle,
            ),
            const SizedBox(height: 12),
            _BlogCard(
              title: context.l10n.serviceGovtBlogTitle1,
              snippet: context.l10n.serviceGovtBlogSnippet1,
              date: 'Feb 10, 2026',
            ),
            const SizedBox(height: 10),
            _BlogCard(
              title: context.l10n.serviceGovtBlogTitle2,
              snippet: context.l10n.serviceGovtBlogSnippet2,
              date: 'Jan 28, 2026',
            ),

            const SizedBox(height: AppDimensions.scrollBottomPadding),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Blog Card (screen-specific widget, kept local)
// ─────────────────────────────────────────────
class _BlogCard extends StatelessWidget {
  final String title;
  final String snippet;
  final String date;
  const _BlogCard({
    required this.title,
    required this.snippet,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: tokens.shadowSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tokens.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              AppAssets.iconNote,
              colorFilter: ColorFilter.mode(
                AppColors.serviceBlue,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.titleSmall,
                  color: AppColors.textMain,
                ),
                const SizedBox(height: 4),
                AppText(
                  snippet,
                  style: AppTextStyle.labelSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                AppText(
                  date,
                  style: AppTextStyle.labelSmall,
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.chevron_right, size: 18, color: tokens.outline),
          ),
        ],
      ),
    );
  }
}
