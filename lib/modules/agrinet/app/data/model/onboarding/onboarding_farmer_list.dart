import 'package:citizenone_app/modules/agrinet/app/data/model/onboarding/cust_signature.dart';

import '../common/ch_message.dart';
import '../common/option.dart';

class FarmerOnBoardList {
  final String? reqSecureKey;
  final String? addiParams;
  final ChMessage? chMessage;
  final String? urlDecision;
  final List<FarmerOnBoard>? farmerOnBoard;

  FarmerOnBoardList({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.farmerOnBoard,
  });

  factory FarmerOnBoardList.fromJson(Map<String, dynamic> json) {
    return FarmerOnBoardList(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      farmerOnBoard:
          json['farmerOnBoard'] != null
              ? List.generate(
                json['farmerOnBoard'].length,
                (i) => FarmerOnBoard.fromJson(json['farmerOnBoard'][i]),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'reqSecureKey': reqSecureKey,
    'addiParams': addiParams,
    'chMessage': chMessage?.toJson(),
    'urlDecision': urlDecision,
    'farmerOnBoard': farmerOnBoard?.map((farmer) => farmer.toJson()).toList(),
  };
}

// ------------------- FARMER ON BOARD --------------------

class FarmerOnBoard {
  final String? reqSecureKey;
  final String? filterVal;
  final String? addiParams;
  final int? id;
  final GeneralDetails? generalDetails;
  final BankDetails? bankDetails;
  final String? mobileScreen;
  final String? status;

  FarmerOnBoard({
    this.reqSecureKey,
    this.filterVal,
    this.addiParams,
    this.id,
    this.generalDetails,
    this.bankDetails,
    this.mobileScreen,
    this.status,
  });

  factory FarmerOnBoard.fromJson(Map<String, dynamic> json) => FarmerOnBoard(
    reqSecureKey: json['reqSecureKey'],
    filterVal: json['filterVal'],
    addiParams: json['addiParams'],
    id: json['id'],
    generalDetails:
        json['generalDetails'] != null
            ? GeneralDetails.fromJson(json['generalDetails'])
            : null,
    bankDetails:
        json['bankDetails'] != null
            ? BankDetails.fromJson(json['bankDetails'])
            : null,
    mobileScreen: json['mobileScreen'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'reqSecureKey': reqSecureKey,
    'filterVal': filterVal,
    'addiParams': addiParams,
    'id': id,
    'generalDetails': generalDetails?.toJson(),
    'bankDetails': bankDetails?.toJson(),
    'mobileScreen': mobileScreen,
    'status': status,
  };
}

// ------------------- GENERAL DETAILS --------------------

class GeneralDetails {
  final int? id;
  final CustPhoto? custPhoto;
  final CustSignature? custSignature;
  final Option? gender;
  final String? surName;
  final String? name;
  final Option? language;
  final String? dateOfBirth;
  final Option? maritalStatus;
  final Option? nationality;
  final Option? state;
  final Option? country;
  final String? isBlacklisted;
  final String? address;

  GeneralDetails({
    this.id,
    this.custPhoto,
    this.custSignature,
    this.gender,
    this.surName,
    this.name,
    this.language,
    this.dateOfBirth,
    this.maritalStatus,
    this.nationality,
    this.state,
    this.country,
    this.isBlacklisted,
    this.address,
  });

  factory GeneralDetails.fromJson(Map<String, dynamic> json) => GeneralDetails(
    id: json['id'],
    custPhoto:
        json['custPhoto'] != null
            ? CustPhoto.fromJson(json['custPhoto'])
            : null,
    custSignature:
        json["custSignature"] != null
            ? CustSignature.fromJson(json["custSignature"])
            : null,
    gender: json["gender"] != null ? Option.fromJson(json["gender"]) : null,
    surName: json['surName'],
    name: json['name'],
    language:
        json["language"] != null ? Option.fromJson(json["language"]) : null,
    dateOfBirth: convertTimestampToDate(json['dateOfBirth']),
    maritalStatus:
        json["maritalStatus"] != null
            ? Option.fromJson(json["maritalStatus"])
            : null,
    nationality:
        json["nationality"] != null
            ? Option.fromJson(json["nationality"])
            : null,
    state: json["state"] != null ? Option.fromJson(json["state"]) : null,
    country: json["country"] != null ? Option.fromJson(json["country"]) : null,
    isBlacklisted: json['isBlacklisted'],
    address: json['address'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'custPhoto': custPhoto?.toJson(),
    'custSignature': custSignature,
    'gender': gender?.toJson(),
    'surName': surName,
    'name': name,
    'language': language?.toJson(),
    'dateOfBirth': dateOfBirth,
    'maritalStatus': maritalStatus?.toJson(),
    'nationality': nationality?.toJson(),
    'state': state?.toJson(),
    'country': country?.toJson(),
    'isBlacklisted': isBlacklisted,
    'address': address,
  };
}

String convertTimestampToDate(dynamic value) {
  if (value == null) return "";

  // If backend returns int → convert to DateTime
  if (value is int) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value);
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // If already in string format → just return
  if (value is String) {
    return value;
  }

  return "";
}
// ------------------- CUST PHOTO --------------------

class CustPhoto {
  final String? docRef;
  final dynamic file;
  final String? docName;
  final int? docId;
  final String? fileName;
  final String? docUrl;
  final String? issuingDate;
  final String? verificationDate;
  final String? expiryDate;
  final String? extension;
  final dynamic uploadFile;
  final String? filePath;

  CustPhoto({
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

  factory CustPhoto.fromJson(Map<String, dynamic> json) => CustPhoto(
    docRef: json['docRef'],
    file: json['file'],
    docName: json['docName'],
    docId: json['docId'],
    fileName: json['fileName'],
    docUrl: json['docUrl'],
    issuingDate: json['issuingDate'],
    verificationDate: json['verificationDate'],
    expiryDate: json['expiryDate'],
    extension: json['extension'],
    uploadFile: json['uploadFile'],
    filePath: json['filePath'],
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
}

// ------------------- BANK DETAILS --------------------

class BankDetails {
  final String? regionCode;
  final String? regionName;
  final Option? formerId;

  BankDetails({this.regionCode, this.regionName, this.formerId});

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    regionCode: json['regionCode'],
    regionName: json['regionName'],
    formerId:
        json['formerId'] != null ? Option.fromJson(json['formerId']) : null,
  );

  Map<String, dynamic> toJson() => {
    'regionCode': regionCode,
    'regionName': regionName,
    'formerId': formerId?.toJson(),
  };
}
