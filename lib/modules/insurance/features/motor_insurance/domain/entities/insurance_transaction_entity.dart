class InsuranceTransactionEntity {
  final String txnNumber;
  final String category;
  final String customerName;
  final String customerPhone;
  final String? vehicleRegNo;
  final String? policyNumber;
  final String policyId;
  final double? policyGrossPremium;
  final String transactionStatus;
  final String transactionStatusLabel;
  final DateTime? createdAt;
  final String? referenceNumber;
  final String? hostReferenceNumber;

  const InsuranceTransactionEntity({
    required this.txnNumber,
    required this.category,
    required this.customerName,
    required this.customerPhone,
    required this.policyId,
    this.vehicleRegNo,
    this.policyNumber,
    this.policyGrossPremium,
    required this.transactionStatus,
    required this.transactionStatusLabel,
    this.createdAt,
    this.referenceNumber,
    this.hostReferenceNumber,
  });
}

class InsuranceTransactionListEntity {
  final List<InsuranceTransactionEntity> transactions;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final bool isLastPage;

  const InsuranceTransactionListEntity({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalElements,
    required this.isLastPage,
  });
}
