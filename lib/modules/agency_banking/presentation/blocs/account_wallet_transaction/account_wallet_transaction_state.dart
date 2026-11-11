import '../../../data/models/CommWalletTransaction.dart';

abstract class AccountWalletTransactionState {}

class AccountWalletTransactionInitial extends AccountWalletTransactionState {}

class AccountWalletTransactionLoading extends AccountWalletTransactionState {}

class AccountWalletTransactionSuccess extends AccountWalletTransactionState {
  final String message;
  final CommWalletTransaction commwalletTransaction;
  AccountWalletTransactionSuccess(this.message, this.commwalletTransaction);
}

class AccountWalletTransactionFailure extends AccountWalletTransactionState {
  final String error;
  AccountWalletTransactionFailure(this.error);
}
