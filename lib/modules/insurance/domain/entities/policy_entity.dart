import 'package:equatable/equatable.dart';

class PolicyEntity extends Equatable {
  final String policyId;
  final String policyName;
  final double premiumAmount;
  final String coverageType;
  final String status;
  final String providerName;
  final String expiryDate;
  final String? documentUrl;

  const PolicyEntity({
    required this.policyId,
    required this.policyName,
    required this.premiumAmount,
    required this.coverageType,
    required this.status,
    this.providerName = 'Citizen Insurance',
    this.expiryDate = '2027-12-31',
    this.documentUrl,
  });

  @override
  List<Object?> get props => [
        policyId,
        policyName,
        premiumAmount,
        coverageType,
        status,
        providerName,
        expiryDate,
        documentUrl,
      ];
}

