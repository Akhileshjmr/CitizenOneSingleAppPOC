import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';

import '../../common_models/HeaderInfo.dart';
import '../../common_models/ServerMessage.dart';
import 'GdbChLookupForm.dart';
import 'GdbLookupForm.dart';
import 'L2lMobMessage.dart';

class GdbCustRtlAppResponse {
  HeaderInfo? headerInfo; // matches Java
  ServerMessage? resMessage; // added (Java has this!)

  int? gdbCustId;
  GdbCustRtlFormResponse? customerDet;
  GdbChLookupForm? appStatus;
  String? overAllStatus;
  bool? isBanked;
  String? appRefNumber;
  double? initLimitVal;
  String? reqSecureKey;
  List<GdbLookupForm>? docNamesList;

  L2lMobMessage message; // Java default value = new L2lMobMessage()

  String? custCode;
  String? uniqueId;
  String? custName;
  DateTime? dob;
  String? gender;

  GdbCustRtlAppResponse({
    this.headerInfo,
    this.resMessage, // added
    this.gdbCustId,
    this.customerDet,
    this.appStatus,
    this.overAllStatus,
    this.isBanked,
    this.appRefNumber,
    this.initLimitVal,
    this.reqSecureKey,
    this.docNamesList,
    L2lMobMessage? message,
    this.custCode,
    this.uniqueId,
    this.custName,
    this.dob,
    this.gender,
  }) : message = message ?? L2lMobMessage();

  factory GdbCustRtlAppResponse.fromJson(Map<String, dynamic> json) {
    return GdbCustRtlAppResponse(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      gdbCustId: json['gdbCustId'],
      customerDet: json['customerDet'] != null
          ? GdbCustRtlFormResponse.fromJson(json['customerDet'])
          : null,
      appStatus: json['appStatus'] != null
          ? GdbChLookupForm.fromJson(json['appStatus'])
          : null,
      overAllStatus: json['overAllStatus'],
      isBanked: json['isBanked'],
      appRefNumber: json['appRefNumber'],
      initLimitVal: json['initLimitVal'] != null
          ? (json['initLimitVal'] as num).toDouble()
          : null,
      reqSecureKey: json['reqSecureKey'],
      docNamesList: (json['docNamesList'] as List?)
          ?.map((e) => GdbLookupForm.fromJson(e))
          .toList(),
      message: json['message'] != null
          ? L2lMobMessage.fromJson(json['message'])
          : L2lMobMessage(),
      custCode: json['custCode'],
      uniqueId: json['unique_id'],
      custName: json['cust_name'],
      dob: json['dob'] != null ? _parseDate(json['dob']) : null,
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'gdbCustId': gdbCustId,
      'customerDet': customerDet?.toJson(),
      'appStatus': appStatus?.toJson(),
      'overAllStatus': overAllStatus,
      'isBanked': isBanked,
      'appRefNumber': appRefNumber,
      'initLimitVal': initLimitVal,
      'reqSecureKey': reqSecureKey,
      'docNamesList': docNamesList?.map((e) => e.toJson()).toList(),
      'message': message.toJson(),
      'custCode': custCode,
      'unique_id': uniqueId,
      'cust_name': custName,
      'dob': dob?.toIso8601String(),
      'gender': gender,
    };
  }

  /// Handles both timestamp (long) and string format from Java
  static DateTime? _parseDate(dynamic dob) {
    if (dob == null) return null;

    if (dob is int) {
      return DateTime.fromMillisecondsSinceEpoch(dob);
    }

    return DateTime.tryParse(dob.toString());
  }
}
