import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.dashboardSectionRecentActivity,
          actionLabel: context.l10n.dashboardActionViewAll,
          onActionTap: () {},
        ),
        SizedBox(height: tokens.spacingMd),
        _ActivityTile(
          title: 'Grocery Store',
          subtitle: 'Today, 10:30 AM',
          amount: '-ZK 240.00',
          icon: AppAssets.iconShoppingCart,
          iconBg: const Color(0xFFEDF7E6),
        ),
        _ActivityTile(
          title: 'City Power',
          subtitle: 'Yesterday, 4:15 PM',
          amount: '-ZK 450.00',
          icon: AppAssets.iconElectricBolt,
          iconBg: const Color(0xFFFEF1E7),
        ),
        _ActivityTile(
          title: 'Coffee Shop',
          subtitle: 'Yesterday, 9:00 AM',
          amount: '-ZK 55.00',
          icon: AppAssets.iconStoreFront,
          iconBg: const Color(0xFFFAEFFF),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String icon;
  final Color iconBg;

  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                AppText(
                  subtitle,
                  style: AppTextStyle.bodySmall,
                  color: tokens.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          AppText(
            amount,
            style: AppTextStyle.bodyLarge,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
