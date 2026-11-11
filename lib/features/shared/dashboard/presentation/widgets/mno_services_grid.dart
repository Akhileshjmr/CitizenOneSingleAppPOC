import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class MnoServicesGrid extends StatelessWidget {
  const MnoServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('AVAILABLE SERVICES', style: AppTextStyle.labelSmall, color: tokens.textMuted),
        const SizedBox(height: 24),
        _ServiceCategory(title: 'Mobile Services', items: [
          _ServiceItem('Airtime', LucideIcons.smartphone, const Color(0xFF3B82F6)),
          _ServiceItem('Data Bundles', LucideIcons.wifi, const Color(0xFF06B6D4)),
          _ServiceItem('SMS Packages', LucideIcons.message_square, const Color(0xFF8B5CF6)),
        ]),
        const SizedBox(height: 24),
        _ServiceCategory(title: 'Mobile Money', items: [
          _ServiceItem('Send Money', LucideIcons.send, const Color(0xFF22C55E)),
          _ServiceItem('Withdraw', LucideIcons.arrow_down_to_line, const Color(0xFFEF4444)),
          _ServiceItem('Pay Bills', LucideIcons.receipt, const Color(0xFFF59E0B)),
          _ServiceItem('Buy Goods', LucideIcons.shopping_cart, const Color(0xFF64748B)),
        ]),
        const SizedBox(height: 24),
        _ServiceCategory(title: 'Account Services', items: [
          _ServiceItem('Balance', LucideIcons.wallet, const Color(0xFF3B82F6)),
          _ServiceItem('Mini Statement', LucideIcons.file_text, const Color(0xFF64748B)),
        ]),
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
  final IconData icon;
  final Color iconColor;

  const _ServiceItem(this.label, this.icon, this.iconColor);

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: tokens.outline),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          AppText(label, style: AppTextStyle.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
