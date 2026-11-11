import '../../../data/models/CommWalletAccountRequest.dart';

abstract class WalletSearchState {}

class WalletSearchInitial extends WalletSearchState {}

class WalletSearchLoading extends WalletSearchState {}

class WalletSearchSuccess extends WalletSearchState {
  final String message;
  final CommWalletAccountRequest commWalletAccountRequest;
  WalletSearchSuccess(this.message, this.commWalletAccountRequest);
}

class WalletSearchFailure extends WalletSearchState {
  final String error;
  WalletSearchFailure(this.error);
}
