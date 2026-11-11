class InstantIssueResponseEntity {
  final String referenceNumber;
  final String policyNumber;
  final String status;
  final String durationType;
  final String duration;
  final String currency;
  final String durationMonth;
  final DateTime createdAt;
  final String coveragePeriod;
  final String clientName;
  final String vehicle;
  final String premiumAmount;

  const InstantIssueResponseEntity({
    required this.referenceNumber,
    required this.policyNumber,
    required this.coveragePeriod,
    required this.vehicle,
    required this.premiumAmount,
    required this.status,
    required this.durationType,
    required this.duration,
    required this.durationMonth,
    required this.createdAt,
    required this.currency,
    required this.clientName,
  });
}
