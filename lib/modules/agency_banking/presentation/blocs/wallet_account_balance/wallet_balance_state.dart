import '../../../data/models/CommWalletAccountRequest.dart';

abstract class WalletBalanceState {}

class WalletBalanceInitial extends WalletBalanceState {}

class WalletBalanceLoading extends WalletBalanceState {}

class WalletBalanceSuccess extends WalletBalanceState {
  final String message;
  final CommWalletAccountRequest commWalletAccountRequest;
  WalletBalanceSuccess(this.message,this.commWalletAccountRequest);
}

class WalletBalanceFailure extends WalletBalanceState {
  final String error;
  WalletBalanceFailure(this.error);
}
