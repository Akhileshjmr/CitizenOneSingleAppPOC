class InsurancePartnerEntity {
  final String vendorName;
  final String vendorCode;
  final String vendorDesc;
  final String vendorLogo;
  final String vendorKey;
  final String vendorMob;

  const InsurancePartnerEntity({
    required this.vendorName,
    required this.vendorCode,
    required this.vendorDesc,
    required this.vendorLogo,
    required this.vendorKey,
    required this.vendorMob,
  });

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    return normalized.isEmpty ||
        vendorName.toLowerCase().contains(normalized) ||
        vendorDesc.toLowerCase().contains(normalized) ||
        vendorKey.toLowerCase().contains(normalized);
  }
}

