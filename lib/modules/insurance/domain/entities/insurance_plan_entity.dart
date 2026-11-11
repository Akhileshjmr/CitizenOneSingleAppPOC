class InsurancePlanEntity {
  final String id;
  final String title;
  final String company;
  final String premium;
  final String cover;
  final String claimRatio;
  final String network;
  final String highlight;
  final String categoryCode;

  const InsurancePlanEntity({
    required this.id,
    required this.title,
    required this.company,
    required this.premium,
    required this.cover,
    required this.claimRatio,
    required this.network,
    required this.highlight,
    this.categoryCode = 'HEALTH',
  });
}

