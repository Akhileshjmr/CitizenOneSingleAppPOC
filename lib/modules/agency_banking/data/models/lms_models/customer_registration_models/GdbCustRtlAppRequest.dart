import '../../common_models/HeaderInfo.dart';
import 'GdbCustRtlFormResponse.dart';

class GdbCustRtlAppRequest2 {
  HeaderInfo? headerInfo;
  GdbCustRtlFormResponse? customerDet;
  bool isDraft;
  int? gdbCustId;
  String? screenId;
  String? reqSecureKey;
  String? customerSearchStatus;
  String? custCode;

  GdbCustRtlAppRequest2({
    this.headerInfo,
    this.customerDet,
    this.isDraft = false,
    this.gdbCustId,
    this.screenId,
    this.reqSecureKey,
    this.customerSearchStatus,
    this.custCode,
  });

  factory GdbCustRtlAppRequest2.fromJson(Map<String, dynamic> json) {
    return GdbCustRtlAppRequest2(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      customerDet: json['customerDet'] != null
          ? GdbCustRtlFormResponse.fromJson(json['customerDet'])
          : null,
      isDraft: json['isDraft'] ?? false,
      gdbCustId: json['gdbCustId'],
      screenId: json['screenId'],
      reqSecureKey: json['reqSecureKey'],
      customerSearchStatus: json['customerSearchStatus'],
      custCode: json['custCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'customerDet': customerDet?.toJson(),
      'isDraft': isDraft,
      'gdbCustId': gdbCustId,
      'screenId': screenId,
      'reqSecureKey': reqSecureKey,
      'customerSearchStatus': customerSearchStatus,
      'custCode': custCode,
    };
  }
}
