import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_otp_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class GenerateMotorOtpParams {
  final String destination;
  final String purpose;
  final String referenceType;

  const GenerateMotorOtpParams({
    required this.destination,
    this.purpose = 'Insurance',
    this.referenceType = 'MOTOR_INSURANCE',
  });
}

class GenerateMotorOtpUsecase {
  final MotorInsuranceRepository repository;

  const GenerateMotorOtpUsecase(this.repository);

  Future<Either<Failure, MotorOtpResponseModel>> call(
    GenerateMotorOtpParams params,
  ) async {
    return repository.generateMotorOtp(params: params);
  }
}
