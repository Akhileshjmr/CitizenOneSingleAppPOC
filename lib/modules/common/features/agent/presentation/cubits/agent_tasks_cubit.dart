import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_task_entity.dart';
import '../../domain/usecases/get_agent_tasks_usecase.dart';

abstract class AgentTasksState extends Equatable {
  const AgentTasksState();
  @override
  List<Object?> get props => [];
}

class AgentTasksInitial extends AgentTasksState {}

class AgentTasksLoading extends AgentTasksState {}

class AgentTasksLoaded extends AgentTasksState {
  final List<AgentTaskEntity> tasks;
  final AgentTaskStatus? activeFilter;

  const AgentTasksLoaded({required this.tasks, this.activeFilter});

  @override
  List<Object?> get props => [tasks, activeFilter];
}

class AgentTasksError extends AgentTasksState {
  final String message;
  const AgentTasksError(this.message);

  @override
  List<Object?> get props => [message];
}

class AgentTasksCubit extends Cubit<AgentTasksState> {
  final GetAgentTasksUseCase getTasksUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;

  AgentTasksCubit({
    required this.getTasksUseCase,
    required this.updateTaskStatusUseCase,
  }) : super(AgentTasksInitial());

  Future<void> loadTasks({AgentTaskStatus? filter}) async {
    emit(AgentTasksLoading());
    try {
      final tasks = await getTasksUseCase(status: filter);
      emit(AgentTasksLoaded(tasks: tasks, activeFilter: filter));
    } catch (e) {
      emit(AgentTasksError(e.toString()));
    }
  }

  Future<void> toggleTaskStatus(String taskId, AgentTaskStatus current) async {
    final newStatus = current == AgentTaskStatus.completed
        ? AgentTaskStatus.pending
        : AgentTaskStatus.completed;

    try {
      final updated = await updateTaskStatusUseCase(taskId, newStatus);
      if (state is AgentTasksLoaded) {
        final currentList = (state as AgentTasksLoaded).tasks;
        final updatedList = currentList.map((t) {
          return t.id == taskId ? updated : t;
        }).toList();
        emit(AgentTasksLoaded(
          tasks: updatedList,
          activeFilter: (state as AgentTasksLoaded).activeFilter,
        ));
      }
    } catch (e) {
      emit(AgentTasksError(e.toString()));
    }
  }

  void reset() {
    emit(AgentTasksInitial());
  }
}

