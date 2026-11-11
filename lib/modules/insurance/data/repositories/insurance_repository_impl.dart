import '../../domain/entities/insurance_category_entity.dart';
import '../../domain/entities/insurance_plan_entity.dart';
import '../../domain/entities/insurance_partner_entity.dart';
import '../../domain/entities/insurance_claim_entity.dart';
import '../../domain/entities/policy_entity.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../datasources/insurance_remote_datasource.dart';

class InsuranceRepositoryImpl implements InsuranceRepository {
  final InsuranceRemoteDataSource remoteDataSource;

  InsuranceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<InsuranceCategoryEntity>> getCategories({String? vendorCode}) async {
    final models = await remoteDataSource.getCategories(vendorCode: vendorCode);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<InsurancePlanEntity>> getPlans({String? categoryCode}) async {
    final models = await remoteDataSource.getPlans(categoryCode: categoryCode);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<InsurancePartnerEntity>> getPartners() async {
    final models = await remoteDataSource.getPartners();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PolicyEntity>> getActivePolicies() async {
    final models = await remoteDataSource.getActivePolicies();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PolicyEntity> purchasePolicy({
    required String planId,
    required String policyName,
    required double premiumAmount,
    required String coverageType,
    required String nomineeName,
    required String nomineeRelation,
  }) async {
    final model = await remoteDataSource.purchasePolicy(
      planId: planId,
      policyName: policyName,
      premiumAmount: premiumAmount,
      coverageType: coverageType,
      nomineeName: nomineeName,
      nomineeRelation: nomineeRelation,
    );
    return model.toEntity();
  }

  @override
  Future<InsuranceClaimEntity> submitClaim({
    required String policyId,
    required double amount,
    required String description,
  }) async {
    final model = await remoteDataSource.submitClaim(
      policyId: policyId,
      amount: amount,
      description: description,
    );
    return model.toEntity();
  }

  @override
  Future<List<InsuranceClaimEntity>> getClaims() async {
    final models = await remoteDataSource.getClaims();
    return models.map((m) => m.toEntity()).toList();
  }
}

