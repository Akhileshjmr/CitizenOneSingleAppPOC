import '../../common/ch_message.dart';
import 'Order.dart';

class AutoLoanHistoryResp {
  AutoLoanHistoryResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.order,
  });

  AutoLoanHistoryResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    if (json['order'] != null) {
      order = [];
      json['order'].forEach((v) {
        order?.add(Order.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  List<Order>? order;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    if (order != null) {
      map['order'] = order?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
