import '../entities/insurance_partner_entity.dart';
import '../repositories/insurance_repository.dart';

class GetInsurancePartnersUseCase {
  final InsuranceRepository repository;

  GetInsurancePartnersUseCase(this.repository);

  Future<List<InsurancePartnerEntity>> call() {
    return repository.getPartners();
  }
}

