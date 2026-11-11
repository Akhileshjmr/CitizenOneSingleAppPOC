import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/risk_category_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class FetchRiskCategoriesUsecase {
  final MotorInsuranceRepository repository;

  FetchRiskCategoriesUsecase(this.repository);

  Future<Either<Failure, RiskCategoryResponseModel>> call() async {
    return await repository.getRiskCategories();
  }
}
