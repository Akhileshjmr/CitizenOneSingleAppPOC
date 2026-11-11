import '../../domain/entities/policy_entity.dart';

class PolicyModel {
  final String policyId;
  final String policyName;
  final double premiumAmount;
  final String coverageType;
  final String status;
  final String providerName;
  final String expiryDate;
  final String? documentUrl;

  const PolicyModel({
    required this.policyId,
    required this.policyName,
    required this.premiumAmount,
    required this.coverageType,
    required this.status,
    this.providerName = 'Citizen Insurance',
    this.expiryDate = '2027-12-31',
    this.documentUrl,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      policyId: json['policyId']?.toString() ?? '',
      policyName: json['policyName'] as String? ?? '',
      premiumAmount: (json['premiumAmount'] as num?)?.toDouble() ?? 0.0,
      coverageType: json['coverageType'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      providerName: json['providerName'] as String? ?? 'Citizen Insurance',
      expiryDate: json['expiryDate'] as String? ?? '2027-12-31',
      documentUrl: json['documentUrl'] as String?,
    );
  }

  PolicyEntity toEntity() {
    return PolicyEntity(
      policyId: policyId,
      policyName: policyName,
      premiumAmount: premiumAmount,
      coverageType: coverageType,
      status: status,
      providerName: providerName,
      expiryDate: expiryDate,
      documentUrl: documentUrl,
    );
  }
}

