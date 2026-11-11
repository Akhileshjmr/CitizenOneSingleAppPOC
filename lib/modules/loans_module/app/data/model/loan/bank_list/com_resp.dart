import '../../common/ch_message.dart';

class ComResp {
  ComResp({this.reqSecureKey, this.addiParams, this.chMessage});

  ComResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
  }
  String? reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    return map;
  }
}
