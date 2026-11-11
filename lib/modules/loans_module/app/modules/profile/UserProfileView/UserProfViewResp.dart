


import 'package:citizenone_app/modules/loans_module/app/data/model/common/ch_message.dart';

class UserProfViewResp {
  UserProfViewResp({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value, 
      this.docName, 
      this.docType, 
      this.file, 
      this.docId,});

  UserProfViewResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    docName = json['docName'];
    docType = json['docType'];
    file = json['file'];
    docId = json['docId'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic docName;
  dynamic docType;
  String? file;
  dynamic docId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['docName'] = docName;
    map['docType'] = docType;
    map['file'] = file;
    map['docId'] = docId;
    return map;
  }

}