class KycUserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;
  final double monthlyIncome;
  final String sourceFunds;
  final String mobileNumber;
  final String nationalId;
  final String empType;
  final String sector;
  final String employerName;
  final String? businessNature;
  final String? businessName;
  final String? kycStatus;
  final String? code;
  final String? status;
  final String? createdDate;
  final LocationRefEntity? originCountry;
  final KycCommunicationEntity? communication;
  final List<KycDocumentEntity>? documents;
  final KycDocumentEntity? signature;
  final KycDocumentEntity? photo;

  const KycUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.monthlyIncome,
    required this.sourceFunds,
    required this.mobileNumber,
    required this.nationalId,
    required this.empType,
    required this.sector,
    required this.employerName,
    this.businessNature,
    this.businessName,
    this.kycStatus,
    this.code,
    this.status,
    this.createdDate,
    this.originCountry,
    this.communication,
    this.documents,
    this.signature,
    this.photo,
  });
}

class KycCommunicationEntity {
  final String email;
  final String phNumber;
  final String pbNumber;
  final String addressLine;
  final LocationRefEntity? country;
  final LocationRefEntity? state;
  final LocationRefEntity? district;
  final LocationRefEntity? city;

  const KycCommunicationEntity({
    required this.email,
    required this.phNumber,
    required this.pbNumber,
    required this.addressLine,
    this.country,
    this.state,
    this.district,
    this.city,
  });
}

class LocationRefEntity {
  final int id;
  final String? type;
  final String friendlyType;

  const LocationRefEntity({
    required this.id,
    this.type,
    required this.friendlyType,
  });
}

class KycDocumentEntity {
  final dynamic docRef;
  final dynamic file;
  final String docName;
  final int docId;
  final dynamic fileName;
  final String docUrl;
  final DateTime? issuingDate;
  final dynamic verificationDate;
  final DateTime? expiryDate;
  final dynamic extension;
  final dynamic uploadFile;
  final dynamic filePath;

  const KycDocumentEntity({
    required this.docRef,
    required this.file,
    required this.docName,
    required this.docId,
    required this.fileName,
    required this.docUrl,
    this.issuingDate,
    this.verificationDate,
    this.expiryDate,
    this.extension,
    this.uploadFile,
    this.filePath,
  });
}
