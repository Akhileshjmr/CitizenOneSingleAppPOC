import '../common/ch_message.dart';

class ChatResponse {
  String? reqSecureKey;
  String? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic id;
  dynamic palImage;
  dynamic buyerImage;
  dynamic status;
  List<Chat>? chats;
  dynamic adId;
  dynamic bidId;

  ChatResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.id,
    this.palImage,
    this.buyerImage,
    this.status,
    this.chats,
    this.adId,
    this.bidId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      id: json['id'],
      palImage: json['pal_Image'],
      buyerImage: json['buyer_Image'],
      status: json['status'],
      chats:
          json['chats'] != null
              ? List<Chat>.from(json['chats'].map((x) => Chat.fromJson(x)))
              : [],
      adId: json['adId'],
      bidId: json['bidId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "reqSecureKey": reqSecureKey,
    "addiParams": addiParams,
    "chMessage": chMessage?.toJson(),
    "urlDecision": urlDecision,
    "id": id,
    "pal_Image": palImage,
    "buyer_Image": buyerImage,
    "status": status,
    "chats": chats?.map((x) => x.toJson()).toList(),
    "adId": adId,
    "bidId": bidId,
  };
}

class Chat {
  String? msg;
  String? msgOn;
  String? msgBy;
  String? msgByType;

  Chat({this.msg, this.msgOn, this.msgBy, this.msgByType});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    msg: json['msg'],
    msgOn: json['msgOn'],
    msgBy: json['msgBy'],
    msgByType: json['msgByType'],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "msgOn": msgOn,
    "msgBy": msgBy,
    "msgByType": msgByType,
  };
}
