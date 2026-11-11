import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_task_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_cubit.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_state.dart';

/// Displays the agent's pending-task summary card.
/// Pure UI — reads state from [AgentDashboardCubit], dispatches no events.
class AgentTaskAlertWidget extends StatelessWidget {
  const AgentTaskAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return BlocBuilder<AgentDashboardCubit, AgentDashboardState>(
      builder: (context, state) {
        if (state.isLoading) return const _TaskAlertSkeleton();
        final pendingCount = state.pendingTaskCount;
        final tasks = state.tasks
            .where((t) => t.status == AgentTaskStatus.pending)
            .toList();
        final subtitle = tasks
            .map((t) => t.subtitle.split('—').first.trim())
            .join(' • ');

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFDDDDDD).withValues(alpha: 0.5),
                ),
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
                                color: Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                AppAssets.iconAdd,
                                width: 14,
                                height: 14,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF613AF5),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              'Citizen AI Alert',
                              style: AppTextStyle.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E1B4B),
                              letterSpacing: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      '$pendingCount Task${pendingCount != 1 ? 's' : ''} Pending',
                      style: AppTextStyle.displaySmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      subtitle.isEmpty ? 'All caught up!' : subtitle,
                      style: AppTextStyle.bodyMedium,
                      color: tokens.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'View Tasks',
                      height: 40,
                      onPressed: () => context.push('/agent/tasks'),
                      backgroundColor: const Color(0xFF4F46E5),
                      icon: LucideIcons.arrow_right,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TaskAlertSkeleton extends StatelessWidget {
  const _TaskAlertSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
