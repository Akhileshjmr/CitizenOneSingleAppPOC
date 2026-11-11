import 'ChMessage.dart';

class ComResp {
  ComResp({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value, 
      this.otp,});

  ComResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
  }
  String? reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  String? urlDecision;
  String? value;
  String? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['otp'] = otp;
    return map;
  }

}