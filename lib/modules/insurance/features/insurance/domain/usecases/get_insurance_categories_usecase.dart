import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import '../entities/insurance_category_entity.dart';
import '../repositories/insurance_repository.dart';

class GetInsuranceCategoriesParams {
  final String vendorCode;

  const GetInsuranceCategoriesParams({required this.vendorCode});
}

class GetInsuranceCategoriesUseCase {
  final InsuranceRepository repository;

  GetInsuranceCategoriesUseCase(this.repository);

  Future<Either<Failure, List<InsuranceCategoryEntity>>> call(
    GetInsuranceCategoriesParams params,
  ) {
    return repository.getInsuranceCategories(vendorCode: params.vendorCode);
  }
}
