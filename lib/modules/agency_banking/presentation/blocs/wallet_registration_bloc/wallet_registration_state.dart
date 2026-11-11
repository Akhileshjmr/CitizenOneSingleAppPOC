
import 'package:citizenone_app/modules/agency_banking/data/models/WalletKycCustomerReq.dart';

abstract class WalletRegistrationState {

}

class WalletRegistrationInitial extends WalletRegistrationState {}

class WalletRegistrationLoading extends WalletRegistrationState {}

class WalletRegistrationSuccess extends WalletRegistrationState {
  final String message;
  final WalletKycCustomerReq walletRequest;
  WalletRegistrationSuccess(this.message,this.walletRequest);
}

class WalletRegistrationFailure extends WalletRegistrationState {
  final String error;
  WalletRegistrationFailure(this.error);
}


