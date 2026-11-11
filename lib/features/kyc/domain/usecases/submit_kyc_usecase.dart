import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../entities/kyc_params_entity.dart';
import '../repositories/kyc_repository.dart';

class SubmitKycUseCase {
  final KycRepository repository;

  SubmitKycUseCase(this.repository);

  /// Returns the generated KYC code string on success.
  Future<Either<Failure, String>> call(SubmitKycParams params) {
    return repository.submitKyc(params);
  }
}
