import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class InsuranceServicesGrid extends StatelessWidget {
  const InsuranceServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('AVAILABLE SERVICES', style: AppTextStyle.labelSmall, color: tokens.textMuted),
        const SizedBox(height: 24),
        _ServiceCategory(title: 'Policy Services', items: [
          _ServiceItem('New Policy', LucideIcons.file_plus, const Color(0xFF3B82F6)),
          _ServiceItem('Renewals', LucideIcons.refresh_cw, const Color(0xFF22C55E)),
          _ServiceItem('Policy Status', LucideIcons.search, const Color(0xFF64748B)),
        ]),
        const SizedBox(height: 24),
        _ServiceCategory(title: 'Claims & Support', items: [
          _ServiceItem('File Claim', LucideIcons.file_text, const Color(0xFFF59E0B)),
          _ServiceItem('Claim Status', LucideIcons.activity, const Color(0xFF06B6D4)),
          _ServiceItem('Documents', LucideIcons.folder, const Color(0xFF8B5CF6)),
        ]),
        const SizedBox(height: 24),
        _ServiceCategory(title: 'Premium & Payments', items: [
          _ServiceItem('Pay Premium', LucideIcons.credit_card, const Color(0xFF22C55E)),
          _ServiceItem('Payment History', LucideIcons.receipt, const Color(0xFF64748B)),
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
