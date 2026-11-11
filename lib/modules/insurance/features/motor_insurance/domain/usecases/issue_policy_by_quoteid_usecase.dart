import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/issue_policy_by_quote_id.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class IssuePolicyByQuoteidParams {
  final String quotationId;
  final String agentCode;
  final String referenceNumber;
  final PaymentParams paymentUsecase;

  IssuePolicyByQuoteidParams({
    required this.quotationId,
    required this.agentCode,
    required this.referenceNumber,
    required this.paymentUsecase,
  });
}

class PaymentParams {
  final String method;
  final String mobileMoneyAccountNumber;
  final String gateway;
  final String reference;
  final String transactionId;
  final String gwId;
  final String paymentRefNo;
  final String mnoRequestId;
  PaymentParams({
    required this.method,
    required this.mobileMoneyAccountNumber,
    required this.gateway,
    required this.reference,
    required this.transactionId,
    required this.gwId,
    required this.mnoRequestId,
    required this.paymentRefNo,
  });
}

class IssuePolicyByQuoteIDUseCase {
  final MotorInsuranceRepository repository;

  IssuePolicyByQuoteIDUseCase(this.repository);

  Future<Either<Failure, IssuePolicyByQuoteIdResponse>> call(
      IssuePolicyByQuoteidParams issuePolicyParams) async {
    return await repository.issuePolicyByQuoteId(issuePolicyParams);
  }
}
