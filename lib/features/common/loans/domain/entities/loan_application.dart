class LoanApplication {
  final String id;
  final String loanType;
  final String bankName;
  final double amount;
  final String referenceNumber;
  final String status; // 'Credit Scoring', 'Approved', 'Processing', 'Rejected'
  final DateTime lastUpdate;
  final double progressPercentage;

  const LoanApplication({
    required this.id,
    required this.loanType,
    required this.bankName,
    required this.amount,
    required this.referenceNumber,
    required this.status,
    required this.lastUpdate,
    required this.progressPercentage,
  });
}
