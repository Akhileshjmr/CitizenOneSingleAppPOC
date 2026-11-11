import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';

class AgentTasksState {
  final bool isLoading;
  final List<AgentTaskDetailEntity> tasks;
  final AgentTaskStatus? filterStatus;
  final String? errorMessage;

  const AgentTasksState({
    this.isLoading = false,
    this.tasks = const [],
    this.filterStatus,
    this.errorMessage,
  });

  List<AgentTaskDetailEntity> get filteredTasks => filterStatus == null
      ? tasks
      : tasks.where((t) => t.status == filterStatus).toList();

  int get pendingCount =>
      tasks.where((t) => t.status == AgentTaskStatus.pending).length;

  AgentTasksState copyWith({
    bool? isLoading,
    List<AgentTaskDetailEntity>? tasks,
    AgentTaskStatus? filterStatus,
    bool clearFilter = false,
    String? errorMessage,
  }) {
    return AgentTasksState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
