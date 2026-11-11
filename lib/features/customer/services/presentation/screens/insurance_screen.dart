import 'package:citizenone_app/components/shared/service_grid_row.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/theme/tokens/dimensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';
import 'package:citizenone_app/design_system/organisms/service_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';

class InsuranceScreen extends StatelessWidget {
  final InsuranceProvider? provider;

  const InsuranceScreen({super.key, this.provider});

  // Removed stray token reference
  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          provider?.vendorName.isNotEmpty == true
              ? provider!.vendorName
              : context.l10n.serviceGovtTitle,
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
            _heroCard(context),
            SizedBox(height: AppDimensions.sectionVerticalSpacing),
            // ── Quick Actions ──
            QuickActionsWidget(
              sectionTitle: context.l10n.dashboardSectionQuickActions,
              showContainerBackground: true,
              sectionPadding: EdgeInsets.zero,
              itemsPerRow: 4,
              items: [
                QuickActionItem(
                  title: context.l10n.serviceGovtActionTaxes, // Buy Policy
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconAdd,
                      colorFilter: ColorFilter.mode(
                        tokens.textPrimary,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title:
                      context.l10n.serviceGovtActionCertificates, // Apply Claim
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.brandYellow,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconDoc,
                      colorFilter: ColorFilter.mode(
                        AppColors.warning,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title:
                      context.l10n.serviceGovtActionLandRecords, // Pay Premium
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.brandMint,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconPay,
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
                      color: AppColors.brandLavender,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconMenuBook,
                      colorFilter: ColorFilter.mode(
                        AppColors.info,
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
            ServiceSectionCard(
              title:
                  context.l10n.serviceGovtHealthInsurance, // Explore Policies,
              showDivider: true,
              child: ServiceGridRow(
                items: [
                  SvcItem(
                    icon: AppAssets.iconHealthAndSafety, // Health
                    label: context.l10n.serviceGovtHealthInsurance,
                  ),
                  SvcItem(
                    icon: AppAssets.iconTruck,
                    label: context.l10n.serviceGovtBirthCertificate, // Motor
                  ),
                  SvcItem(
                    icon: AppAssets.iconTravel,
                    label: context.l10n.serviceGovtDeathCertificate, // Travel
                  ),
                  SvcItem(
                    icon: AppAssets.iconHeartTick,
                    label: context.l10n.serviceGovtFitness, // Life
                  ),
                ],
              ),
            ),

            ServiceSectionCard(
              title:
                  context.l10n.serviceGovtSectionEducation, // My Insurance Hub
              showDivider: true,
              child: ServiceGridRow(
                items: [
                  SvcItem(
                    icon: AppAssets.iconVerifiedUser,
                    iconColor: AppColors.surfaceBgPurple,
                    label: context
                        .l10n
                        .serviceGovtScholarships, // My active Policy
                  ),
                  SvcItem(
                    icon: AppAssets.iconDueTimer,
                    label: context.l10n.serviceGovtAdmissions, // Due Payment
                  ),
                  SvcItem(
                    icon: AppAssets.iconNote,
                    label: context
                        .l10n
                        .serviceGovtSkillCertificates, //Claim status
                    iconColor: AppColors.roleFarmer,
                  ),
                  SvcItem(
                    icon: AppAssets.iconHistory,
                    label: context
                        .l10n
                        .serviceGovtDigitalLibrary, // Payment History
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
            const SizedBox(height: AppDimensions.scrollBottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    final tokens = context.appTokens;
    return Container(
      padding: EdgeInsets.all(tokens.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.surfaceBgPurpleTranslucent,
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        boxShadow: tokens.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.serviceBankingBalanceLabel,
                style: AppTextStyle.titleSmall,
                color: tokens.background,
                fontWeight: FontWeight.w500,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBgPurple.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssets.iconCurrency,
                  colorFilter: ColorFilter.mode(
                    tokens.background,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          AppText(
            'ZK 125,000.00',
            style: AppTextStyle.metricLarge,
            color: tokens.background,
          ),
          SizedBox(height: 16),
          Divider(color: AppColors.surfaceBg.withValues(alpha: 0.5)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.serviceBankingAccountSavings('4589'),
                style: AppTextStyle.bodyLarge,
                color: tokens.background,
              ),
              AppText(
                context.l10n.serviceBankingBalanceChange('+2.4%'),
                style: AppTextStyle.bodyLarge,
                fontWeight: FontWeight.w700,
                color: tokens.background,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
