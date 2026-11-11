import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductPurRequest.dart';

abstract class LoanApplyEvent {}

class LoanApplySubmitted extends LoanApplyEvent {
  final GdbMerchantDisProductPurRequest gdbMerchantDisProductPurRequest;
  LoanApplySubmitted(this.gdbMerchantDisProductPurRequest);
}
