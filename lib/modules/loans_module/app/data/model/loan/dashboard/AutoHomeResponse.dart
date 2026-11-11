import '../../common/ch_message.dart';
import 'Layouts.dart';

class AutoHomeResponse {
  AutoHomeResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.smsVendorResp,
    this.layouts,
  });

  AutoHomeResponse.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    smsVendorResp = json['smsVendorResp'];
    if (json['layouts'] != null) {
      layouts = [];
      json['layouts'].forEach((v) {
        layouts?.add(Layouts.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic smsVendorResp;
  List<Layouts>? layouts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['smsVendorResp'] = smsVendorResp;
    if (layouts != null) {
      map['layouts'] = layouts?.map((v) => v?.toJson()).toList();
    }
    return map;
  }
}
