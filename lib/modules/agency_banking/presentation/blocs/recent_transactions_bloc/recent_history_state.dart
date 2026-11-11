import 'package:citizenone_app/modules/agency_banking/data/models/AccountTransHistory.dart';

abstract class RecentHistoryState {}

class RecentHistoryInitial extends RecentHistoryState {}

class RecentHistoryLoading extends RecentHistoryState {}

class RecentHistorySuccess extends RecentHistoryState {
  final String message;
  final AccountTransHistory transHistory;
  RecentHistorySuccess(this.message, this.transHistory);
}

class RecentHistoryFailure extends RecentHistoryState {
  final String error;
  RecentHistoryFailure(this.error);
}
