import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

abstract class TrustaccountWallettransactionState {}

class TrustaccountWallettransactionInitial extends TrustaccountWallettransactionState {}

class TrustaccountWallettransactionLoading extends TrustaccountWallettransactionState {}

class TrustaccountWallettransactionSuccess extends TrustaccountWallettransactionState {
  final String message;
  final CommWalletTransaction walletTransaction;
  TrustaccountWallettransactionSuccess(this.message, this.walletTransaction);
}

class TrustaccountWallettransactionFailure extends TrustaccountWallettransactionState {
  final String error;
  TrustaccountWallettransactionFailure(this.error);
}
