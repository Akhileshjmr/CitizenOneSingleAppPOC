import '../../common/ch_message.dart';
import 'CommonDet.dart';

class ComResp {
  ComResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.smsVendorResp,
    this.value,
    this.commonDet,
    this.refundRefNumber,
  });

  ComResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] == null
            ? []
            : List<String>.from(json['addiParams'].map((x) => x ?? ''));
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    smsVendorResp = json['smsVendorResp'];
    value = json['value'];
    commonDet =
        json['commonDet'] != null
            ? new CommonDet.fromJson(json['commonDet'])
            : null;
    refundRefNumber = json['refundRefNumber'];
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic smsVendorResp;
  CommonDet? commonDet;
  String? value;
  String? refundRefNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['smsVendorResp'] = smsVendorResp;
    map['value'] = value;
    if (this.commonDet != null) {
      map['commonDet'] = this.commonDet!.toJson();
    }
    map['refundRefNumber'] = refundRefNumber;
    return map;
  }
}
