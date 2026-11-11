import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class PartnerServicesGrid extends StatelessWidget {
  const PartnerServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'AVAILABLE SERVICES',
          style: AppTextStyle.labelSmall,
          color: tokens.textMuted,
        ),
        const SizedBox(height: 24),
        _ServiceCategory(
          title: 'Customer Services',
          items: [
            _ServiceItem(
              'Onboarding',
              AppAssets.iconPersonCheck,
              const Color(0xFF3B82F6),
            ),
            _ServiceItem('eKYC', AppAssets.iconQrCode, const Color(0xFF7C3AED)),
            _ServiceItem(
              'Profile',
              AppAssets.iconSearch,
              const Color(0xFF212121),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ServiceCategory(
          title: 'Money Transfer',
          items: [
            _ServiceItem(
              'Top Up',
              AppAssets.iconAccountBalanceWallet,
              const Color(0xFF16A34A),
            ),
            _ServiceItem(
              'Redeem',
              AppAssets.iconCreditCard,
              const Color(0xFF65A30D),
            ),
            _ServiceItem(
              'Deposit',
              AppAssets.iconUpload,
              const Color(0xFF0D9488),
            ),
            _ServiceItem(
              'Withdrawal',
              AppAssets.iconDownload,
              const Color(0xFFDC2626),
            ),
            _ServiceItem(
              'Transfer',
              AppAssets.iconSyncAlt,
              const Color(0xFF7C3AED),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ServiceCategory(
          title: 'Loan Services',
          items: [
            _ServiceItem(
              'Apply Loan',
              AppAssets.iconNote,
              const Color(0xFFB45309),
              route: '/loans',
            ),
            _ServiceItem(
              'Repay (Cust)',
              AppAssets.iconCalendarToday,
              const Color(0xFFC2410C),
            ),
            _ServiceItem(
              'Repay (Acc)',
              AppAssets.iconCreditCard,
              const Color(0xFF0F766E),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceCategory extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _ServiceCategory({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, style: AppTextStyle.headlineSmall),
        const SizedBox(height: 16),
        Wrap(spacing: 20, runSpacing: 24, children: items),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String label;
  final String icon;
  final Color iconColor;
  final String? route;

  const _ServiceItem(this.label, this.icon, this.iconColor, {this.route});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return InkWell(
      onTap: route != null ? () => context.push(route!) : null,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: tokens.outline),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              label,
              style: AppTextStyle.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
