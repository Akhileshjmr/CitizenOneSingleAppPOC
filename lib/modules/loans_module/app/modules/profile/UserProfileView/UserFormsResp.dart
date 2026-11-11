
// import '../../../model/ChMessage.dart';

import 'package:citizenone_app/modules/loans_module/app/data/model/common/ch_message.dart';

import 'GenDet.dart';

class UserFormsResp {
  UserFormsResp({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value, 
      this.key, 
      this.genDet, 
      this.empDetails, 
      this.addressDet, 
      this.loanDetails, 
      this.fields,});

  UserFormsResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    key = json['key'];
    genDet = json['genDet'] != null ? GenDet.fromJson(json['genDet']) : null;
    empDetails = json['empDetails'];
    addressDet = json['addressDet'];
    loanDetails = json['loanDetails'];
    fields = json['fields'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  String? key;
  GenDet? genDet;
  dynamic empDetails;
  dynamic addressDet;
  dynamic loanDetails;
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
    map['key'] = key;
    if (genDet != null) {
      map['genDet'] = genDet?.toJson();
    }
    map['empDetails'] = empDetails;
    map['addressDet'] = addressDet;
    map['loanDetails'] = loanDetails;
    map['fields'] = fields;
    return map;
  }

}