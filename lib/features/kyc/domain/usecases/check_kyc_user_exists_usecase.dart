import 'package:citizenone_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/kyc_repository.dart';

class CheckKycUserExistsParams {
  final String mobileNumber;
  final String nationalId;

  const CheckKycUserExistsParams({
    required this.mobileNumber,
    required this.nationalId,
  });
}

class CheckKycUserExistsUseCase {
  final KycRepository repository;

  CheckKycUserExistsUseCase(this.repository);

  Future<Either<Failure, bool>> call(CheckKycUserExistsParams params) {
    return repository.checkKycUserExists(
      mobileNumber: params.mobileNumber,
      nationalId: params.nationalId,
    );
  }
}
