import 'package:citizenone_app/modules/agency_banking/data/models/WalletKycCustomerReq.dart';

import '../../../data/models/CommWalletAccountRequest.dart';

abstract class WalletRegistrationEvent {}

class WalletRegistrationSubmitted extends WalletRegistrationEvent {
  final WalletKycCustomerReq WalletRegistrationRequest;
  WalletRegistrationSubmitted(this.WalletRegistrationRequest);
}


