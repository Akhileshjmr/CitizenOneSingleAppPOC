import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_insight_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_cubit.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_state.dart';

/// Displays the agent's AI-driven insights section.
/// Pure UI — reads state from [AgentDashboardCubit].
class AgentInsightsWidget extends StatelessWidget {
  const AgentInsightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgentDashboardCubit, AgentDashboardState>(
      builder: (context, state) {
        if (state.isLoading) return const _InsightsSkeleton();
        if (state.insights.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.iconAdd,
                  colorFilter: const ColorFilter.mode(
                    AppColors.serviceMobileBg,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                AppText(
                  'Citizen AI Insights',
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.serviceMobileBg,
                  letterSpacing: 1.0,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...state.insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _InsightCard(insight: insight),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  final AgentInsightEntity insight;

  const _InsightCard({required this.insight});

  void _handleInsightAction(BuildContext context, AgentInsightEntity insight) {
    final route = switch (insight.type) {
      AgentInsightType.pendingCollection => '/agent/collections',
      AgentInsightType.highDemand => '/agent/customers',
      AgentInsightType.kycAlert => '/agent/customers',
      AgentInsightType.salesOpportunity => '/agent/tasks',
    };
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssets.iconAdd,
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    AppColors.roleAgent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              AppText(
                'Citizen AI Alert',
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            insight.title,
            style: AppTextStyle.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          AppText(
            insight.description,
            style: AppTextStyle.bodyMedium,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: insight.actionLabel,
            onPressed: () => _handleInsightAction(context, insight),
            icon: LucideIcons.arrow_right,
            height: 44,
          ),
        ],
      ),
    );
  }
}

class _InsightsSkeleton extends StatelessWidget {
  const _InsightsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
