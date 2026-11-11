class KycRecentHistoryResponseModel {
  final dynamic reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final List<KycHistoryDetails>? kycDetailsList;
  final dynamic source;
  final Paging? paging;

  KycRecentHistoryResponseModel({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.kycDetailsList,
    this.source,
    this.paging,
  });

  factory KycRecentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return KycRecentHistoryResponseModel(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'])
          : null,
      urlDecision: json['urlDecision'],
      kycDetailsList: (json['kycDetailsList'] as List?)
          ?.map((e) => KycHistoryDetails.fromJson(e))
          .toList(),
      source: json['source'],
      paging: json['paging'] != null ? Paging.fromJson(json['paging']) : null,
    );
  }
}

class ChMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;
  final String? subject;
  final dynamic dataArr;

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: json['code'],
      message: json['message'],
      type: json['type'],
      dispType: json['dispType'],
      isError: json['isError'],
      subject: json['subject'],
      dataArr: json['dataArr'],
    );
  }
}

class KycHistoryDetails {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dob;
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
  final DateTime? createdDate;
  final OriginCountry? originCountry;
  final dynamic communication;
  final dynamic documents;
  final DocumentFile? signature;
  final DocumentFile? photo;

  KycHistoryDetails({
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
    this.documents,
    this.signature,
    this.photo,
  });

  factory KycHistoryDetails.fromJson(Map<String, dynamic> json) {
    return KycHistoryDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
      sourceFunds: json['sourceFunds'],
      mobileNumber: json['mobileNumber'],
      nationalId: json['nationalId'],
      empType: json['empType'],
      sector: json['sector'],
      employerName: json['employerName'],
      businessNature: json['businessNature'],
      businessName: json['businessName'],
      kycStatus: json['kycStatus'],
      code: json['code'],
      status: json['status'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      originCountry: json['originCountry'] != null
          ? OriginCountry.fromJson(json['originCountry'])
          : null,
      communication: json['communication'],
      documents: json['documents'],
      signature: json['signature'] != null
          ? DocumentFile.fromJson(json['signature'])
          : null,
      photo:
          json['photo'] != null ? DocumentFile.fromJson(json['photo']) : null,
    );
  }
}

class OriginCountry {
  final int? id;
  final String? type;
  final String? friendlyType;
  final dynamic other;

  OriginCountry({
    this.id,
    this.type,
    this.friendlyType,
    this.other,
  });

  factory OriginCountry.fromJson(Map<String, dynamic> json) {
    return OriginCountry(
      id: json['id'],
      type: json['type'],
      friendlyType: json['friendlyType'],
      other: json['other'],
    );
  }
}

class DocumentFile {
  final String? docRef;
  final dynamic file;
  final String? docName;
  final int? docId;
  final String? fileName;
  final String? docUrl;
  final DateTime? issuingDate;
  final DateTime? verificationDate;
  final DateTime? expiryDate;
  final String? extension;
  final dynamic uploadFile;
  final String? filePath;

  DocumentFile({
    this.docRef,
    this.file,
    this.docName,
    this.docId,
    this.fileName,
    this.docUrl,
    this.issuingDate,
    this.verificationDate,
    this.expiryDate,
    this.extension,
    this.uploadFile,
    this.filePath,
  });

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      docRef: json['docRef'],
      file: json['file'],
      docName: json['docName'],
      docId: json['docId'],
      fileName: json['fileName'],
      docUrl: json['docUrl'],
      issuingDate: json['issuingDate'] != null
          ? DateTime.parse(json['issuingDate'])
          : null,
      verificationDate: json['verificationDate'] != null
          ? DateTime.parse(json['verificationDate'])
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      extension: json['extension'],
      uploadFile: json['uploadFile'],
      filePath: json['filePath'],
    );
  }
}

class Paging {
  final int? pageNum;
  final int? totalPages;
  final int? totalRecs;
  final int? recsPerPage;
  final dynamic sortBy;
  final String? sortByType;
  final int? paginationRecords;
  final dynamic facetFilter;

  Paging({
    this.pageNum,
    this.totalPages,
    this.totalRecs,
    this.recsPerPage,
    this.sortBy,
    this.sortByType,
    this.paginationRecords,
    this.facetFilter,
  });

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      pageNum: json['pageNum'],
      totalPages: json['totalPages'],
      totalRecs: json['totalRecs'],
      recsPerPage: json['recsPerPage'],
      sortBy: json['sortBy'],
      sortByType: json['sortByType'],
      paginationRecords: json['paginationRecords'],
      facetFilter: json['facetFilter'],
    );
  }
}