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

class SmeServiceScreen extends StatelessWidget {
  const SmeServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = ResponsiveLayout.isDesktop(context) ? 64 : 20;
    const blueColor = Color(0xFF4F46E5);

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          'SME Services',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              'Green Grocers Ltd',
                              style: AppTextStyle.displaySmall,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              'Reg: 5829-4829',
                              style: AppTextStyle.bodySmall,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText(
                            'Active',
                            style: AppTextStyle.caption,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            '+ZK 240k',
                            'CASHFLOW',
                            const Color(0xFFF9FAFB),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatBox(
                            'Compliant',
                            'TAX STATUS',
                            const Color(0xFFF0FDF4),
                            valueColor: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Start Business Health Check',
                      onPressed: () {},
                      backgroundColor: blueColor,
                      icon: Icons.bar_chart,
                    ),
                  ],
                ),
              ),
            ),
          ),

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
                  title: 'Business Loan',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconCurrency,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2563EB),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'File GST',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconCurrency,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF9333EA),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Licenses',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconFileCopy,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF059669),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Reports',
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconPersonAddAlt,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF4B5563),
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
                  ServiceListTile(title: 'Manage Employees'),
                  ServiceListTile(title: 'Vendor Payments'),
                  ServiceListTile(title: 'Government Schemes'),
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
                  const Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: Color(0xFF4F46E5),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    'AI ASSISTANTS',
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4F46E5),
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
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.sparkles,
                            size: 12,
                            color: Color(0xFF4F46E5),
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
                      'Credit Limit',
                      style: AppTextStyle.headlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      'You available for an credit limit increase to ZK 500k based on recent cashflow.',
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

  Widget _buildStatBox(
    String value,
    String label,
    Color bg, {
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: AppTextStyle.labelSmall,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 8),
          AppText(
            value,
            style: AppTextStyle.headlineSmall,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
