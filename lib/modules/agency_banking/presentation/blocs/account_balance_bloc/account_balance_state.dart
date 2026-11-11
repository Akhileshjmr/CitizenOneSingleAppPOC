import '../../../data/models/CommAccountRequest.dart';

abstract class AccountBalanceState {}

class AccountBalanceInitial extends AccountBalanceState {}

class AccountBalanceLoading extends AccountBalanceState {}

class AccountBalanceSuccess extends AccountBalanceState {
  final String message;
  final CommAccountRequest commAccountRequest;
  AccountBalanceSuccess(this.message,this.commAccountRequest);
}

class AccountBalanceFailure extends AccountBalanceState {
  final String error;
  AccountBalanceFailure(this.error);
}
