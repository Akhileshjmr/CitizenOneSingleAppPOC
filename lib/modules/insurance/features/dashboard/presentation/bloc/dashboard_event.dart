part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => const [];
}

class DashboardRequested extends DashboardEvent {
  const DashboardRequested();
}

class DashboardRefreshed extends DashboardEvent {
  const DashboardRefreshed();
}

class DashboardBalanceVisibilityToggled extends DashboardEvent {
  const DashboardBalanceVisibilityToggled();
}

class DashboardTabChanged extends DashboardEvent {
  const DashboardTabChanged(this.index);
  final int index;
  @override
  List<Object?> get props => [index];
}
