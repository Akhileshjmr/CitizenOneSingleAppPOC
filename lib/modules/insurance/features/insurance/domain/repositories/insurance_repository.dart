import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import '../entities/insurance_category_entity.dart';

abstract class InsuranceRepository {
  Future<Either<Failure, List<InsuranceCategoryEntity>>> getInsuranceCategories({
    required String vendorCode,
  });
}
