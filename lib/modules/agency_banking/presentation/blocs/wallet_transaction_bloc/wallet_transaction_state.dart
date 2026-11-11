import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

abstract class WalletTransactionState {}

class WalletTransactionInitial extends WalletTransactionState {}

class WalletTransactionLoading extends WalletTransactionState {}

class WalletTransactionSuccess extends WalletTransactionState {
  final String message;
  final CommWalletTransaction commWalletTransaction;
  WalletTransactionSuccess(this.message,this.commWalletTransaction);
}

class WalletTransactionFailure extends WalletTransactionState {
  final String error;
  WalletTransactionFailure(this.error);
}
