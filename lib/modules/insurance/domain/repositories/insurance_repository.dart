import '../entities/insurance_category_entity.dart';
import '../entities/insurance_plan_entity.dart';
import '../entities/insurance_partner_entity.dart';
import '../entities/insurance_claim_entity.dart';
import '../entities/policy_entity.dart';

abstract class InsuranceRepository {
  Future<List<InsuranceCategoryEntity>> getCategories({String? vendorCode});
  Future<List<InsurancePlanEntity>> getPlans({String? categoryCode});
  Future<List<InsurancePartnerEntity>> getPartners();
  Future<List<PolicyEntity>> getActivePolicies();
  Future<PolicyEntity> purchasePolicy({
    required String planId,
    required String policyName,
    required double premiumAmount,
    required String coverageType,
    required String nomineeName,
    required String nomineeRelation,
  });
  Future<InsuranceClaimEntity> submitClaim({
    required String policyId,
    required double amount,
    required String description,
  });
  Future<List<InsuranceClaimEntity>> getClaims();
}

