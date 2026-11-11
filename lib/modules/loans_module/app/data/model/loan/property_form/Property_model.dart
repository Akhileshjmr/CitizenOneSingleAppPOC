import '../../common/ch_message.dart';
import 'OrderView.dart';

class PropertyModel {
  PropertyModel({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.filterVal,
    this.orderView,
  });

  PropertyModel.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    filterVal = json['filterVal'];
    orderView =
        json['orderView'] != null
            ? OrderView.fromJson(json['orderView'])
            : null;
  }
  String? reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  String? urlDecision;
  String? value;
  String? filterVal;
  OrderView? orderView;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['filterVal'] = filterVal;
    if (orderView != null) {
      map['orderView'] = orderView?.toJson();
    }
    return map;
  }
}
