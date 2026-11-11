import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/extensions/build_context_x.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/best_practices_panel.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/quick_actions_section.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/desktop_stepper.dart';

import '../widgets/information_banner_widget.dart';

class MotorInsuranceScreen extends StatelessWidget {
  final bool isStepper;
  const MotorInsuranceScreen({super.key, this.isStepper = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (!context.isMobile) {
      return _buildDesktop(context, colors);
    }

    if (isStepper) {
      return buildBody(context, colors);
    }

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppStatusBar(
          showBack: true,
          title: 'Motor Insurance',
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: buildBody(context, colors),
        ));
  }

  Widget buildBody(BuildContext context, BrandPalette colors) {
    return Column(
      children: [
        Image.asset(
          package: AppConfig.packageName,
          AppAssets.motorInsuranceBanner2,
          fit: BoxFit.fitWidth,
        ),
        QuickActionsSection(
          title: 'Select Your Coverage',
          items: [
            ActionItem(
              title: 'Third-Party Liability',
              icon: AppAssets.iconInsuranceHands,
              backgroundColor: colors.border,
              iconColor: colors.textPrimary,
              onTap: () {
                context.read<MotorInsuranceBloc>().add(ResetFormData());
                if (isStepper) {
                  context
                      .read<MotorInsuranceBloc>()
                      .add(const CustomStepEvent(index: 1));
                } else {
                  context.push(AppRoutes.userDetailScreen);
                }
              },
            ),
            ActionItem(
              disable: true,
              onTap: () {},
              title: 'Own Damage',
              icon: AppAssets.iconInsuranceHandUp,
              backgroundColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
            ),
            ActionItem(
              disable: true,
              onTap: () {},
              title: 'Third-Party & Comprehensive',
              icon: AppAssets.pay,
              backgroundColor: AppColors.brandMint,
              iconColor: AppColors.brandGreen,
            ),
            ActionItem(
              onTap: () {
                context.push(AppRoutes.insuranceTransactionScreen);
              },
              title: 'Reports',
              icon: AppAssets.menuBook,
              backgroundColor: AppColors.brandLavender,
              iconColor: colors.info,
            ),
          ],
        ),
        const SizedBox(height: 24),
        InformationBannerWidget(
          title: 'Motor Insurance Best Practices',
          headerIcon: AppAssets.iconShield,
          iconBgColor: colors.primary,
          points: const [
            'Keep your motor insurance policy active and up to date.',
            'Renew your policy before expiry to avoid coverage gaps.',
            'Carry your insurance certificate and policy details.',
            'Report accidents promptly and follow the claim process.',
            'Drive safely to minimize risks and claims.',
          ],
        ),
        const SizedBox(height: 24),
        const InformationBannerWidget(
          title: 'Claims Best Practices',
          headerIcon: AppAssets.iconDoc,
          iconBgColor: AppColors.primaryLight,
          points: [
            'Understand the claim process before you need it.',
            'Keep policy documents readily available.',
            'Report incidents to your insurer without delay.',
            'Submit accurate information and required documents',
            'Monitor claim progress and respond to requests promptly.',
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Desktop / tablet: Coverage — step 1 of 7 ─────────────────────────────
  Widget _buildDesktop(BuildContext context, BrandPalette colors) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DesktopStepper(currentStep: 1, onBack: () => context.go('/')),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: ResponsiveContainer(
                padHorizontal: false,
                maxWidth: 1440,
                child: ResponsiveTwoPane(
                  main: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          package: AppConfig.packageName,
                          AppAssets.motorInsuranceBanner2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outline),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              'Select Your Coverage',
                              style: AppTextStyle.headlineSmall,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(height: 20),
                            ResponsiveGrid(
                              mobileColumns: 1,
                              tabletColumns: 2,
                              desktopColumns:
                                  AdaptiveLayout.contentMaxWidth(context) > 900
                                      ? 4
                                      : 2,
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                _DesktopCoverageCard(
                                    title: 'Third-Party Liability',
                                    subtitle: 'Get new car Insurance',
                                    icon: Icons.handshake_outlined,
                                    backgroundColor: colors.border,
                                    iconColor: colors.textPrimary,
                                    onTap: () {
                                      context
                                          .read<MotorInsuranceBloc>()
                                          .add(ResetFormData());
                                      context.push(AppRoutes.userDetailScreen);
                                    }),
                                _DesktopCoverageCard(
                                  title: 'Own Damage',
                                  subtitle: 'Renew your existing Policy',
                                  icon: Icons.build_outlined,
                                  backgroundColor: const Color(0xFFFEF3C7),
                                  iconColor: const Color(0xFFD97706),
                                  onTap: () {},
                                ),
                                _DesktopCoverageCard(
                                  title: 'Third-Party & Comprehensive',
                                  subtitle: 'Intimate & track your claim',
                                  icon: Icons.attach_money,
                                  backgroundColor: AppColors.brandMint,
                                  iconColor: AppColors.brandGreen,
                                  onTap: () {},
                                ),
                                _DesktopCoverageCard(
                                  title: 'Reports',
                                  subtitle: 'View all your Reports',
                                  icon: Icons.menu_book_outlined,
                                  backgroundColor: AppColors.brandLavender,
                                  iconColor: colors.info,
                                  onTap: () => context.push(
                                      AppRoutes.insuranceTransactionScreen),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  rail: const BestPracticesPanel(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopCoverageCard extends StatelessWidget {
  const _DesktopCoverageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Replace standard space after ampersand with non-breaking space (\u00A0)
    // so ampersand and the following word wrap together instead of breaking mid-word.
    final formattedTitle = title.replaceAll(' & ', ' &\u00A0');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 75,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    formattedTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.caption,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    subtitle,
                    style: AppTextStyle.microLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
