import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../repositories/kyc_repository.dart';

class GetAgentMobileUseCase {
  final KycRepository repository;

  GetAgentMobileUseCase(this.repository);

  Future<Either<Failure, String>> call() {
    return repository.getAgentMobileNumber();
  }
}
