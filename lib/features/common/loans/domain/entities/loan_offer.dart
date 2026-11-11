class LoanOffer {
  final String id;
  final String bankName;
  final String bankLogo;
  final double interestRate;
  final String tenure;
  final double processingFee;
  final double emi;
  final double maxAmount;
  final List<String> features;
  final bool isPreApproved;

  const LoanOffer({
    required this.id,
    required this.bankName,
    required this.bankLogo,
    required this.interestRate,
    required this.tenure,
    required this.processingFee,
    required this.emi,
    required this.maxAmount,
    required this.features,
    this.isPreApproved = false,
  });
}
