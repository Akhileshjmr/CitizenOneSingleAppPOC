import 'ChMessage.dart';

class PersonalFormSumbitResp {
  PersonalFormSumbitResp({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value,});

  PersonalFormSumbitResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    return map;
  }

}