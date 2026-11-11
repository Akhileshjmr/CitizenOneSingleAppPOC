import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/casa_account_models/CasaAccountCreateRequest.dart';


import '../../../../data/models/lms_models/repayment_models/L2lLoanRepayRequest.dart';

abstract class CustSpecificRepaymentEvent {}

class CustSpecificRepaymentSubmitted extends CustSpecificRepaymentEvent {
  final L2lLoanRepayRequest req;
  CustSpecificRepaymentSubmitted(this.req);
}