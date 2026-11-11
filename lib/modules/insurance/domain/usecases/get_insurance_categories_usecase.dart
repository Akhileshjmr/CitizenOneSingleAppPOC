import '../entities/insurance_category_entity.dart';
import '../repositories/insurance_repository.dart';

class GetInsuranceCategoriesUseCase {
  final InsuranceRepository repository;

  GetInsuranceCategoriesUseCase(this.repository);

  Future<List<InsuranceCategoryEntity>> call({String? vendorCode}) {
    return repository.getCategories(vendorCode: vendorCode);
  }
}

