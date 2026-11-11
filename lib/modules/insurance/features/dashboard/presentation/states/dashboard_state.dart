part of '../bloc/dashboard_bloc.dart';

enum DashboardStatus { initial, loading, refreshing, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.snapshot,
    this.errorMessage,
    this.isBalanceHidden = false,
    this.activeTab = 0,
  });

  final DashboardStatus status;
  final DashboardSnapshot? snapshot;
  final String? errorMessage;
  final bool isBalanceHidden;
  final int activeTab;

  bool get isLoading => status == DashboardStatus.loading;
  bool get isRefreshing => status == DashboardStatus.refreshing;
  bool get hasData => snapshot != null;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSnapshot? snapshot,
    String? errorMessage,
    bool? isBalanceHidden,
    int? activeTab,
    bool clearError = false,
  }) =>
      DashboardState(
        status: status ?? this.status,
        snapshot: snapshot ?? this.snapshot,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
        activeTab: activeTab ?? this.activeTab,
      );

  @override
  List<Object?> get props =>
      [status, snapshot, errorMessage, isBalanceHidden, activeTab];
}
