import 'package:citizenone_app/core/error/failures.dart';
import 'package:citizenone_app/features/kyc/domain/entities/kyc_params_entity.dart';
import 'package:citizenone_app/features/kyc/domain/entities/otp_entity.dart';
import 'package:citizenone_app/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyOtpUseCase {
  final KycRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, OtpVerifyResultEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params);
  }
}
