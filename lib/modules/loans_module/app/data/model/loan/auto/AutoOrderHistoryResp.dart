import '../../../../modules/profile/ProfileStatusResp.dart';
import 'Orders.dart';

class AutoOrderHistoryResp {
  AutoOrderHistoryResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.orders,
    this.order,
    this.event,
  });

  AutoOrderHistoryResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(Orders.fromJson(v));
      });
    }
    order = json['order'];
    event = json['event'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  List<Orders?>? orders;
  dynamic order;
  dynamic event;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    if (orders != null) {
      map['orders'] = orders?.map((v) => v?.toJson()).toList();
    }
    map['order'] = order;
    map['event'] = event;
    return map;
  }
}
