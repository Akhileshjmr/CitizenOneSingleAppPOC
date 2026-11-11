import 'package:citizenone_app/modules/agency_banking/data/models/AccountTransHistory.dart';

abstract class TransactionHistoryState {}

class TransactionHistoryInitial extends TransactionHistoryState {}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistorySuccess extends TransactionHistoryState {
  final String message;
  final AccountTransHistory transHistory;
  TransactionHistorySuccess(this.message, this.transHistory);
}

class TransactionHistoryFailure extends TransactionHistoryState {
  final String error;
  TransactionHistoryFailure(this.error);
}
