import 'package:dartz/dartz.dart';
import 'package:citizenone_app/core/error/failures.dart';
import '../entities/kyc_user_entity.dart';
import '../repositories/kyc_repository.dart';

class SearchKycUserParams {
  final String mobileNumber;
  final String nationalId;

  const SearchKycUserParams({
    required this.mobileNumber,
    required this.nationalId,
  });
}

class SearchKycUserUseCase {
  final KycRepository repository;

  SearchKycUserUseCase(this.repository);

  Future<Either<Failure, KycUserEntity>> call(
    SearchKycUserParams params,
  ) {
    return repository.searchKycUser(
      mobileNumber: params.mobileNumber,
      nationalId: params.nationalId,
    );
  }
}
