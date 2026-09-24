import '../../data/repository/insurance_repository.dart';
import '../entities/policy_entity.dart';

class PurchasePolicyUseCase {
  final InsuranceRepository repository;

  PurchasePolicyUseCase(this.repository);

  Future<PolicyEntity> call({
    required String policyName,
    required double premiumAmount,
  }) {
    if (premiumAmount <= 0) {
      throw ArgumentError('Premium amount must be positive');
    }
    return repository.purchasePolicy(
        policyName: policyName, premiumAmount: premiumAmount);
  }
}
