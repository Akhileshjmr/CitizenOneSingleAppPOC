import '../common/ch_message.dart';

class OtpResponse {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;

  OtpResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      reqSecureKey: json["reqSecureKey"],
      addiParams: json["addiParams"],
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,
      urlDecision: json["urlDecision"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reqSecureKey": reqSecureKey,
      "addiParams": addiParams,
      "chMessage": chMessage?.toJson(),
      "urlDecision": urlDecision,
    };
  }
}
