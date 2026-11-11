import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/usecases/get_agent_tasks_usecase.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/usecases/get_agent_insights_usecase.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_state.dart';

/// Cubit for the Agent Dashboard.
///
/// Responsibilities (SRP):
///   - Load agent tasks and AI insights via injected Use Cases.
///   - Emit clean [AgentDashboardState] for the UI to render.
///
/// No UI logic or routing code lives here (per SKILL.md §7).
class AgentDashboardCubit extends Cubit<AgentDashboardState> {
  final GetAgentTasksUseCase _getTasksUseCase;
  final GetAgentInsightsUseCase _getInsightsUseCase;

  AgentDashboardCubit({
    required GetAgentTasksUseCase getTasksUseCase,
    required GetAgentInsightsUseCase getInsightsUseCase,
  })  : _getTasksUseCase = getTasksUseCase,
        _getInsightsUseCase = getInsightsUseCase,
        super(const AgentDashboardState());

  /// Loads both tasks and insights in parallel for efficiency.
  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final results = await Future.wait([
        _getTasksUseCase(),
        _getInsightsUseCase(),
      ]);
      emit(state.copyWith(
        tasks: results[0] as dynamic,
        insights: results[1] as dynamic,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load dashboard. Please try again.',
      ));
    }
  }
}
