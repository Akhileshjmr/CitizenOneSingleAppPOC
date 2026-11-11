import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_dashboard_entity.dart';
import '../../domain/usecases/get_agent_dashboard_usecase.dart';

abstract class AgentDashboardState extends Equatable {
  const AgentDashboardState();
  @override
  List<Object?> get props => [];
}

class AgentDashboardInitial extends AgentDashboardState {}

class AgentDashboardLoading extends AgentDashboardState {}

class AgentDashboardLoaded extends AgentDashboardState {
  final AgentDashboardEntity dashboard;
  const AgentDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class AgentDashboardError extends AgentDashboardState {
  final String message;
  const AgentDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class AgentDashboardCubit extends Cubit<AgentDashboardState> {
  final GetAgentDashboardUseCase getDashboardUseCase;

  AgentDashboardCubit(this.getDashboardUseCase) : super(AgentDashboardInitial());

  Future<void> loadDashboard() async {
    emit(AgentDashboardLoading());
    try {
      final data = await getDashboardUseCase();
      emit(AgentDashboardLoaded(data));
    } catch (e) {
      emit(AgentDashboardError(e.toString()));
    }
  }

  void reset() {
    emit(AgentDashboardInitial());
  }
}

