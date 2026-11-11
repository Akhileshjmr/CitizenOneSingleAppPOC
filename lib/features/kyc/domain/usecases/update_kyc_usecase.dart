import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../entities/kyc_params_entity.dart';
import '../repositories/kyc_repository.dart';

class UpdateKycUseCase {
  final KycRepository repository;

  UpdateKycUseCase(this.repository);

  Future<Either<Failure, bool>> call(UpdateKycParams params) {
    return repository.updateKyc(params);
  }
}
