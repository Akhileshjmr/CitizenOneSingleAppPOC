import '../../../../data/models/lms_models/repayment_models/AccSpecificRepaymentResponse.dart';

abstract class AccountSpecificRepaymentState {}

class AccountSpecificRepaymentInitial extends AccountSpecificRepaymentState {}

class AccountSpecificRepaymentLoading extends AccountSpecificRepaymentState {}

class AccountSpecificRepaymentSuccess extends AccountSpecificRepaymentState {
  final String? message;
  final AccSpecificRepaymentResponse accSpecificRepaymentResponse;
  AccountSpecificRepaymentSuccess(
      this.message, this.accSpecificRepaymentResponse);
}

class AccountSpecificRepaymentFailure extends AccountSpecificRepaymentState {
  final String? error;
  AccountSpecificRepaymentFailure(this.error);
}
