import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class AgentTaskAlert extends StatelessWidget {
  const AgentTaskAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7FF).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.sparkles, size: 14, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          'CITIZEN AI ALERT',
                          style: AppTextStyle.labelSmall,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E1B4B),
                          letterSpacing: 0.5,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AppText(
                        'AGENT MODE',
                        style: AppTextStyle.labelSmall,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppText(
                  '3 Tasks Pending',
                  style: AppTextStyle.displaySmall,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                AppText(
                  '2 new onboardings • 1 collection nearby',
                  style: AppTextStyle.bodyMedium,
                  color: const Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'View Tasks',
                  onPressed: () {},
                  backgroundColor: const Color(0xFF4F46E5),
                  icon: LucideIcons.arrow_right,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
