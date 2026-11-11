import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../entities/kyc_history_entity.dart';
import '../entities/kyc_params_entity.dart';
import '../repositories/kyc_repository.dart';

class FetchRecentHistoryUseCase {
  final KycRepository repository;

  FetchRecentHistoryUseCase(this.repository);

  Future<Either<Failure, KycHistoryResultEntity>> call(
    FetchHistoryParams params,
  ) {
    return repository.fetchRecentHistory(params);
  }
}
