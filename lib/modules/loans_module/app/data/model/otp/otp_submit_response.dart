import '../common/ch_message.dart';
import '../user/url_decision.dart';

class OtpSubmitResponse {
  OtpSubmitResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.flowType,
    this.isInterest,
    this.interestMsg,
    this.status,
  });

  OtpSubmitResponse.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision =
        json['urlDecision'] != null
            ? UrlDecision.fromJson(json['urlDecision'])
            : null;
    value = json['value'];
    flowType = json['flowType'];
    isInterest = json['isInterest'];
    interestMsg = json['interestMsg'];
    status = json['status'];
  }
  String? reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  UrlDecision? urlDecision;
  String? value;
  String? flowType;
  bool? isInterest;
  String? interestMsg;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    final chMessage = this.chMessage;
    if (chMessage != null) {
      map['chMessage'] = chMessage.toJson();
    }
    final urlDecision = this.urlDecision;
    if (urlDecision != null) {
      map['urlDecision'] = urlDecision.toJson();
    }
    map['value'] = value;
    map['flowType'] = flowType;
    map['isInterest'] = isInterest;
    map['interestMsg'] = interestMsg;
    map['status'] = status;
    return map;
  }
}
