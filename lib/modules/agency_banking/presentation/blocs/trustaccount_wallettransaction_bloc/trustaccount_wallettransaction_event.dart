import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

abstract class TrustaccountWallettransactionEvent {}

class TrustaccountWallettransactionSubmitted extends TrustaccountWallettransactionEvent {
  final CommWalletTransaction walletTransaction;
  TrustaccountWallettransactionSubmitted(this.walletTransaction);
}
