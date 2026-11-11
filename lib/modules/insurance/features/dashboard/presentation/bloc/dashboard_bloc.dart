// =============================================================================
// DashboardBloc  —  PRESENTATION
// -----------------------------------------------------------------------------
// Pure orchestration. Holds no business logic, no formatting, no UI. It
// only:
//   1. Dispatches use cases
//   2. Maps Either<Failure, T> into a typed DashboardState
//   3. Tracks ephemeral UI state (balance visibility, active tab)
// =============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/usecase.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/usecases/get_dashboard_snapshot.dart';

part 'dashboard_event.dart';
part '../states/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required GetDashboardSnapshot getDashboardSnapshot,
    required RefreshDashboardSnapshot refreshDashboardSnapshot,
  })  : _getSnapshot = getDashboardSnapshot,
        _refreshSnapshot = refreshDashboardSnapshot,
        super(const DashboardState()) {
    on<DashboardRequested>(_onRequested);
    on<DashboardRefreshed>(_onRefreshed);
    on<DashboardBalanceVisibilityToggled>(_onToggleVisibility);
    on<DashboardTabChanged>(_onTabChanged);
  }

  final GetDashboardSnapshot _getSnapshot;
  final RefreshDashboardSnapshot _refreshSnapshot;

  Future<void> _onRequested(
      DashboardRequested event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading, clearError: true));
    final result = await _getSnapshot(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (snapshot) => emit(state.copyWith(
        status: DashboardStatus.success,
        snapshot: snapshot,
      )),
    );
  }

  Future<void> _onRefreshed(
      DashboardRefreshed event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.refreshing, clearError: true));
    final result = await _refreshSnapshot(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (snapshot) => emit(state.copyWith(
        status: DashboardStatus.success,
        snapshot: snapshot,
      )),
    );
  }

  void _onToggleVisibility(
    DashboardBalanceVisibilityToggled event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(isBalanceHidden: !state.isBalanceHidden));
  }

  void _onTabChanged(
      DashboardTabChanged event, Emitter<DashboardState> emit) {
    emit(state.copyWith(activeTab: event.index));
  }
}
