class SearchKycUserResponse {
  final bool recordExists;
  final ChMessage? chMessage;
  final KycDetails? kycDetails;
  final Source? source;

  SearchKycUserResponse({
    required this.recordExists,
    this.chMessage,
    this.kycDetails,
    this.source,
  });

  factory SearchKycUserResponse.fromJson(Map<String, dynamic> json) {
    return SearchKycUserResponse(
      recordExists: json['recordExists'] as bool? ?? false,
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      kycDetails: json['kycDetails'] != null
          ? KycDetails.fromJson(json['kycDetails'] as Map<String, dynamic>)
          : null,
      source: json['source'] != null
          ? Source.fromJson(json['source'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool isError;
  final String? subject;

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError = false,
    this.subject,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool? ?? false,
      subject: json['subject'] as String?,
    );
  }
}

class KycDetails {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final double? monthlyIncome;
  final String? sourceFunds;
  final String? mobileNumber;
  final String? nationalId;
  final String? empType;
  final String? sector;
  final String? employerName;
  final String? businessNature;
  final String? businessName;
  final String? kycStatus;
  final String? code;
  final String? status;
  final String? createdDate;
  final KycLocation? originCountry;
  final Communication? communication;
  final List<Document> documents;
  final Document? signature;
  final Document? photo;

  KycDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.monthlyIncome,
    this.sourceFunds,
    this.mobileNumber,
    this.nationalId,
    this.empType,
    this.sector,
    this.employerName,
    this.businessNature,
    this.businessName,
    this.kycStatus,
    this.code,
    this.status,
    this.createdDate,
    this.originCountry,
    this.communication,
    this.documents = const [],
    this.signature,
    this.photo,
  });

  factory KycDetails.fromJson(Map<String, dynamic> json) {
    return KycDetails(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      sourceFunds: json['sourceFunds'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      nationalId: json['nationalId'] as String?,
      empType: json['empType'] as String?,
      sector: json['sector'] as String?,
      employerName: json['employerName'] as String?,
      businessNature: json['businessNature'] as String?,
      businessName: json['businessName'] as String?,
      kycStatus: json['kycStatus'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String?,
      createdDate: json['createdDate'] as String?,
      originCountry: json['originCountry'] != null
          ? KycLocation.fromJson(json['originCountry'] as Map<String, dynamic>)
          : null,
      communication: json['communication'] != null
          ? Communication.fromJson(
              json['communication'] as Map<String, dynamic>)
          : null,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((d) => Document.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      signature: json['signature'] != null
          ? Document.fromJson(json['signature'] as Map<String, dynamic>)
          : null,
      photo: json['photo'] != null
          ? Document.fromJson(json['photo'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Communication {
  final String? email;
  final String? phNumber;
  final String? pbNumber;
  final String? addressLine;
  final KycLocation? country;
  final KycLocation? state;
  final KycLocation? district;
  final KycLocation? city;
  final KycLocation? province;

  Communication({
    this.email,
    this.phNumber,
    this.pbNumber,
    this.addressLine,
    this.country,
    this.state,
    this.district,
    this.city,
    this.province,
  });

  factory Communication.fromJson(Map<String, dynamic> json) {
    return Communication(
      email: json['email'] as String?,
      phNumber: json['phNumber'] as String?,
      pbNumber: json['pbNumber'] as String?,
      addressLine: json['addressLine'] as String?,
      country: json['country'] != null
          ? KycLocation.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      state: json['state'] != null
          ? KycLocation.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      district: json['district'] != null
          ? KycLocation.fromJson(json['district'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? KycLocation.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      province: json['province'] != null
          ? KycLocation.fromJson(json['province'] as Map<String, dynamic>)
          : null,
    );
  }
}

class KycLocation {
  final int? id;
  final String? type;
  final String? friendlyType;

  KycLocation({
    this.id,
    this.type,
    this.friendlyType,
  });

  factory KycLocation.fromJson(Map<String, dynamic> json) {
    return KycLocation(
      id: json['id'] as int?,
      type: json['type']?.toString(),
      friendlyType: json['friendlyType'] as String?,
    );
  }
}

class Document {
  dynamic docRef;
  dynamic file;
  String docName;
  int docId;
  dynamic fileName;
  String docUrl;
  DateTime? issuingDate;
  dynamic verificationDate;
  DateTime? expiryDate;
  dynamic extension;
  dynamic uploadFile;
  dynamic filePath;

  Document({
    required this.docRef,
    required this.file,
    required this.docName,
    required this.docId,
    required this.fileName,
    required this.docUrl,
    required this.issuingDate,
    required this.verificationDate,
    required this.expiryDate,
    required this.extension,
    required this.uploadFile,
    required this.filePath,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        docRef: json['docRef'] ?? '',
        file: json['file'] ?? '',
        docName: (json['docName']!=null) ?  json['docName'] as String:  '',
        docId: (json['docId']!=null) ?  json['docId'] as int :  0,
        fileName: json['fileName'] ?? '',
        docUrl: (json['docUrl']!=null) ?  json['docUrl'] as String:  '',
        issuingDate: json['issuingDate'] != null
            ? DateTime.parse(json['issuingDate'] as String)
            : null,
        verificationDate: json['verificationDate'] ?? '',
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'] as  String)
            : null,
        extension: json['extension'] ?? '',
        uploadFile: json['uploadFile'] ?? '',
        filePath: json['filePath'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'docRef': docRef,
        'file': file,
        'docName': docName,
        'docId': docId,
        'fileName': fileName,
        'docUrl': docUrl,
        'issuingDate': issuingDate,
        'verificationDate': verificationDate,
        'expiryDate': expiryDate,
        'extension': extension,
        'uploadFile': uploadFile,
        'filePath': filePath,
      };

  Document copyWith({
    dynamic docRef,
    dynamic file,
    String? docName,
    int? docId,
    dynamic fileName,
    String? docUrl,
    DateTime? issuingDate,
    dynamic verificationDate,
    DateTime? expiryDate,
    dynamic extension,
    dynamic uploadFile,
    dynamic filePath,
    bool clearIssuingDate = false,
    bool clearExpiryDate = false,
  }) {
    return Document(
      docRef: docRef ?? this.docRef,
      file: file ?? this.file,
      docName: docName ?? this.docName,
      docId: docId ?? this.docId,
      fileName: fileName ?? this.fileName,
      docUrl: docUrl ?? this.docUrl,
      issuingDate: issuingDate ?? this.issuingDate,
      verificationDate: verificationDate ?? this.verificationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      extension: extension ?? this.extension,
      uploadFile: uploadFile ?? this.uploadFile,
      filePath: filePath ?? this.filePath,
    );
  }
}

class Source {
  final String? type;
  final String? friendlyType;

  Source({
    this.type,
    this.friendlyType,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      type: json['type'] as String?,
      friendlyType: json['friendlyType'] as String?,
    );
  }
}