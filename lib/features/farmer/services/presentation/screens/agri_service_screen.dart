import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

class AgriServiceScreen extends StatelessWidget {
  const AgriServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = ResponsiveLayout.isDesktop(context) ? 64 : 20;
    const greenColor = Color(0xFF16A34A);

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          'Agri Services',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        foregroundColor: Colors.black,
      ),
      body: CustomScrollView(
        slivers: [
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
                  color: greenColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: greenColor.withValues(alpha: 0.3),
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
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.cloud_rain,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              "TODAY'S WEATHER",
                              style: AppTextStyle.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 1.2,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.sprout,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      '24°C',
                      style: AppTextStyle.metricLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      'Light Rain expected in afternoon',
                      style: AppTextStyle.bodyMedium,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'View Forecast',
                            onPressed: () {},
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppButton(
                            text: 'Mandi Rates',
                            onPressed: () {},
                            backgroundColor: Colors.white,
                            foregroundColor: greenColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: QuickActionsWidget(
              sectionTitle: 'Quick Actions',
              showContainerBackground: true,
              sectionPadding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              itemsPerRow: 4,
              items: [
                QuickActionItem(
                  title: 'Agri Loan',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconSprout,
                      colorFilter: const ColorFilter.mode(Color(0xFF16A34A), BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Buy Inputs',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconShoppingBag,
                      colorFilter: const ColorFilter.mode(Color(0xFFEA580C), BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Sell Crop',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconShoppingCart,
                      colorFilter: const ColorFilter.mode(Color(0xFF2563EB), BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Insurance',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconShield,
                      colorFilter: const ColorFilter.mode(Color(0xFFDC2626), BlendMode.srcIn),
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

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const SectionHeader(title: 'Services'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  ServiceListTile(title: 'Crop Advisory Services'),
                  ServiceListTile(title: 'Mandi Prices Live'),
                  ServiceListTile(title: 'Soil Health Card'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  const Icon(LucideIcons.sparkles, size: 16, color: greenColor),
                  const SizedBox(width: 8),
                  AppText(
                    'AI ASSISTANTS',
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.bold,
                    color: greenColor,
                    letterSpacing: 1.0,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.sparkles,
                            size: 12,
                            color: greenColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        AppText(
                          'CITIZEN AI ALERT',
                          style: AppTextStyle.labelSmall,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: const Color(0xFF64748B),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      'Yield Prediction',
                      style: AppTextStyle.headlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      'Expected yield is 4.5 tons/hectare based on current weather.',
                      style: AppTextStyle.bodyMedium,
                      color: AppColors.textSecondary,
                      height: 1.5,
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
