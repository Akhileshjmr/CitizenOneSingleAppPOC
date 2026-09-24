import '../../domain/entities/policy_entity.dart';

class PolicyModel extends PolicyEntity {
  const PolicyModel({
    required super.policyId,
    required super.policyName,
    required super.premiumAmount,
    required super.coverageType,
    required super.status,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      policyId: json['policyId'] as String? ??
          'INS-${DateTime.now().millisecondsSinceEpoch}',
      policyName: json['policyName'] as String? ?? 'Health Shield Plus',
      premiumAmount: (json['premiumAmount'] as num?)?.toDouble() ?? 120.0,
      coverageType: json['coverageType'] as String? ?? 'Comprehensive',
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }
}
