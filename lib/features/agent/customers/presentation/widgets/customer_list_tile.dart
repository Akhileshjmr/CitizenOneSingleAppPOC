import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';

class CustomerListTile extends StatelessWidget {
  final AgentCustomerEntity customer;

  const CustomerListTile({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final (statusLabel, statusBg, statusFg) = _statusStyle(customer.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.outline),
        boxShadow: tokens.shadowSm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF4F46E5).withValues(alpha: 0.12),
            child: AppText(
              customer.name[0].toUpperCase(),
              style: AppTextStyle.titleSmall,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        customer.name,
                        style: AppTextStyle.bodyMedium,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AppText(
                        statusLabel,
                        style: AppTextStyle.labelSmall,
                        fontWeight: FontWeight.w700,
                        color: statusFg,
                      ),
                    ),
                  ],
                ),
                if (customer.businessType != null) ...[
                  const SizedBox(height: 3),
                  AppText(
                    customer.businessType!,
                    style: AppTextStyle.caption,
                    color: tokens.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.phone, size: 12, color: tokens.textMuted),
                    const SizedBox(width: 4),
                    AppText(customer.phone, style: AppTextStyle.caption, color: tokens.textMuted),
                    const SizedBox(width: 12),
                    Icon(LucideIcons.map_pin, size: 12, color: tokens.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: AppText(
                        customer.location,
                        style: AppTextStyle.caption,
                        color: tokens.textMuted,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(LucideIcons.chevron_right, size: 16, color: tokens.textMuted),
        ],
      ),
    );
  }

  (String, Color, Color) _statusStyle(CustomerStatus status) {
    switch (status) {
      case CustomerStatus.active:
        return ('Active', const Color(0xFFDCFCE7), const Color(0xFF059669));
      case CustomerStatus.kycPending:
        return ('KYC Pending', const Color(0xFFFEF3C7), const Color(0xFFD97706));
      case CustomerStatus.onboarding:
        return ('Onboarding', const Color(0xFFE0E7FF), const Color(0xFF4F46E5));
      case CustomerStatus.inactive:
        return ('Inactive', const Color(0xFFF3F4F6), const Color(0xFF9CA3AF));
    }
  }
}
