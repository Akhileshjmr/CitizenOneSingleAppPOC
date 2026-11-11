
import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

import '../../../data/models/CommWalletAccountRequest.dart';

abstract class WalletReceivePaymentState {

}

class WalletReceivePaymentInitial extends WalletReceivePaymentState {}

class WalletReceivePaymentLoading extends WalletReceivePaymentState {}

class WalletReceivePaymentSuccess extends WalletReceivePaymentState {
  final String message;
  final CommWalletTransaction commWalletTransaction;
  WalletReceivePaymentSuccess(this.message,this.commWalletTransaction);
}

class WalletReceivePaymentFailure extends WalletReceivePaymentState {
  final String error;
  WalletReceivePaymentFailure(this.error);
}


