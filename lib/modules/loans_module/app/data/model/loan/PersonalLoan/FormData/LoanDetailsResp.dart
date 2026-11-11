import '../../../common/ch_message.dart';
import 'LoanDetails.dart';

class LoanDetailsResp {
  LoanDetailsResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.key,
    this.genDet,
    this.empDetails,
    this.addressDet,
    this.loanDetails,
    this.fields,
  });

  LoanDetailsResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    key = json['key'];
    genDet = json['genDet'];
    empDetails = json['empDetails'];
    addressDet = json['addressDet'];
    loanDetails =
        json['loanDetails'] != null
            ? LoanDetails.fromJson(json['loanDetails'])
            : null;
    fields = json['fields'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  String? key;
  dynamic genDet;
  dynamic empDetails;
  dynamic addressDet;
  LoanDetails? loanDetails;
  dynamic fields;

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
    map['genDet'] = genDet;
    map['empDetails'] = empDetails;
    map['addressDet'] = addressDet;
    if (loanDetails != null) {
      map['loanDetails'] = loanDetails?.toJson();
    }
    map['fields'] = fields;
    return map;
  }
}
