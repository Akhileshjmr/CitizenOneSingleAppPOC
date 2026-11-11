import '../../domain/entities/insurance_claim_entity.dart';

class InsuranceClaimModel {
  final String claimId;
  final String policyId;
  final String policyName;
  final String providerName;
  final String claimAmount;
  final String status;
  final String filingDate;
  final String description;

  const InsuranceClaimModel({
    required this.claimId,
    required this.policyId,
    required this.policyName,
    required this.providerName,
    required this.claimAmount,
    required this.status,
    required this.filingDate,
    required this.description,
  });

  factory InsuranceClaimModel.fromJson(Map<String, dynamic> json) {
    return InsuranceClaimModel(
      claimId: json['claimId']?.toString() ?? '',
      policyId: json['policyId']?.toString() ?? '',
      policyName: json['policyName'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      claimAmount: json['claimAmount'] as String? ?? 'ZMW 0',
      status: json['status'] as String? ?? 'submitted',
      filingDate: json['filingDate'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  InsuranceClaimEntity toEntity() {
    ClaimStatus parsedStatus;
    switch (status.toLowerCase()) {
      case 'inreview':
      case 'in_review':
        parsedStatus = ClaimStatus.inReview;
        break;
      case 'approved':
        parsedStatus = ClaimStatus.approved;
        break;
      case 'rejected':
        parsedStatus = ClaimStatus.rejected;
        break;
      case 'paid':
        parsedStatus = ClaimStatus.paid;
        break;
      default:
        parsedStatus = ClaimStatus.submitted;
    }

    return InsuranceClaimEntity(
      claimId: claimId,
      policyId: policyId,
      policyName: policyName,
      providerName: providerName,
      claimAmount: claimAmount,
      status: parsedStatus,
      filingDate: filingDate,
      description: description,
    );
  }
}

