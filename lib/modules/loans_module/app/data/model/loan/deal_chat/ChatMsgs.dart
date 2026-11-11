import 'ComReq.dart';
import 'UrlAction.dart';

class ChatMsgs {
  ChatMsgs({
      this.comReq, 
      this.msg, 
      this.msgOn, 
      this.msgBy, 
      this.msgByType, 
      this.custLogo, 
      this.urlAction,});

  ChatMsgs.fromJson(dynamic json) {
    comReq = json['comReq'] != null ? ComReq.fromJson(json['comReq']) : null;
    msg = json['msg'];
    msgOn = json['msgOn'];
    msgBy = json['msgBy'];
    msgByType = json['msgByType'];
    custLogo = json['custLogo'];
    urlAction = json['urlAction'] != null ? UrlAction.fromJson(json['urlAction']) : null;
  }
  ComReq? comReq;
  String? msg;
  String? msgOn;
  dynamic msgBy;
  String? msgByType;
  dynamic custLogo;
  UrlAction? urlAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (comReq != null) {
      map['comReq'] = comReq?.toJson();
    }
    map['msg'] = msg;
    map['msgOn'] = msgOn;
    map['msgBy'] = msgBy;
    map['msgByType'] = msgByType;
    map['custLogo'] = custLogo;
    if (urlAction != null) {
      map['urlAction'] = urlAction?.toJson();
    }
    return map;
  }

}