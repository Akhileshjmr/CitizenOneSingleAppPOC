import '../entities/insurance_plan_entity.dart';
import '../repositories/insurance_repository.dart';

class GetInsurancePlansUseCase {
  final InsuranceRepository repository;

  GetInsurancePlansUseCase(this.repository);

  Future<List<InsurancePlanEntity>> call({String? categoryCode}) {
    return repository.getPlans(categoryCode: categoryCode);
  }
}

