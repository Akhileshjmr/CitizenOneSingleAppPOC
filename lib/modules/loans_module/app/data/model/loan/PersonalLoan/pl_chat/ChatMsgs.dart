import 'UrlAction.dart';
import 'Doc.dart';

class ChatMsgs {
  ChatMsgs({
      this.reqSecureKey, 
      this.filterVal, 
      this.addiParams, 
      this.hKey, 
      this.filterHashKey, 
      this.msg, 
      this.msgOn, 
      this.msgBy, 
      this.msgByType, 
      this.msgType, 
      this.custLogo, 
      this.extn,
      this.storage,
      this.urlAction,
      this.doc,
    this.imgUrl,
    this.name,
  });

  ChatMsgs.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    filterVal = json['filterVal'];
    addiParams = json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    hKey = json['hKey'];
    filterHashKey = json['filterHashKey'];
    msg = json['msg'];
    msgOn = json['msgOn'];
    msgBy = json['msgBy'];
    msgByType = json['msgByType'];
    msgType = json['msgType'];
    custLogo = json['custLogo'];
    extn = json['extn'];
    storage = json['storage'];
    urlAction = json['urlAction'] != null ? UrlAction.fromJson(json['urlAction']) : null;
    doc = json['doc'] != null ? Doc.fromJson(json['doc']) : null;
    imgUrl = json['imgUrl'];
    name = json['name'];
  }
  String? reqSecureKey;
  String? filterVal;
  List<String>? addiParams;
  String? hKey;
  String? filterHashKey;
  String? msg;
  String? msgOn;
  String? msgBy;
  String? msgByType;
  String? msgType;
  String? custLogo;
  UrlAction? urlAction;
  Doc? doc;
  String? storage;
  String? extn;
  String? imgUrl;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['filterVal'] = filterVal;
    map['addiParams'] = addiParams;
    map['hKey'] = hKey;
    map['filterHashKey'] = filterHashKey;
    map['msg'] = msg;
    map['msgOn'] = msgOn;
    map['msgBy'] = msgBy;
    map['msgByType'] = msgByType;
    map['msgType'] = msgType;
    map['storage'] = storage;
    map['storage'] = storage;
    map['extn'] = extn;
    if (urlAction != null) {
      map['urlAction'] = urlAction?.toJson();
    }
    if (doc != null) {
      map['doc'] = doc?.toJson();
    }
    map['imgUrl'] = imgUrl;
    map['name'] = name;
    return map;
  }

}