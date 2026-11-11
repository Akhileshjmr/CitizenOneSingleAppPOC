import 'ChatMsgs.dart';
import 'ComResp.dart';

class PlChatModel {
  PlChatModel({
      this.chatMsgs, 
      this.comResp, 
      this.removeUnReadMsgsFlag,});

  PlChatModel.fromJson(dynamic json) {
    if (json['chatMsgs'] != null) {
      chatMsgs = [];
      json['chatMsgs'].forEach((v) {
        chatMsgs?.add(ChatMsgs.fromJson(v));
      });
    }
    comResp = json['comResp'] != null ? ComResp.fromJson(json['comResp']) : null;
    removeUnReadMsgsFlag = json['removeUnReadMsgsFlag'];
  }
  List<ChatMsgs>? chatMsgs;
  ComResp? comResp;
  bool? removeUnReadMsgsFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (chatMsgs != null) {
      map['chatMsgs'] = chatMsgs?.map((v) => v.toJson()).toList();
    }
    if (comResp != null) {
      map['comResp'] = comResp?.toJson();
    }
    map['removeUnReadMsgsFlag'] = removeUnReadMsgsFlag;
    return map;
  }

}