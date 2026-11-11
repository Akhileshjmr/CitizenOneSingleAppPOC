import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

import '../../../data/models/CommWalletAccountRequest.dart';

abstract class WalletReceivePaymentEvent {}

class WalletReceivePaymentSubmitted extends WalletReceivePaymentEvent {
  final CommWalletTransaction commWalletTransaction;
  WalletReceivePaymentSubmitted(this.commWalletTransaction);
}


