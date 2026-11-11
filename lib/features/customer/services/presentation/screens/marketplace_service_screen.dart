import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/components/shared/section_header.dart';
import 'package:citizenone_app/components/shared/service_list_tile.dart';
import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

class MarketplaceServiceScreen extends StatelessWidget {
  const MarketplaceServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    double horizontalPadding = ResponsiveLayout.isDesktop(context) ? 64 : 20;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          context.l10n.serviceMarketplaceTitle,
          style: AppTextStyle.headlineSmall,
        ),
        centerTitle: false,
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        foregroundColor: tokens.textPrimary,
      ),
      body: CustomScrollView(
        slivers: [
          // Hero Section - Sales Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.serviceMarketBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.serviceMarketBg.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'ZK 4,820.00',
                      style: AppTextStyle.metricLarge,
                      color: tokens.background,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      context.l10n.serviceMarketplaceSalesToday,
                      style: AppTextStyle.titleSmall,
                      color: tokens.background,
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: AppColors.serviceLightPinkBg.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          context.l10n.serviceMarketplaceOrdersPending(12),
                          style: AppTextStyle.bodyLarge,
                          color: tokens.background,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              AppText(
                                context.l10n.labelActionView,
                                style: AppTextStyle.bodyMedium,
                                color: tokens.background,
                                fontSize: 12,
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          // Quick Actions
          SliverToBoxAdapter(
            child: QuickActionsWidget(
              sectionTitle: context.l10n.dashboardSectionQuickActions,
              showContainerBackground: true,
              sectionPadding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              itemsPerRow: 4,
              items: [
                QuickActionItem(
                  title: context.l10n.serviceHealthActionVitals,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.serviceOrangeBg,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconElectricBolt,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFF97316),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceHealthActionMedicines,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.serviceBlueBg,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconWaterDrop,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF3B82F6),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceHealthActionLabs,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.serviceLightPinkBg,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconMobile,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFEC4899),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceBillPayActionAddNew,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBg,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconAdd,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF6B7280),
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
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Services List
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SectionHeader(
                title: context.l10n.serviceMarketplaceSectionServices,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  ServiceListTile(
                    title: context.l10n.serviceMarketplaceCatalog,
                  ),
                  ServiceListTile(
                    title: context.l10n.serviceMarketplaceReviews,
                  ),
                  ServiceListTile(
                    title: context.l10n.serviceMarketplaceSupport,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // AI Assistants
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.iconAdd,
                    colorFilter: ColorFilter.mode(
                      AppColors.serviceMarketBg,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    context.l10n.labelAiAssistants,
                    style: AppTextStyle.bodyLarge,
                    color: AppColors.serviceMarketBg,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: tokens.outline),
                  boxShadow: tokens.shadowSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                              AppColors.serviceMarketBg,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        AppText(
                          context.l10n.heroCardCitizenLabel,
                          style: AppTextStyle.bodyLarge,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      context.l10n.serviceMarketplaceAiDemandForecast,
                      style: AppTextStyle.headlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      context.l10n.serviceMarketplaceAiDemandForecastDesc,
                      style: AppTextStyle.bodyMedium,
                      color: tokens.textSecondary,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      onPressed: () {},
                      height: 40,
                      text: context.l10n.serviceActionViewDetails,
                      backgroundColor: AppColors.serviceMarketBg,
                      icon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
