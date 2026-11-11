import '../entities/policy_entity.dart';
import '../repositories/insurance_repository.dart';

class GetActivePoliciesUseCase {
  final InsuranceRepository repository;

  GetActivePoliciesUseCase(this.repository);

  Future<List<PolicyEntity>> call() {
    return repository.getActivePolicies();
  }
}

