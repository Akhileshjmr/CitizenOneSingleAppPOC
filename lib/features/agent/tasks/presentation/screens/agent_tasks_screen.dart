import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';
import 'package:citizenone_app/features/agent/tasks/presentation/state/agent_tasks_cubit.dart';
import 'package:citizenone_app/features/agent/tasks/presentation/state/agent_tasks_state.dart';
import 'package:citizenone_app/features/agent/tasks/presentation/widgets/task_list_tile.dart';

class AgentTasksScreen extends StatelessWidget {
  const AgentTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AgentTasksCubit>(
      create: (_) => sl<AgentTasksCubit>()..loadTasks(),
      child: const _AgentTasksView(),
    );
  }
}

class _AgentTasksView extends StatelessWidget {
  const _AgentTasksView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          'My Tasks',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
        actions: [
          BlocBuilder<AgentTasksCubit, AgentTasksState>(
            builder: (context, state) => state.pendingCount > 0
                ? Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      '${state.pendingCount} Pending',
                      style: AppTextStyle.caption,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(),
          Expanded(
            child: BlocBuilder<AgentTasksCubit, AgentTasksState>(
              builder: (context, state) {
                if (state.isLoading) return const _TasksSkeleton();
                if (state.errorMessage != null) {
                  return Center(
                    child: AppText(
                      state.errorMessage!,
                      style: AppTextStyle.bodyMedium,
                      color: tokens.error,
                    ),
                  );
                }
                if (state.filteredTasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt, size: 48, color: tokens.textMuted),
                        const SizedBox(height: 12),
                        AppText(
                          'No tasks found',
                          style: AppTextStyle.bodyMedium,
                          color: tokens.textSecondary,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.filteredTasks.length,
                  itemBuilder: (_, i) =>
                      TaskListTile(task: state.filteredTasks[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocBuilder<AgentTasksCubit, AgentTasksState>(
      builder: (context, state) {
        return Container(
          color: tokens.surface,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: state.filterStatus == null,
                  onTap: () => context.read<AgentTasksCubit>().setFilter(null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pending',
                  selected: state.filterStatus == AgentTaskStatus.pending,
                  onTap: () => context.read<AgentTasksCubit>().setFilter(
                    AgentTaskStatus.pending,
                  ),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'In Progress',
                  selected: state.filterStatus == AgentTaskStatus.inProgress,
                  onTap: () => context.read<AgentTasksCubit>().setFilter(
                    AgentTaskStatus.inProgress,
                  ),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Completed',
                  selected: state.filterStatus == AgentTaskStatus.completed,
                  onTap: () => context.read<AgentTasksCubit>().setFilter(
                    AgentTaskStatus.completed,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AppText(
          label,
          style: AppTextStyle.bodySmall,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _TasksSkeleton extends StatelessWidget {
  const _TasksSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
