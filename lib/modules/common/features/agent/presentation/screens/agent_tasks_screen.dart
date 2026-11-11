import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/agent_tasks_cubit.dart';
import '../../domain/entities/agent_task_entity.dart';

class AgentTasksScreen extends StatefulWidget {
  const AgentTasksScreen({super.key});

  @override
  State<AgentTasksScreen> createState() => _AgentTasksScreenState();
}

class _AgentTasksScreenState extends State<AgentTasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AgentTasksCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Field Tasks'),
      ),
      body: BlocBuilder<AgentTasksCubit, AgentTasksState>(
        builder: (context, state) {
          if (state is AgentTasksLoading) {
            return const Center(child: AppLoader());
          }

          if (state is AgentTasksError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<AgentTasksCubit>().loadTasks(),
            );
          }

          if (state is AgentTasksLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No field tasks scheduled for today.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                final isDone = task.status == AgentTaskStatus.completed;

                return AppCard(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isDone ? AppPalette.success : AppPalette.neutral400,
                      ),
                      onPressed: () {
                        context
                            .read<AgentTasksCubit>()
                            .toggleTaskStatus(task.id, task.status);
                      },
                    ),
                    title: Text(
                      task.title,
                      style: AppTypography.title3.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${task.subtitle} • Due: ${task.dueDate}',
                      style: AppTypography.body3.copyWith(color: AppPalette.neutral500),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs, vertical: 2),
                      decoration: BoxDecoration(
                        color: _typeColor(task.type).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.type.name.toUpperCase(),
                        style: AppTypography.label3.copyWith(
                          color: _typeColor(task.type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _typeColor(AgentTaskType type) {
    switch (type) {
      case AgentTaskType.collection:
        return AppPalette.warning;
      case AgentTaskType.kyc:
        return AppPalette.kyc;
      case AgentTaskType.partnerVisit:
        return AppPalette.insurance;
      case AgentTaskType.onboarding:
        return AppPalette.primary;
    }
  }
}

