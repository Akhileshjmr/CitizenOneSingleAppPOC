import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/kyc_repository.dart';

class FetchLocationsUseCase {
  final KycRepository repository;

  FetchLocationsUseCase(this.repository);

  Future<Either<Failure, KycLocationsEntity>> call() {
    return repository.fetchLocations();
  }
}
