import '../../common/ch_message.dart';
import 'Documents.dart';

class UserDocumentsResp {
  UserDocumentsResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.documents,
  });

  UserDocumentsResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    if (json['documents'] != null) {
      documents = [];
      json['documents'].forEach((v) {
        documents?.add(Documents.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  List<Documents>? documents;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    if (documents != null) {
      map['documents'] = documents?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
