import 'package:equatable/equatable.dart';

class PolicyEntity extends Equatable {
  final String policyId;
  final String policyName;
  final double premiumAmount;
  final String coverageType;
  final String status;

  const PolicyEntity({
    required this.policyId,
    required this.policyName,
    required this.premiumAmount,
    required this.coverageType,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [policyId, policyName, premiumAmount, coverageType, status];
}
