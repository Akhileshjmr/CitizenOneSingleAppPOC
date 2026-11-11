import '../../../remote/provider/personal_loan/fields.dart';
import '../../common/ch_message.dart';

class PlLoanDetailsGetResp {
  PlLoanDetailsGetResp({
    this.reqSecureKey,
    this.addiParams,
    required this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.key,
    required this.fields,
  });

  PlLoanDetailsGetResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        (json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null)!;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    key = json['key'];
    if (json['fields'] != null) {
      fields = [];
      json['fields'].forEach((v) {
        fields?.add(Fields.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  String? key;
  List<Fields>? fields;

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
    map['key'] = key;
    if (fields != null) {
      map['fields'] = fields?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
