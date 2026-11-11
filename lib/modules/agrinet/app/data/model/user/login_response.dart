import '../common/ch_message.dart';
import 'pal_res.dart';

class LoginResponse {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  int? userId;
  dynamic serverMessage;
  String? status;
  String? role;
  PalRes? palRes;
  String? token;
  String? sessionTime;

  LoginResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.userId,
    this.serverMessage,
    this.status,
    this.role,
    this.palRes,
    this.token,
    this.sessionTime,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      userId: json['userId'],
      serverMessage: json['serverMessage'],
      status: json['status'],
      role: json['role'],
      palRes: json['palRes'] != null ? PalRes.fromJson(json['palRes']) : null,
      token: json['token'],
      sessionTime: json['sessionTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'userId': userId,
      'serverMessage': serverMessage,
      'status': status,
      'role': role,
      'palRes': palRes?.toJson(),
      'token': token,
      'sessionTime': sessionTime,
    };
  }
}
