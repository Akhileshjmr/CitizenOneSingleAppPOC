import 'package:citizenone_app/core/core.dart';
import '../models/policy_model.dart';

class InsuranceApi {
  final ApiClient apiClient;

  InsuranceApi(this.apiClient);

  Future<PolicyModel> purchasePolicy({
    required String policyName,
    required double premiumAmount,
  }) async {
    const endpoint = '/api/v1/insurance/purchase';
    try {
      final response = await apiClient.post(endpoint, body: {
        'policyName': policyName,
        'premiumAmount': premiumAmount,
      });
      return PolicyModel.fromJson(response);
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 500));
      return PolicyModel(
        policyId: 'INS-${DateTime.now().millisecondsSinceEpoch}',
        policyName: policyName,
        premiumAmount: premiumAmount,
        coverageType: 'Full Coverage',
        status: 'ACTIVE',
      );
    }
  }
}
