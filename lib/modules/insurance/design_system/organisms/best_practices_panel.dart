// =============================================================================
// BestPracticesPanel  —  ORGANISM (desktop-only)
// -----------------------------------------------------------------------------
// The right-rail pair of static advisory cards shown on the desktop Coverage
// and Customer Details screens (purple "Motor Insurance Best Practices" +
// green "Claims Best Practices"), matching the desktop SVG reference.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class BestPracticesPanel extends StatelessWidget {
  const BestPracticesPanel({super.key});

  static const _motorInsurancePoints = [
    'Keep your motor insurance policy active and up to date.',
    'Renew your policy before expiry to avoid coverage gaps.',
    'Carry your insurance certificate and policy details.',
    'Report accidents promptly and follow the claim process.',
    'Drive safely to minimize risks and claims.',
  ];

  static const _claimsPoints = [
    'Understand the claim process before you need it.',
    'Keep policy documents readily available.',
    'Report incidents to your insurer without delay.',
    'Submit accurate information and required documents.',
    'Monitor claim progress and respond to requests promptly.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BestPracticeCard(
          title: 'Motor Insurance Best Practices',
          icon: Icons.shield_outlined,
          headerColor: AppColors.primary,
          bulletColor: AppColors.primary,
          points: _motorInsurancePoints,
        ),
        const SizedBox(height: 20),
        _BestPracticeCard(
          title: 'Claims Best Practices',
          icon: Icons.description_outlined,
          headerColor: AppColors.bestPracticesGreen,
          bulletColor: AppColors.bestPracticesGreen,
          points: _claimsPoints,
        ),
      ],
    );
  }
}

class _BestPracticeCard extends StatelessWidget {
  const _BestPracticeCard({
    required this.title,
    required this.icon,
    required this.headerColor,
    required this.bulletColor,
    required this.points,
  });

  final String title;
  final IconData icon;
  final Color headerColor;
  final Color bulletColor;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    title,
                    style: AppTextStyle.bodyLarge,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final point in points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: bulletColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppText(
                            point,
                            style: AppTextStyle.bodySmall,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
