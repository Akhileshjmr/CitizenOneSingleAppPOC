import '../../../data/models/AbQueryLoanDetails.dart';
import '../../../data/models/common_models/AbFcErrorType.dart';
import '../../../data/models/CommAccountRequest.dart';

abstract class LoanAccountDetailsState {}

class LoanAccountDetailsInitial extends LoanAccountDetailsState {}

class LoanAccountDetailsLoading extends LoanAccountDetailsState {}

class LoanAccountDetailsSuccess extends LoanAccountDetailsState {
  final String message;
  final AbQueryLoanDetails loanDetails;
  LoanAccountDetailsSuccess(this.message,this.loanDetails);
}

class LoanAccountDetailsFailure extends LoanAccountDetailsState {
  final String error;
  LoanAccountDetailsFailure(this.error);
}