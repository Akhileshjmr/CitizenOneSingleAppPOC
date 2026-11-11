// features/kyc/domain/entities/kyc_history_entity.dart

class KycHistoryEntity {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final String? nationalId;
  final String? kycStatus;
  final String? code;
  final DateTime? createdDate;

  const KycHistoryEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.nationalId,
    this.kycStatus,
    this.code,
    this.createdDate,
  });
}

class KycHistoryResultEntity {
  final List<KycHistoryEntity> items;
  final int currentPage;
  final int totalPages;

  const KycHistoryResultEntity({
    required this.items,
    required this.currentPage,
    required this.totalPages,
  });
}
