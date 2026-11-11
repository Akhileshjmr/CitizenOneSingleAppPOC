import '../../common_models/HeaderInfo.dart';
import '../../common_models/ServerMessage.dart';

class GdbChAppStatusReqRes {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? _applicantId;
  String? _customerCode;
  String? _mobileNo;
  String? _applicationStatus;
  String? _responseCode;
  String? _responseDesc;

  // Constructor
  GdbChAppStatusReqRes({
    this.headerInfo,
    this.resMessage,
    String? applicantId,
    String? customerCode,
    String? mobileNo,
    String? applicationStatus,
    String? responseCode,
    String? responseDesc,
  }) {
    _applicantId = applicantId;
    _customerCode = customerCode;
    _mobileNo = mobileNo;
    _applicationStatus = applicationStatus;
    _responseCode = responseCode;
    _responseDesc = responseDesc;
  }

  // Getters
  String? get applicantId => _applicantId;
  String? get customerCode => _customerCode;
  String? get mobileNo => _mobileNo;
  String? get applicationStatus => _applicationStatus;
  String? get responseCode => _responseCode;
  String? get responseDesc => _responseDesc;

  // Setters
  set applicantId(String? value) => _applicantId = value;
  set customerCode(String? value) => _customerCode = value;
  set mobileNo(String? value) => _mobileNo = value;
  set applicationStatus(String? value) => _applicationStatus = value;
  set responseCode(String? value) => _responseCode = value;
  set responseDesc(String? value) => _responseDesc = value;

  // fromJson factory method
  factory GdbChAppStatusReqRes.fromJson(Map<String, dynamic> json) {
    return GdbChAppStatusReqRes(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      applicantId: json['applicantId'] as String?,
      customerCode: json['customerCode'] as String?,
      mobileNo: json['mobileNo'] as String?,
      applicationStatus: json['applicationStatus'] as String?,
      responseCode: json['responseCode'] as String?,
      responseDesc: json['responseDesc'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'applicantId': _applicantId,
      'customerCode': _customerCode,
      'mobileNo': _mobileNo,
      'applicationStatus': _applicationStatus,
      'responseCode': _responseCode,
      'responseDesc': _responseDesc,
    };
  }
}