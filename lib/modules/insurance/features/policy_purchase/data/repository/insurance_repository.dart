import '../api/insurance_api.dart';
import '../../domain/entities/policy_entity.dart';

abstract class InsuranceRepository {
  Future<PolicyEntity> purchasePolicy({
    required String policyName,
    required double premiumAmount,
  });
}

class InsuranceRepositoryImpl implements InsuranceRepository {
  final InsuranceApi api;

  InsuranceRepositoryImpl(this.api);

  @override
  Future<PolicyEntity> purchasePolicy({
    required String policyName,
    required double premiumAmount,
  }) async {
    return await api.purchasePolicy(
        policyName: policyName, premiumAmount: premiumAmount);
  }
}
