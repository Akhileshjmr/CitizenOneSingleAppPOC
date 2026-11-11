// features/kyc/domain/entities/kyc_params_entity.dart

class KycDocumentParamEntity {
  final List<int>? file;
  final String docName;
  final String fileName;
  final String? issuingDate;
  final String? expiryDate;
  final int? docId;

  const KycDocumentParamEntity({
    this.file,
    required this.docName,
    required this.fileName,
    this.issuingDate,
    this.expiryDate,
    this.docId,
  });
}

class KycLocationRefParamEntity {
  final int id;
  final String name;

  const KycLocationRefParamEntity({
    required this.id,
    required this.name,
  });
}

class SubmitKycParams {
  final String agentMobileNumber;

  // Personal
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;
  final String mobileNumber;
  final String nationalId;

  // Professional
  final double monthlyIncome;
  final String sourceFunds;
  final String empType;
  final String sector;
  final String employerName;
  final String? businessNature;
  final String? businessName;

  // Origin
  final KycLocationRefParamEntity originCountry;

  // Communication
  final String email;
  final String addressLine;
  final String phNumber;
  final String? pbNumber;
  final KycLocationRefParamEntity country;
  final KycLocationRefParamEntity state;
  final KycLocationRefParamEntity district;
  final KycLocationRefParamEntity city;

  // Files
  final KycDocumentParamEntity photo;
  final KycDocumentParamEntity signature;
  final List<KycDocumentParamEntity> documents;

  const SubmitKycParams({
    required this.agentMobileNumber,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.mobileNumber,
    required this.nationalId,
    required this.monthlyIncome,
    required this.sourceFunds,
    required this.empType,
    required this.sector,
    required this.employerName,
    this.businessNature,
    this.businessName,
    required this.originCountry,
    required this.email,
    required this.addressLine,
    required this.phNumber,
    this.pbNumber,
    required this.country,
    required this.state,
    required this.district,
    required this.city,
    required this.photo,
    required this.signature,
    required this.documents,
  });
}

class UpdateKycParams extends SubmitKycParams {
  final int kycId;
  final String? kycStatus;
  final String? code;

  // Existing user docs (already uploaded on server)
  final List<ExistingKycDocumentParamEntity> existingDocuments;

  // New merged docs not yet on server
  final List<KycDocumentParamEntity> newDocuments;

  const UpdateKycParams({
    required this.kycId,
    this.kycStatus,
    this.code,
    required this.existingDocuments,
    required this.newDocuments,
    required super.agentMobileNumber,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.dob,
    required super.mobileNumber,
    required super.nationalId,
    required super.monthlyIncome,
    required super.sourceFunds,
    required super.empType,
    required super.sector,
    required super.employerName,
    super.businessNature,
    super.businessName,
    required super.originCountry,
    required super.email,
    required super.addressLine,
    required super.phNumber,
    super.pbNumber,
    required super.country,
    required super.state,
    required super.district,
    required super.city,
    required super.photo,
    required super.signature,
    required super.documents,
  });
}

class ExistingKycDocumentParamEntity {
  final dynamic docRef;
  final String docName;
  final dynamic fileName;
  final String docUrl;
  final String? issuingDate;
  final dynamic verificationDate;
  final String? expiryDate;
  final dynamic extension;
  final dynamic uploadFile;
  final dynamic filePath;
  final dynamic file;
  final int? docId;

  const ExistingKycDocumentParamEntity({
    this.docRef,
    required this.docName,
    this.fileName,
    required this.docUrl,
    this.issuingDate,
    this.verificationDate,
    this.expiryDate,
    this.extension,
    this.uploadFile,
    this.filePath,
    this.file,
    this.docId,
  });
}

class FetchHistoryParams {
  final String agentMobileNumber;
  final String filter;
  final int page;
  final DateTime? fromDate;
  final DateTime? toDate;

  const FetchHistoryParams({
    required this.agentMobileNumber,
    required this.filter,
    required this.page,
    this.fromDate,
    this.toDate,
  });
}

class SendOtpParams {
  final String mobile;
  final String? email;

  const SendOtpParams({required this.mobile, this.email});
}

class VerifyOtpParams {
  final String otp;
  final String mobile;
  final String? email;
  final String channel;

  const VerifyOtpParams({
    required this.otp,
    required this.mobile,
    this.email,
    required this.channel,
  });
}
