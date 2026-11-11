import 'CustomerDet.dart';
import 'AppStatus.dart';
import 'Message.dart';

class PrFormResp {
  PrFormResp({
      this.gdbCustId, 
      this.customerDet, 
      this.appStatus, 
      this.overAllStatus, 
      this.isBanked, 
      this.appRefNumber, 
      this.initLimitVal, 
      this.reqSecureKey, 
      this.docNamesList, 
      this.message,});

  PrFormResp.fromJson(dynamic json) {
    gdbCustId = json['gdbCustId'];
    customerDet = json['customerDet'] != null ? CustomerDet.fromJson(json['customerDet']) : null;
    appStatus = json['appStatus'] != null ? AppStatus.fromJson(json['appStatus']) : null;
    overAllStatus = json['overAllStatus'];
    isBanked = json['isBanked'];
    appRefNumber = json['appRefNumber'];
    initLimitVal = json['initLimitVal'];
    reqSecureKey = json['reqSecureKey'];
    docNamesList = json['docNamesList'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }
  dynamic gdbCustId;
  CustomerDet? customerDet;
  AppStatus? appStatus;
  dynamic overAllStatus;
  dynamic isBanked;
  String? appRefNumber;
  dynamic initLimitVal;
  dynamic reqSecureKey;
  dynamic docNamesList;
  Message? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gdbCustId'] = gdbCustId;
    if (customerDet != null) {
      map['customerDet'] = customerDet?.toJson();
    }
    if (appStatus != null) {
      map['appStatus'] = appStatus?.toJson();
    }
    map['overAllStatus'] = overAllStatus;
    map['isBanked'] = isBanked;
    map['appRefNumber'] = appRefNumber;
    map['initLimitVal'] = initLimitVal;
    map['reqSecureKey'] = reqSecureKey;
    map['docNamesList'] = docNamesList;
    if (message != null) {
      map['message'] = message?.toJson();
    }
    return map;
  }

}