import 'package:citizenone_app/modules/agency_banking/data/models/AbQueryLoanDetails.dart';

import '../../../data/models/CommAccountRequest.dart';

abstract class LoanAccountDetailsEvent {}

class LoanAccountDetailsSubmitted extends LoanAccountDetailsEvent {
  final AbQueryLoanDetails loanDetails;
  LoanAccountDetailsSubmitted(this.loanDetails);
}