import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class BankPartnerCard extends StatelessWidget {
  final String partnerName;
  final IconData partnerIcon;
  final VoidCallback onSwitch;
  final String? partnerType;

  const BankPartnerCard({
    super.key,
    required this.partnerName,
    required this.partnerIcon,
    required this.onSwitch,
    this.partnerType,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onSwitch,
                icon: Icon(
                  Icons.chevron_left,
                  color: tokens.textMuted,
                  size: 18,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: tokens.surfaceSoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(partnerIcon, color: tokens.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'ACTIVE PARTNER',
                      style: AppTextStyle.labelSmall,
                      color: tokens.primary,
                      letterSpacing: 1.0,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      partnerName,
                      style: AppTextStyle.displaySmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (partnerType == 'Bank') ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tokens.surfaceSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tokens.outline),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(
                              'ACCOUNT BALANCE',
                              style: AppTextStyle.labelSmall,
                              color: tokens.textMuted,
                              letterSpacing: 0.5,
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              LucideIcons.eye_off,
                              size: 12,
                              color: tokens.textMuted,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          'K 125,000.50',
                          style: AppTextStyle.titleSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  Container(height: 32, width: 1, color: tokens.outline),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'WALLET BALANCE',
                          style: AppTextStyle.labelSmall,
                          color: tokens.textMuted,
                          letterSpacing: 0.5,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          'K 4,500.00',
                          style: AppTextStyle.titleSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
