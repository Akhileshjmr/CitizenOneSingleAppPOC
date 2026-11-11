import '../entities/policy_entity.dart';
import '../repositories/insurance_repository.dart';

class PurchasePolicyUseCase {
  final InsuranceRepository repository;

  PurchasePolicyUseCase(this.repository);

  Future<PolicyEntity> call({
    required String planId,
    required String policyName,
    required double premiumAmount,
    required String coverageType,
    required String nomineeName,
    required String nomineeRelation,
  }) {
    return repository.purchasePolicy(
      planId: planId,
      policyName: policyName,
      premiumAmount: premiumAmount,
      coverageType: coverageType,
      nomineeName: nomineeName,
      nomineeRelation: nomineeRelation,
    );
  }
}

