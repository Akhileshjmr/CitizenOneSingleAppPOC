import '../../common/ch_message.dart';
import 'EmpDetails.dart';

class PlSubmitResp {
  PlSubmitResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.loanDetails,
    this.personalDetails,
    this.contactDetails,
    this.empDetails,
    this.incomeDetails,
  });

  PlSubmitResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    loanDetails =
        json['loanDetails'] != null
            ? EmpDetails.fromJson(json['loanDetails'])
            : null;
    personalDetails =
        json['personalDetails'] != null
            ? EmpDetails.fromJson(json['personalDetails'])
            : null;
    contactDetails =
        json['contactDetails'] != null
            ? EmpDetails.fromJson(json['contactDetails'])
            : null;
    empDetails =
        json['empDetails'] != null
            ? EmpDetails.fromJson(json['empDetails'])
            : null;
    incomeDetails =
        json['incomeDetails'] != null
            ? EmpDetails.fromJson(json['incomeDetails'])
            : null;
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  EmpDetails? loanDetails;
  EmpDetails? personalDetails;
  EmpDetails? contactDetails;
  EmpDetails? empDetails;
  EmpDetails? incomeDetails;

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
    if (loanDetails != null) {
      map['loanDetails'] = loanDetails?.toJson();
    }
    if (personalDetails != null) {
      map['personalDetails'] = personalDetails?.toJson();
    }
    if (contactDetails != null) {
      map['contactDetails'] = contactDetails?.toJson();
    }
    if (empDetails != null) {
      map['empDetails'] = empDetails?.toJson();
    }
    if (incomeDetails != null) {
      map['incomeDetails'] = incomeDetails?.toJson();
    }
    return map;
  }
}
