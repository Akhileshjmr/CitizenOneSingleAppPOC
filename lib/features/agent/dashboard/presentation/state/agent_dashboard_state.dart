import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_task_entity.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/entities/agent_insight_entity.dart';

/// Immutable state for the Agent Dashboard Cubit.
/// Represents all possible UI phases: initial, loading, loaded, error.
class AgentDashboardState {
  final List<AgentTaskEntity> tasks;
  final List<AgentInsightEntity> insights;
  final bool isLoading;
  final String? errorMessage;

  const AgentDashboardState({
    this.tasks = const [],
    this.insights = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AgentDashboardState copyWith({
    List<AgentTaskEntity>? tasks,
    List<AgentInsightEntity>? insights,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AgentDashboardState(
      tasks: tasks ?? this.tasks,
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Convenience getters for the UI.
  int get pendingTaskCount =>
      tasks.where((t) => t.status == AgentTaskStatus.pending).length;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
