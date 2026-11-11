import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/agent_dashboard_cubit.dart';
import '../../domain/entities/agent_dashboard_entity.dart';
import '../../domain/entities/agent_task_entity.dart';

class AgentDashboardScreen extends StatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  State<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends State<AgentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AgentDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Field Operations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            tooltip: 'Customer Directory',
            onPressed: () => context.push('/agent/customers'),
          ),
          IconButton(
            icon: const Icon(Icons.task_alt_outlined),
            tooltip: 'Daily Tasks',
            onPressed: () => context.push('/agent/tasks'),
          ),
        ],
      ),
      body: BlocBuilder<AgentDashboardCubit, AgentDashboardState>(
        builder: (context, state) {
          if (state is AgentDashboardLoading) {
            return const Center(child: AppLoader());
          }

          if (state is AgentDashboardError) {
            return AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<AgentDashboardCubit>().loadDashboard(),
            );
          }

          if (state is AgentDashboardLoaded) {
            final data = state.dashboard;
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<AgentDashboardCubit>().loadDashboard();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAgentHeader(data),
                    const SizedBox(height: AppSpacing.md),
                    _buildMetricsGrid(data),
                    const SizedBox(height: AppSpacing.lg),
                    _buildServiceLauncher(context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTasksPreview(context, data.recentTasks),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAgentHeader(AgentDashboardEntity data) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppPalette.primary.withValues(alpha: 0.15),
              child: Text(
                data.agentName.substring(0, 2).toUpperCase(),
                style: AppTypography.title2.copyWith(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.agentName,
                    style: AppTypography.title2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Agent ID: ${data.agentCode} • Lusaka Urban District',
                    style: AppTypography.body3.copyWith(
                      color: AppPalette.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppPalette.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ONLINE',
                style: AppTypography.label3.copyWith(
                  color: AppPalette.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(AgentDashboardEntity data) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Collections Today',
            value: 'ZMW ${data.totalCollectionsToday.toStringAsFixed(0)}',
            icon: Icons.payments_outlined,
            color: AppPalette.success,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricCard(
            label: 'Pending Tasks',
            value: '${data.pendingTasksCount}',
            icon: Icons.schedule_outlined,
            color: AppPalette.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricCard(
            label: 'Commission',
            value: 'ZMW ${data.commissionEarned.toStringAsFixed(0)}',
            icon: Icons.monetization_on_outlined,
            color: AppPalette.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceLauncher(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agent Service Operations',
          style: AppTypography.title2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ServiceLauncherCard(
                icon: Icons.account_balance,
                label: 'Agency Banking',
                color: AppPalette.agencyBanking,
                onTap: () => context.push('/agency-banking'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ServiceLauncherCard(
                icon: Icons.health_and_safety,
                label: 'Insurance',
                color: AppPalette.insurance,
                onTap: () => context.push('/insurance'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ServiceLauncherCard(
                icon: Icons.credit_score,
                label: 'Micro Loans',
                color: AppPalette.loans,
                onTap: () => context.push('/loans'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ServiceLauncherCard(
                icon: Icons.verified,
                label: 'KYC Flow',
                color: AppPalette.kyc,
                onTap: () => context.push('/kyc'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTasksPreview(BuildContext context, List<AgentTaskEntity> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Priority Tasks for Today',
              style: AppTypography.title2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/agent/tasks'),
              child: const Text('View All Tasks'),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return AppCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      task.status == AgentTaskStatus.completed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.status == AgentTaskStatus.completed
                          ? AppPalette.success
                          : AppPalette.neutral400,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: AppTypography.label1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${task.subtitle} • Due ${task.dueDate}',
                            style: AppTypography.label3.copyWith(
                              color: AppPalette.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.title3.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: AppTypography.label3.copyWith(
                color: AppPalette.neutral500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceLauncherCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceLauncherCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.label3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

