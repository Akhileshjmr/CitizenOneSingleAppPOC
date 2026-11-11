enum ClaimStatus { submitted, inReview, approved, rejected, paid }

class InsuranceClaimEntity {
  final String claimId;
  final String policyId;
  final String policyName;
  final String providerName;
  final String claimAmount;
  final ClaimStatus status;
  final String filingDate;
  final String description;

  const InsuranceClaimEntity({
    required this.claimId,
    required this.policyId,
    required this.policyName,
    required this.providerName,
    required this.claimAmount,
    required this.status,
    required this.filingDate,
    required this.description,
  });
}

