import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

abstract class WalletTransactionEvent {}

class WalletTransactionSubmitted extends WalletTransactionEvent {
  final CommWalletTransaction walletTransaction;
  WalletTransactionSubmitted(this.walletTransaction);
}
