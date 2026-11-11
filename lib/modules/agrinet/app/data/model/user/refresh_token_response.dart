import '../common/ch_message.dart';

class RefreshTokenResponse {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  String? token;
  dynamic refreshToken;
  dynamic useName;

  RefreshTokenResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.token,
    this.refreshToken,
    this.useName,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      useName: json['useName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'token': token,
      'refreshToken': refreshToken,
      'useName': useName,
    };
  }
}
