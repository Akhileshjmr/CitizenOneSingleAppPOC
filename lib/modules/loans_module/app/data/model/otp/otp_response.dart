import 'dart:convert';

import '../common/ch_message.dart';

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  String? otp;

  OtpResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
    reqSecureKey: json["reqSecureKey"],
    addiParams: json["addiParams"],
    chMessage:
        json["chMessage"] == null
            ? null
            : ChMessage.fromJson(json["chMessage"]),
    urlDecision: json["urlDecision"],
    value: json["value"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "reqSecureKey": reqSecureKey,
    "addiParams": addiParams,
    "chMessage": chMessage?.toJson(),
    "urlDecision": urlDecision,
    "value": value,
    "otp": otp,
  };
}
