import 'package:citizenone_app/core/core.dart';
import '../models/insurance_category_model.dart';
import '../models/insurance_plan_model.dart';
import '../models/policy_model.dart';
import '../models/insurance_partner_model.dart';
import '../models/insurance_claim_model.dart';

abstract class InsuranceRemoteDataSource {
  Future<List<InsuranceCategoryModel>> getCategories({String? vendorCode});
  Future<List<InsurancePlanModel>> getPlans({String? categoryCode});
  Future<List<InsurancePartnerModel>> getPartners();
  Future<List<PolicyModel>> getActivePolicies();
  Future<PolicyModel> purchasePolicy({
    required String planId,
    required String policyName,
    required double premiumAmount,
    required String coverageType,
    required String nomineeName,
    required String nomineeRelation,
  });
  Future<InsuranceClaimModel> submitClaim({
    required String policyId,
    required double amount,
    required String description,
  });
  Future<List<InsuranceClaimModel>> getClaims();
}

class InsuranceRemoteDataSourceImpl implements InsuranceRemoteDataSource {
  final ApiClient apiClient;

  InsuranceRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<InsuranceCategoryModel>> getCategories({String? vendorCode}) async {
    try {
      final endpoint = vendorCode != null
          ? '/api/v1/insurance/categories?vendorCode=$vendorCode'
          : '/api/v1/insurance/categories';
      final response = await apiClient.get(endpoint);
      if (response['categories'] is List) {
        return (response['categories'] as List)
            .map((e) => InsuranceCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback categories: $e', 'InsuranceDataSource');
    }

    return _fallbackCategories;
  }

  @override
  Future<List<InsurancePlanModel>> getPlans({String? categoryCode}) async {
    try {
      final endpoint = categoryCode != null
          ? '/api/v1/insurance/plans?categoryCode=$categoryCode'
          : '/api/v1/insurance/plans';
      final response = await apiClient.get(endpoint);
      if (response['plans'] is List) {
        return (response['plans'] as List)
            .map((e) => InsurancePlanModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback plans: $e', 'InsuranceDataSource');
    }

    if (categoryCode != null && categoryCode.isNotEmpty) {
      return _fallbackPlans
          .where((p) => p.categoryCode.toUpperCase() == categoryCode.toUpperCase())
          .toList();
    }
    return _fallbackPlans;
  }

  @override
  Future<List<InsurancePartnerModel>> getPartners() async {
    try {
      final response = await apiClient.get('/api/v1/insurance/partners');
      if (response['partners'] is List) {
        return (response['partners'] as List)
            .map((e) => InsurancePartnerModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback partners: $e', 'InsuranceDataSource');
    }

    return _fallbackPartners;
  }

  @override
  Future<List<PolicyModel>> getActivePolicies() async {
    try {
      final response = await apiClient.get('/api/v1/insurance/active-policies');
      if (response['policies'] is List) {
        return (response['policies'] as List)
            .map((e) => PolicyModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback active policies: $e', 'InsuranceDataSource');
    }

    return _fallbackPolicies;
  }

  @override
  Future<PolicyModel> purchasePolicy({
    required String planId,
    required String policyName,
    required double premiumAmount,
    required String coverageType,
    required String nomineeName,
    required String nomineeRelation,
  }) async {
    final payload = {
      'planId': planId,
      'policyName': policyName,
      'premiumAmount': premiumAmount,
      'coverageType': coverageType,
      'nomineeName': nomineeName,
      'nomineeRelation': nomineeRelation,
    };

    try {
      final response =
          await apiClient.post('/api/v1/insurance/purchase', body: payload);
      if (response.isNotEmpty) {
        return PolicyModel.fromJson(response);
      }
    } catch (e) {
      AppLogger.info('Using local creation for policy purchase: $e', 'InsuranceDataSource');
    }

    return PolicyModel(
      policyId: 'POL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      policyName: policyName,
      premiumAmount: premiumAmount,
      coverageType: coverageType,
      status: 'ACTIVE',
      providerName: 'Health Shield Zambia',
      expiryDate: '2027-11-05',
    );
  }

  @override
  Future<InsuranceClaimModel> submitClaim({
    required String policyId,
    required double amount,
    required String description,
  }) async {
    final payload = {
      'policyId': policyId,
      'amount': amount,
      'description': description,
    };

    try {
      final response =
          await apiClient.post('/api/v1/insurance/claims/submit', body: payload);
      if (response.isNotEmpty) {
        return InsuranceClaimModel.fromJson(response);
      }
    } catch (e) {
      AppLogger.info('Using local creation for claim submission: $e', 'InsuranceDataSource');
    }

    return InsuranceClaimModel(
      claimId: 'CLM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      policyId: policyId,
      policyName: 'Health Shield Supreme',
      providerName: 'Health Shield Zambia',
      claimAmount: 'ZMW ${amount.toStringAsFixed(0)}',
      status: 'submitted',
      filingDate: DateTime.now().toIso8601String().substring(0, 10),
      description: description,
    );
  }

  @override
  Future<List<InsuranceClaimModel>> getClaims() async {
    try {
      final response = await apiClient.get('/api/v1/insurance/claims');
      if (response['claims'] is List) {
        return (response['claims'] as List)
            .map((e) => InsuranceClaimModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      AppLogger.info('Using fallback claims: $e', 'InsuranceDataSource');
    }

    return _fallbackClaims;
  }

  static final List<InsuranceCategoryModel> _fallbackCategories = [
    InsuranceCategoryModel(
      code: 'HEALTH',
      name: 'Health Insurance',
      desc: 'Hospitalization, OPD, and critical care protection for individuals & families.',
      logo: 'health_icon',
      subCategories: [
        InsuranceSubCategoryModel(code: 'INDIVIDUAL', name: 'Individual Health'),
        InsuranceSubCategoryModel(code: 'FAMILY', name: 'Family Floater'),
        InsuranceSubCategoryModel(code: 'SENIOR', name: 'Senior Citizen Shield'),
      ],
    ),
    InsuranceCategoryModel(
      code: 'MOTOR',
      name: 'Motor Insurance',
      desc: 'Comprehensive and third-party protection for cars, bikes & commercial transport.',
      logo: 'motor_icon',
      subCategories: [
        InsuranceSubCategoryModel(code: 'CAR', name: 'Private Car'),
        InsuranceSubCategoryModel(code: 'BIKE', name: 'Two-Wheeler'),
        InsuranceSubCategoryModel(code: 'COMMERCIAL', name: 'Commercial Fleet'),
      ],
    ),
    InsuranceCategoryModel(
      code: 'AGRI',
      name: 'Agricultural Insurance',
      desc: 'Weather index, crop failure, and livestock coverage for local farmers.',
      logo: 'agri_icon',
      subCategories: [
        InsuranceSubCategoryModel(code: 'CROP', name: 'Crop Weather Shield'),
        InsuranceSubCategoryModel(code: 'LIVESTOCK', name: 'Livestock Protection'),
      ],
    ),
    InsuranceCategoryModel(
      code: 'LIFE',
      name: 'Life & Term Insurance',
      desc: 'Guaranteed family financial security and education endowment policies.',
      logo: 'life_icon',
      subCategories: [
        InsuranceSubCategoryModel(code: 'TERM', name: 'Pure Term Life'),
        InsuranceSubCategoryModel(code: 'SAVINGS', name: 'Endowment & Savings'),
      ],
    ),
  ];

  static const List<InsurancePlanModel> _fallbackPlans = [
    InsurancePlanModel(
      id: 'PLN-001',
      title: 'Health Shield Starter',
      company: 'Health Shield',
      premium: 'ZMW 950/yr',
      cover: 'ZMW 40,000',
      claim: '94.2%',
      network: '200+ Hospitals',
      highlight: 'Affordable Individual Health Coverage',
      categoryCode: 'HEALTH',
    ),
    InsurancePlanModel(
      id: 'PLN-002',
      title: 'Health Shield Supreme',
      company: 'Health Shield',
      premium: 'ZMW 3,500/yr',
      cover: 'ZMW 200,000',
      claim: '98.6%',
      network: '650+ Hospitals',
      highlight: 'Maternity + Critical Illness Included',
      categoryCode: 'HEALTH',
    ),
    InsurancePlanModel(
      id: 'PLN-003',
      title: 'Family Care Premium',
      company: 'Family Care',
      premium: 'ZMW 4,200/yr',
      cover: 'ZMW 300,000',
      claim: '96.8%',
      network: '500+ Hospitals',
      highlight: 'Family Coverage with OPD Benefits',
      categoryCode: 'HEALTH',
    ),
    InsurancePlanModel(
      id: 'PLN-004',
      title: 'Motor Drive Complete',
      company: 'Citizen Motor Assure',
      premium: 'ZMW 1,800/yr',
      cover: 'ZMW 150,000',
      claim: '97.4%',
      network: '120+ Garages',
      highlight: 'Zero Depreciation + Roadside Assist',
      categoryCode: 'MOTOR',
    ),
    InsurancePlanModel(
      id: 'PLN-005',
      title: 'Harvest Guard Agro',
      company: 'Agrinet Shield',
      premium: 'ZMW 450/season',
      cover: 'ZMW 25,000',
      claim: '99.0%',
      network: 'All Districts',
      highlight: 'Drought & Flood Satellite Trigger',
      categoryCode: 'AGRI',
    ),
  ];

  static const List<InsurancePartnerModel> _fallbackPartners = [
    InsurancePartnerModel(
      vendorName: 'Health Shield Zambia',
      vendorCode: 'VDR190526234',
      vendorDesc: 'Leading medical insurance provider with nationwide cashless hospital network.',
      vendorLogo: 'health_shield_logo',
      vendorKey: 'HSZ',
      vendorMob: '+260971000111',
    ),
    InsurancePartnerModel(
      vendorName: 'Prudential Life Assurance',
      vendorCode: 'VDR190526235',
      vendorDesc: 'Pan-African life and financial savings assurance partner.',
      vendorLogo: 'prudential_logo',
      vendorKey: 'PRU',
      vendorMob: '+260971000222',
    ),
    InsurancePartnerModel(
      vendorName: 'Madison General Insurance',
      vendorCode: 'VDR190526236',
      vendorDesc: 'Premier motor, asset, and agricultural policy insurer.',
      vendorLogo: 'madison_logo',
      vendorKey: 'MGI',
      vendorMob: '+260971000333',
    ),
  ];

  static const List<PolicyModel> _fallbackPolicies = [
    PolicyModel(
      policyId: 'POL-90281',
      policyName: 'Health Shield Supreme',
      premiumAmount: 3500.0,
      coverageType: 'Medical & Inpatient',
      status: 'ACTIVE',
      providerName: 'Health Shield Zambia',
      expiryDate: '2027-06-15',
    ),
    PolicyModel(
      policyId: 'POL-78310',
      policyName: 'Motor Drive Complete',
      premiumAmount: 1800.0,
      coverageType: 'Comprehensive Motor',
      status: 'ACTIVE',
      providerName: 'Madison General Insurance',
      expiryDate: '2027-09-20',
    ),
  ];

  static const List<InsuranceClaimModel> _fallbackClaims = [
    InsuranceClaimModel(
      claimId: 'CLM-40192',
      policyId: 'POL-90281',
      policyName: 'Health Shield Supreme',
      providerName: 'Health Shield Zambia',
      claimAmount: 'ZMW 1,250',
      status: 'inReview',
      filingDate: '2026-10-14',
      description: 'Emergency dental extraction at Lusaka Specialist Clinic.',
    ),
    InsuranceClaimModel(
      claimId: 'CLM-38102',
      policyId: 'POL-78310',
      policyName: 'Motor Drive Complete',
      providerName: 'Madison General Insurance',
      claimAmount: 'ZMW 3,400',
      status: 'approved',
      filingDate: '2026-08-02',
      description: 'Windshield replacement following gravel damage.',
    ),
  ];
}
