import 'ChMessage.dart';
import 'GenDet.dart';

class PersonalDetailsResp {
  PersonalDetailsResp({
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
      this.fields, 
      this.lastLoggedInTime, 
      this.logCount, 
      this.lastUpdatedDate,});

  PersonalDetailsResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    isExternal = json['isExternal'];
    key = json['key'];
    genDet = json['genDet'] != null ? PersonalDet.fromJson(json['genDet']) : null;
    empDetails = json['empDetails'];
    addressDet = json['addressDet'];
    loanDetails = json['loanDetails'];
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
  PersonalDet? genDet;
  dynamic empDetails;
  dynamic addressDet;
  dynamic loanDetails;
  dynamic fields;
  String? lastLoggedInTime;
  int? logCount;
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
    if (genDet != null) {
      map['genDet'] = genDet?.toJson();
    }
    map['empDetails'] = empDetails;
    map['addressDet'] = addressDet;
    map['loanDetails'] = loanDetails;
    map['fields'] = fields;
    map['lastLoggedInTime'] = lastLoggedInTime;
    map['logCount'] = logCount;
    map['lastUpdatedDate'] = lastUpdatedDate;
    return map;
  }

}