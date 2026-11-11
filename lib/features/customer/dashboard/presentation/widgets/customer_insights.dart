import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:flutter_svg/svg.dart';

class CustomerInsights extends StatelessWidget {
  const CustomerInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppAssets.iconAdd,
              height: 18,
              colorFilter: ColorFilter.mode(Color(0xFFA855F7), BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            AppText(
              'Citizen AI Insights',
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFA855F7),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          context: context,
          alertText: 'Citizen AI Alert',
          title: 'Due Today',
          description: 'Electricity Bill (ZK 450) is due. Avoid late fees.',
          buttonText: 'Pay Now',
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          context: context,
          alertText: 'Citizen AI Alert',
          title: 'Recommended',
          description: 'Based on your spending, save ZK 1200 with Gold Plan.',
          buttonText: 'View Plan',
          icon: AppAssets.iconAdd,
          iconBgColor: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          context: context,
          alertText: 'Citizen AI Alert',
          title: 'Continue',
          description: 'Resume your Home Loan application where you left off.',
          buttonText: 'Resume',
          icon: AppAssets.iconAdd,
          iconBgColor: const Color(0xFFDBEAFE),
          iconColor: const Color(0xFF2563EB),
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required BuildContext context,
    required String alertText,
    required String title,
    required String description,
    required String buttonText,
    String? icon,
    Color? iconBgColor,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    icon,
                    height: 18,
                    colorFilter: ColorFilter.mode(iconColor!, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              AppText(
                alertText,
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppText(
            title,
            style: AppTextStyle.displaySmall,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
          const SizedBox(height: 6),
          AppText(
            description,
            style: AppTextStyle.bodyMedium,
            color: const Color(0xFF475569),
            height: 1.4,
          ),
          const SizedBox(height: 20),
          AppButton(
            text: buttonText,
            height: 40,
            onPressed: () {},
            icon: LucideIcons.arrow_right,
          ),
        ],
      ),
    );
  }
}
