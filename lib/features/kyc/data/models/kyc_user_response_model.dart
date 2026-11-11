import 'dart:convert';

KycUserResponseModel kycUserResponseModelFromJson(String str) =>
    KycUserResponseModel.fromJson(json.decode(str));

String kycUserResponseModelToJson(KycUserResponseModel data) =>
    json.encode(data.toJson());

class KycUserResponseModel {
  bool recordExists;
  KycDetails kycDetails;

  KycUserResponseModel({
    required this.recordExists,
    required this.kycDetails,
  });

  factory KycUserResponseModel.fromJson(Map<String, dynamic> json) =>
      KycUserResponseModel(
        recordExists: json["recordExists"],
        kycDetails: KycDetails.fromJson(json["kycDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "recordExists": recordExists,
        "kycDetails": kycDetails.toJson(),
      };
}

class KycDetails {
  int id;
  String firstName;
  String lastName;
  String gender;
  String dob;
  double monthlyIncome;
  String sourceFunds;
  String mobileNumber;
  String nationalId;
  String empType;
  String sector;
  String employerName;
  String? businessNature;
  String? businessName;
  dynamic kycStatus;
  dynamic code;

  String? status;
  String? createdDate;

  OriginCountry? originCountry;
  Communication? communication;
  List<Document>? documents;

  Document? signature;
  Document? photo;

  KycDetails({
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

  factory KycDetails.fromJson(Map<String, dynamic> json) => KycDetails(
        id: json["id"] ?? 0,
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        gender: json["gender"] ?? "",
        dob: json["dob"] ?? "",
        monthlyIncome: (json["monthlyIncome"] ?? 0).toDouble(),
        sourceFunds: json["sourceFunds"] ?? "",
        mobileNumber: json["mobileNumber"] ?? "",
        nationalId: json["nationalId"] ?? "",
        empType: json["empType"] ?? "",
        sector: json["sector"] ?? "",
        employerName: json["employerName"] ?? "",
        businessNature: json["businessNature"],
        businessName: json["businessName"],
        kycStatus: json["kycStatus"],
        code: json["code"],
        status: json["status"],
        createdDate: json["createdDate"],
        originCountry: json["originCountry"] != null
            ? OriginCountry.fromJson(json["originCountry"])
            : null,
        communication: json["communication"] != null
            ? Communication.fromJson(json["communication"])
            : null,
        documents: json["documents"] != null
            ? List<Document>.from(
                json["documents"].map((x) => Document.fromJson(x)))
            : [],
        signature: json["signature"] != null
            ? Document.fromJson(json["signature"])
            : null,
        photo: json["photo"] != null ? Document.fromJson(json["photo"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "dob": dob,
        "monthlyIncome": monthlyIncome,
        "sourceFunds": sourceFunds,
        "mobileNumber": mobileNumber,
        "nationalId": nationalId,
        "empType": empType,
        "sector": sector,
        "employerName": employerName,
        "businessNature": businessNature,
        "businessName": businessName,
        "kycStatus": kycStatus,
        "code": code,
        "status": status,
        "createdDate": createdDate,
        "originCountry": originCountry?.toJson(),
        "communication": communication?.toJson(),
        "documents": documents != null
            ? List<dynamic>.from(documents!.map((x) => x.toJson()))
            : [],
        "signature": signature?.toJson(),
        "photo": photo?.toJson(),
      };
}

class Communication {
  String email;
  String phNumber;
  String pbNumber;
  String addressLine;
  OriginCountry? country;
  dynamic province;
  OriginCountry? district;
  OriginCountry? state;
  OriginCountry? city;

  Communication({
    required this.email,
    required this.phNumber,
    required this.pbNumber,
    required this.addressLine,
    required this.country,
    required this.province,
    required this.district,
    required this.state,
    required this.city,
  });

  factory Communication.fromJson(Map<String, dynamic> json) => Communication(
        email: json["email"] ?? "",
        phNumber: json["phNumber"] ?? "",
        pbNumber: json["pbNumber"] ?? "",
        addressLine: json["addressLine"] ?? "",
        country: (json["country"] != null)
            ? OriginCountry.fromJson(json["country"])
            : null,
        province: json["province"] ?? "",
        district: (json["district"] != null)
            ? OriginCountry.fromJson(json["district"])
            : null,
        state: (json["state"] != null)
            ? OriginCountry.fromJson(json["state"])
            : null,
        city: (json["city"] != null)
            ? OriginCountry.fromJson(json["city"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phNumber": phNumber,
        "pbNumber": pbNumber,
        "addressLine": addressLine,
        "country": country!.toJson(),
        "province": province,
        "district": district!.toJson(),
        "state": state!.toJson(),
        "city": city!.toJson(),
      };
}

class OriginCountry {
  int id;
  String? type;
  String friendlyType;
  dynamic other;

  OriginCountry({
    required this.id,
    required this.type,
    required this.friendlyType,
    required this.other,
  });

  factory OriginCountry.fromJson(Map<String, dynamic> json) => OriginCountry(
        id: json["id"],
        type: json["type"],
        friendlyType: json["friendlyType"],
        other: json["other"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "friendlyType": friendlyType,
        "other": other,
      };
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
        docRef: json["docRef"] ?? "",
        file: json["file"] ?? "",
        docName: json["docName"] ?? "",
        docId: json["docId"] ?? "",
        fileName: json["fileName"] ?? "",
        docUrl: json["docUrl"] ?? "",
        issuingDate: json['issuingDate'] != null
            ? DateTime.parse(json['issuingDate'])
            : null,
        verificationDate: json["verificationDate"] ?? "",
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'])
            : null,
        extension: json["extension"] ?? "",
        uploadFile: json["uploadFile"] ?? "",
        filePath: json["filePath"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "docRef": docRef,
        "file": file,
        "docName": docName,
        "docId": docId,
        "fileName": fileName,
        "docUrl": docUrl,
        "issuingDate": issuingDate,
        "verificationDate": verificationDate,
        "expiryDate": expiryDate,
        "extension": extension,
        "uploadFile": uploadFile,
        "filePath": filePath,
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
