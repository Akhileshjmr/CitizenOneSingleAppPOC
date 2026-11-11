import 'package:dartz/dartz.dart';
import '../entities/kyc_params_entity.dart';
import '../entities/otp_entity.dart';
import '../repositories/kyc_repository.dart';
import 'package:citizenone_app/core/error/failures.dart';


class SendOtpUseCase {
  final KycRepository repository;

  SendOtpUseCase(this.repository);

  Future<Either<Failure, OtpResponseEntity>> call(SendOtpParams params) {
    return repository.sendOtp(params);
  }
}

