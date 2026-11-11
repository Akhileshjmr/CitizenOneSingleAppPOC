import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_otp_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class VerifyMotorOtpParams {
  final String channel;
  final String destination;
  final String purpose;
  final String referenceType;
  final String otp;

  const VerifyMotorOtpParams({
    required this.channel,
    required this.destination,
    required this.purpose,
    required this.referenceType,
    required this.otp,
  });
}

class VerifyMotorOtpUsecase {
  final MotorInsuranceRepository repository;

  const VerifyMotorOtpUsecase(this.repository);

  Future<Either<Failure, MotorOtpVerifyResponseModel>> call(
    VerifyMotorOtpParams params,
  ) async {
    return repository.verifyMotorOtp(params: params);
  }
}
