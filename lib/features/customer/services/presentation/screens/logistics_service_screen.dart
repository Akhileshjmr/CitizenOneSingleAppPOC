import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/components/shared/section_header.dart';
import 'package:citizenone_app/components/shared/service_list_tile.dart';
import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

class LogisticsServiceScreen extends StatelessWidget {
  const LogisticsServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    double horizontalPadding = ResponsiveLayout.isDesktop(context) ? 64 : 20;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          context.l10n.serviceLogisticsTitle,
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
          // Hero Section - Active Shipments
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: tokens.brandOrange,
                  borderRadius: BorderRadius.circular(24),
                  gradient: tokens.gradientLogistics,
                  boxShadow: [
                    BoxShadow(
                      color: tokens.brandOrange.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          '3', // TODO: Fetch from Shipments Cubit
                          style: AppTextStyle.heroValue,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.truck,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    AppText(
                      context.l10n.serviceLogisticsActiveShipments,
                      style: AppTextStyle.bodyLarge,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 24),

                    // Status alert bar inside card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: tokens.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppText(
                              context.l10n.serviceLogisticsDeliveryAlert(
                                '4 PM',
                              ),
                              style: AppTextStyle.bodyMedium,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPressed: () {},
                        text: context.l10n.serviceLogisticsActionTrackAll,
                        backgroundColor: tokens.surface,
                        foregroundColor: tokens.brandOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

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
                  title: context.l10n.serviceLogisticsActionBookNow,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconTruck,
                      colorFilter: ColorFilter.mode(tokens.brandOrange, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceLogisticsActionTrack,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconMap,
                      colorFilter: ColorFilter.mode(tokens.brandBlue, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceLogisticsActionCalcFare,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.surfaceMuted,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconCalculate,
                      colorFilter: ColorFilter.mode(tokens.textSecondary, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: context.l10n.serviceLogisticsActionMyOrders,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tokens.brandPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconMap,
                      colorFilter: ColorFilter.mode(tokens.brandPurple, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Services List
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SectionHeader(
                title: context.l10n.serviceLogisticsSectionServices,
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
                    title: context.l10n.serviceLogisticsWarehousing,
                  ),
                  ServiceListTile(title: context.l10n.serviceLogisticsFleet),
                  ServiceListTile(
                    title: context.l10n.serviceLogisticsPastShipments,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // AI Assistants
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Icon(LucideIcons.sparkles, size: 16, color: tokens.brandBlue),
                  const SizedBox(width: 8),
                  AppText(
                    context.l10n.labelAiAssistants,
                    style: AppTextStyle.labelSmall,
                    color: tokens.brandBlue,
                    fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: tokens.brandBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.sparkles,
                            size: 12,
                            color: tokens.brandBlue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        AppText(
                          context.l10n.heroCardCitizenLabel.toUpperCase(),
                          style: AppTextStyle.labelSmall,
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      context.l10n.serviceLogisticsAiRouteOptimization,
                      style: AppTextStyle.headlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      context.l10n.serviceLogisticsAiRouteOptimizationDesc(
                        '4582',
                        'Highway 9',
                      ),
                      style: AppTextStyle.bodyMedium,
                      color: tokens.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}
