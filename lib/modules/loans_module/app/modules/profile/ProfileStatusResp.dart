// To parse this JSON data, do
//
//     final profileStatusResp = profileStatusRespFromJson(jsonString);

import 'dart:convert';

ProfileStatusResp profileStatusRespFromJson(String str) => ProfileStatusResp.fromJson(json.decode(str));

String profileStatusRespToJson(ProfileStatusResp data) => json.encode(data.toJson());

class ProfileStatusResp {

  String? reqSecureKey;
  List<String?>? addiParams;
  ChMessage? chMessage;
  String? value;
  Address? registrationStatus;
  Address? personalDetails;
  Address? professionalDetails;
  Address? address;
  // Address? incomeDetails;
  // Address? documents;
  Address? interests;
  Address? profilePic;
  String? profileStatus;
  String? weightage;
  String? firstName;

  ProfileStatusResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.value,
    this.registrationStatus,
    this.personalDetails,
    this.professionalDetails,
    this.address,
    // this.incomeDetails,
    // this.documents,
    this.interests,
    this.profilePic,
    this.profileStatus,
    this.weightage,
    this.firstName,
  });

  factory ProfileStatusResp.fromJson(Map<String, dynamic> json) => ProfileStatusResp(
    reqSecureKey: json["reqSecureKey"],
    addiParams: json["addiParams"] == null
        ? []
        : List<String?>.from(json["addiParams"].map((x) => x)), // == null? [] : List<String>.from(json["addiParams"].map((x) => x));
    chMessage: ChMessage.fromJson(json["chMessage"]),
    value: json["value"],
    registrationStatus: Address.fromJson(json["registrationStatus"]),
    personalDetails: Address.fromJson(json["personalDetails"]),
    professionalDetails: Address.fromJson(json["professionalDetails"]),
    address: Address.fromJson(json["address"]),
    // incomeDetails: Address.fromJson(json["incomeDetails"]),
    // documents: Address.fromJson(json["documents"]),
    interests: Address.fromJson(json["interests"]),
    profilePic: Address.fromJson(json["profilePic"]),
    profileStatus: json["profileStatus"],
    weightage: json["weightage"],
    firstName: json["firstName"],
  );

  Map<String, dynamic> toJson() => {
  "reqSecureKey": reqSecureKey,
  "addiParams": addiParams,
  "value": value,
  "registrationStatus": registrationStatus?.toJson(),
  "personalDetails": personalDetails?.toJson(),
  "professionalDetails": professionalDetails?.toJson(),
  "address": address?.toJson(),
  // "incomeDetails": incomeDetails?.toJson(),
  // "documents": documents?.toJson(),
  "interests": interests?.toJson(),
  "profilePic": profilePic?.toJson(),
  "profileStatus": profileStatus,
  "weightage": weightage,
    "firstName": firstName,
};
}

class Address {

  String? status;
  String? weightage;

  Address({
    this.status,
    this.weightage,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    status: json["status"],
    weightage: json["weightage"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "weightage": weightage,
  };
}

class ChMessage {
  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    // this.dataArr,
  });

  String? code;
  String? message;
  String? type;
  String? dispType;
  bool? isError;
  String? subject;
  // List<String>? dataArr;

  factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
    code: json["code"],
    message: json["message"],
    type: json["type"],
    dispType: json["dispType"],
    isError: json["isError"],
    subject: json["subject"],
    // dataArr: List<String>.from(json["dataArr"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "type": type,
    "dispType": dispType,
    "isError": isError,
    "subject": subject,
    // "dataArr": List<dynamic>.from((dataArr ?? []).map((x) => x)),
  };
}

