import 'package:citizenone_app/modules/loans_module/app/data/model/user/url_decision.dart';

import 'l2l_mob_message.dart';

class LoginResponse {
  final String? reqSecureKey;
  final List<String> addiParams;
  final bool isInterest;
  final String? interestMsg;
  final L2lMobMessage chMessage;
  final UrlDecision? urlDecision;
  final String? value;
  final String? otp;
  final String? status;
  final String? appStatus;
  final String? hKey;
  final String? lastLoggedInDate;

  LoginResponse({
    this.reqSecureKey,
    this.addiParams = const [],
    this.isInterest = false,
    this.interestMsg,
    required this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.status,
    this.appStatus,
    this.hKey,
    this.lastLoggedInDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      reqSecureKey: json['reqSecureKey'] as String?,
      addiParams:
          json['addiParams'] != null
              ? List<String>.from(json['addiParams'])
              : const [],
      isInterest: json['isInterest'] ?? false,
      interestMsg: json['interestMsg'] as String?,
      chMessage: L2lMobMessage.fromJson(json['chMessage'] ?? {}),
      urlDecision:
          json['urlDecision'] != null
              ? UrlDecision.fromJson(json['urlDecision'])
              : null,
      value: json['value'] as String?,
      otp: json['otp'] as String?,
      status: json['status'] as String?,
      appStatus: json['appStatus'] as String?,
      hKey: json['hKey'] as String?,
      lastLoggedInDate: json['lastLoggedInDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'reqSecureKey': reqSecureKey,
    'addiParams': addiParams,
    'isInterest': isInterest,
    'interestMsg': interestMsg,
    'chMessage': chMessage.toJson(),
    'urlDecision': urlDecision?.toJson(),
    'value': value,
    'otp': otp,
    'status': status,
    'appStatus': appStatus,
    'hKey': hKey,
    'lastLoggedInDate': lastLoggedInDate,
  };
}
