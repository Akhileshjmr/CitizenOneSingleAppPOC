import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class AgentInsights extends StatelessWidget {
  const AgentInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.sparkles, size: 16, color: Color(0xFF9333EA)),
            const SizedBox(width: 8),
            AppText(
              'CITIZEN AI INSIGHTS',
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7E22CE),
              letterSpacing: 1.0,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          context: context,
          title: 'High Demand Area',
          description: 'Sector 4 has 15 merchants waiting for onboarding.',
          buttonText: 'View Map',
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          context: context,
          title: 'Pending Collections',
          description: '3 merchants have skipped payment this week.',
          buttonText: 'View List',
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 12, color: Color(0xFFA855F7)),
              const SizedBox(width: 6),
              AppText(
                'CITIZEN AI ALERT',
                style: AppTextStyle.labelSmall,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(title, style: AppTextStyle.headlineSmall, fontWeight: FontWeight.bold),
          const SizedBox(height: 4),
          AppText(description, style: AppTextStyle.bodyMedium, color: const Color(0xFF475569), height: 1.4),
          const SizedBox(height: 16),
          AppButton(
            text: buttonText,
            onPressed: () {},
            backgroundColor: const Color(0xFF4F46E5),
            icon: LucideIcons.arrow_right,
            height: 44,
          ),
        ],
      ),
    );
  }
}
