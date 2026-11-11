import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/insurance/insurance.dart';
import 'package:citizenone_app/modules/insurance/data/datasources/insurance_remote_datasource.dart';
import 'package:citizenone_app/modules/insurance/data/repositories/insurance_repository_impl.dart';
import 'package:citizenone_app/modules/insurance/domain/usecases/get_insurance_categories_usecase.dart';
import 'package:citizenone_app/modules/insurance/domain/usecases/get_insurance_plans_usecase.dart';
import 'package:citizenone_app/modules/insurance/domain/usecases/get_insurance_partners_usecase.dart';
import 'package:citizenone_app/modules/insurance/domain/usecases/get_active_policies_usecase.dart';
import 'package:citizenone_app/modules/insurance/domain/usecases/purchase_policy_usecase.dart';
import 'package:citizenone_app/modules/insurance/domain/usecases/submit_claim_usecase.dart';

void main() {
  group('Insurance Clean Architecture & Cubit Tests', () {
    late ApiClient apiClient;
    late InsuranceRemoteDataSource dataSource;
    late InsuranceRepositoryImpl repository;

    setUp(() {
      apiClient = ApiClient();
      dataSource = InsuranceRemoteDataSourceImpl(apiClient);
      repository = InsuranceRepositoryImpl(dataSource);
    });

    test('InsuranceCategoriesCubit loads fallback categories successfully',
        () async {
      final useCase = GetInsuranceCategoriesUseCase(repository);
      final cubit = InsuranceCategoriesCubit(useCase);

      expect(cubit.state, isA<InsuranceCategoriesInitial>());

      await cubit.loadCategories();

      expect(cubit.state, isA<InsuranceCategoriesLoaded>());
      final loaded = cubit.state as InsuranceCategoriesLoaded;
      expect(loaded.categories.isNotEmpty, isTrue);
      expect(loaded.categories.first.name, equals('Health Insurance'));
    });

    test('InsurancePlansCubit loads plans and toggles side-by-side comparison',
        () async {
      final useCase = GetInsurancePlansUseCase(repository);
      final cubit = InsurancePlansCubit(useCase);

      await cubit.loadPlans(categoryCode: 'HEALTH');

      expect(cubit.state, isA<InsurancePlansLoaded>());
      final loaded = cubit.state as InsurancePlansLoaded;
      expect(loaded.plans.isNotEmpty, isTrue);

      final plan1 = loaded.plans[0];
      cubit.toggleComparison(plan1);
      final afterFirst = cubit.state as InsurancePlansLoaded;
      expect(afterFirst.comparedPlans.length, equals(1));

      cubit.toggleComparison(plan1);
      final afterRemove = cubit.state as InsurancePlansLoaded;
      expect(afterRemove.comparedPlans.isEmpty, isTrue);
    });

    test('ActivePoliciesCubit loads policies and appends newly purchased policy',
        () async {
      final useCase = GetActivePoliciesUseCase(repository);
      final cubit = ActivePoliciesCubit(useCase);

      await cubit.loadPolicies();

      expect(cubit.state, isA<ActivePoliciesLoaded>());
      final initialCount =
          (cubit.state as ActivePoliciesLoaded).policies.length;

      const newPolicy = PolicyEntity(
        policyId: 'POL-NEW-999',
        policyName: 'Custom Agro Shield',
        premiumAmount: 850.0,
        coverageType: 'ZMW 50,000',
        status: 'ACTIVE',
      );

      cubit.addPurchasedPolicy(newPolicy);

      final updated = cubit.state as ActivePoliciesLoaded;
      expect(updated.policies.length, equals(initialCount + 1));
      expect(updated.policies.first.policyId, equals('POL-NEW-999'));
    });

    test('PolicyPurchaseCubit completes purchase and emits PolicyPurchaseSuccess',
        () async {
      final useCase = PurchasePolicyUseCase(repository);
      final cubit = PolicyPurchaseCubit(useCase);

      await cubit.purchasePolicy(
        planId: 'PLN-002',
        policyName: 'Health Shield Supreme',
        premiumAmount: 3500.0,
        coverageType: 'ZMW 200,000',
        nomineeName: 'Test Nominee',
        nomineeRelation: 'Spouse',
      );

      expect(cubit.state, isA<PolicyPurchaseSuccess>());
      final success = cubit.state as PolicyPurchaseSuccess;
      expect(success.policy.policyName, equals('Health Shield Supreme'));
      expect(success.policy.status, equals('ACTIVE'));
    });

    test('InsuranceClaimCubit files claim and updates state', () async {
      final useCase = SubmitClaimUseCase(repository);
      final cubit = InsuranceClaimCubit(
        submitClaimUseCase: useCase,
        repository: repository,
      );

      await cubit.submitClaim(
        policyId: 'POL-90281',
        amount: 1500.0,
        description: 'Outpatient specialist visit',
      );

      expect(cubit.state, isA<InsuranceClaimSubmissionSuccess>());
      final success = cubit.state as InsuranceClaimSubmissionSuccess;
      expect(success.claim.policyId, equals('POL-90281'));
      expect(success.claim.claimAmount, contains('1500'));
    });

    test('InsurancePartnerCubit filters partners by name and key query', () async {
      final useCase = GetInsurancePartnersUseCase(repository);
      final cubit = InsurancePartnerCubit(useCase);

      await cubit.loadPartners();
      final loaded = cubit.state as InsurancePartnerLoaded;
      expect(loaded.partners.length, equals(3));

      cubit.filterPartners('prudential');
      final filtered = cubit.state as InsurancePartnerLoaded;
      expect(filtered.filteredPartners.length, equals(1));
      expect(filtered.filteredPartners.first.vendorKey, equals('PRU'));
    });

    test('InsuranceModule symmetrical session lifecycle teardown', () async {
      final module = InsuranceModule();
      module.initialize(apiClient: apiClient);

      expect(module.id, equals('insurance'));
      expect(module.initialRoute, equals('/insurance'));
      expect(module.routes.length, greaterThanOrEqualTo(6));

      // Trigger session logout
      module.onSessionStateChanged(false, null);
      // dispose executes without throwing
      await module.dispose();
    });
  });
}

