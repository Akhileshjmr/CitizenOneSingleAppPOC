import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';
import 'package:citizenone_app/features/agent/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:citizenone_app/features/agent/tasks/presentation/state/agent_tasks_state.dart';

class AgentTasksCubit extends Cubit<AgentTasksState> {
  final GetAllTasksUseCase _getAllTasksUseCase;

  AgentTasksCubit({required GetAllTasksUseCase getAllTasksUseCase})
      : _getAllTasksUseCase = getAllTasksUseCase,
        super(const AgentTasksState());

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final tasks = await _getAllTasksUseCase();
      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load tasks. Please try again.',
      ));
    }
  }

  void setFilter(AgentTaskStatus? status) {
    if (status == null) {
      emit(state.copyWith(clearFilter: true));
    } else {
      emit(state.copyWith(filterStatus: status));
    }
  }
}
