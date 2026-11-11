import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductPurResponse.dart';

abstract class LoanApplyState {}

class LoanApplyInitial extends LoanApplyState {}

class LoanApplyLoading extends LoanApplyState {}

class LoanApplySuccess extends LoanApplyState {
  final String? message;
  final GdbMerchantDisProductPurResponse gdbMerchantDisProductPurResponse;
  LoanApplySuccess(this.message,this.gdbMerchantDisProductPurResponse);
}

class LoanApplyFailure extends LoanApplyState {
  final String? error;
  LoanApplyFailure(this.error);
}
