import 'package:citizenone_app/modules/agency_banking/data/models/CommCustImageSignList.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/WalletKycCustomerReq.dart';

import '../../../data/models/CommWalletAccountRequest.dart';

abstract class CustImageUploadEvent {}

class CustImageUploadSubmitted extends CustImageUploadEvent {
  final CommCustImageSignList imageSignList;
  CustImageUploadSubmitted(this.imageSignList);
}


