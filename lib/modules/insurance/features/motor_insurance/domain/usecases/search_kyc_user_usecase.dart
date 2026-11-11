import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';
import '../entities/kyc_user_entity.dart';

class SearchKycUserParams {
  final String mobileNumber;
  final String nationalId;

  const SearchKycUserParams({
    required this.mobileNumber,
    required this.nationalId,
  });
}

class SearchKycUserUseCase {
  final MotorInsuranceRepository repository;

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

class SearchInsuranceUserParams {
  final String phoneNumber;
  final String nationalId;

  const SearchInsuranceUserParams({
    required this.phoneNumber,
    required this.nationalId,
  });
}

class SearchInsuranceUserUseCase {
  final MotorInsuranceRepository repository;

  SearchInsuranceUserUseCase(this.repository);

  Future<Either<Failure, KycUserEntity>> call(
    SearchInsuranceUserParams params,
  ) {
    return repository.searchInsuranceUser(
      phoneNumber: params.phoneNumber,
      nationalId: params.nationalId,
    );
  }
}
