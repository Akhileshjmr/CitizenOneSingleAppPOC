import '../../../../data/models/lms_models/repayment_models/AccSpecificRepaymentRequest.dart';

abstract class AccountSpecificRepaymentEvent {}

class AccountSpecificRepaymentSubmitted extends AccountSpecificRepaymentEvent {
  final AccSpecificRepaymentRequest req;
  AccountSpecificRepaymentSubmitted(this.req);
}
