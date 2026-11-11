import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/casa_account_models/CasaAccountCreateResponse.dart';

import '../../../../data/models/lms_models/repayment_models/L2lLoanRepayResponse.dart';

abstract class CustSpecificRepaymentState {}

class CustSpecificRepaymentInitial extends CustSpecificRepaymentState {}

class CustSpecificRepaymentLoading extends CustSpecificRepaymentState {}

class CustSpecificRepaymentSuccess extends CustSpecificRepaymentState {
  final String? message;
  final L2lLoanRepayResponse casaAccountCreateResponse;
  CustSpecificRepaymentSuccess(this.message,this.casaAccountCreateResponse);
}

class CustSpecificRepaymentFailure extends CustSpecificRepaymentState {
  final String? error;
  CustSpecificRepaymentFailure(this.error);
}