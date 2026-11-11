import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';

abstract class WalletBalanceEvent {}

class WalletBalanceSubmitted extends WalletBalanceEvent {
  final CommWalletAccountRequest walletBalance;
  WalletBalanceSubmitted(this.walletBalance);
}
