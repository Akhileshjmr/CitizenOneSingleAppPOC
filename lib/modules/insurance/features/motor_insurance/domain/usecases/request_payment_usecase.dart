import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/core/shared/usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/payment_request_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class RequestPaymentParams {
  final String msisdn;
  final double amount;
  final String reference;
  final String narration;
  final String gateway;
  final String action;
  final String environment;
  final String currecny;

  const RequestPaymentParams(
      {required this.msisdn,
      required this.amount,
      required this.reference,
      required this.narration,
      required this.gateway,
      required this.action,
      required this.environment,
      required this.currecny});
}

class RequestMotorInsurancePaymentUseCase
    implements UseCase<PaymentRequestResponse, RequestPaymentParams> {
  final MotorInsuranceRepository repository;

  RequestMotorInsurancePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentRequestResponse>> call(
      RequestPaymentParams params) async {
    return await repository.requestPayment(params);
  }
}
