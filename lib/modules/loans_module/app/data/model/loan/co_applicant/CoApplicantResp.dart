import '../../common/ch_message.dart';
import 'CoApplForm.dart';

class CoApplicantResp {
  CoApplicantResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.isExternal,
    this.key,
    this.genDet,
    this.empDetails,
    this.addressDet,
    this.loanDetails,
    this.coApplForm,
    this.fields,
    this.lastLoggedInTime,
    this.logCount,
    this.lastUpdatedDate,
  });

  CoApplicantResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    isExternal = json['isExternal'];
    key = json['key'];
    genDet = json['genDet'];
    empDetails = json['empDetails'];
    addressDet = json['addressDet'];
    loanDetails = json['loanDetails'];
    coApplForm =
        json['coApplDetails'] != null
            ? CoApplForm.fromJson(json['coApplDetails'])
            : null;
    fields = json['fields'];
    lastLoggedInTime = json['lastLoggedInTime'];
    logCount = json['logCount'];
    lastUpdatedDate = json['lastUpdatedDate'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  bool? isExternal;
  String? key;
  dynamic genDet;
  dynamic empDetails;
  dynamic addressDet;
  dynamic loanDetails;
  CoApplForm? coApplForm;
  dynamic fields;
  String? lastLoggedInTime;
  dynamic logCount;
  String? lastUpdatedDate;

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
    map['isExternal'] = isExternal;
    map['key'] = key;
    map['genDet'] = genDet;
    map['empDetails'] = empDetails;
    map['addressDet'] = addressDet;
    map['loanDetails'] = loanDetails;
    if (coApplForm != null) {
      map['coApplDetails'] = coApplForm?.toJson();
    }
    map['fields'] = fields;
    map['lastLoggedInTime'] = lastLoggedInTime;
    map['logCount'] = logCount;
    map['lastUpdatedDate'] = lastUpdatedDate;
    return map;
  }
}
