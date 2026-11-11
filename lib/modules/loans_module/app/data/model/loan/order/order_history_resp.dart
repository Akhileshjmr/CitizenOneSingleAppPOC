import '../../../../modules/profile/ProfileStatusResp.dart';
import '../../credeze_com_resp.dart';
import '../bank_list/paging.dart';
import '../paging_req.dart';
import 'order_basic_resp.dart';

class OrderHistoryResp {
  List<OrderBasicResp>? orders;
  CredezeCommonResp? comResp;
  PagingReq? paging;

  OrderHistoryResp({this.orders, this.comResp, this.paging});

  @override
  String toString() {
    return 'OrderHistoryResp{orders: $orders, comResp: $comResp, paging: $paging}';
  }

  OrderHistoryResp.fromJson(Map<String, dynamic> json) {
    orders =
        json["orders"] == null
            ? null
            : List<OrderBasicResp>.from(
              json["orders"]?.map((x) => OrderBasicResp.fromJson(x)),
            );
    comResp =
        json['comResp'] != null
            ? CredezeCommonResp.fromJson(json['comResp'])
            : null;
    paging = json['paging'] != null ? PagingReq.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v?.toJson()).toList();
    }
    if (comResp != null) {
      data['comResp'] = comResp!.toJson();
    }
    if (paging != null) {
      data['paging'] = paging!.toJson();
    }

    return data;
  }
}

class OrderHistoryList {
  final dynamic reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final dynamic value;
  final List<OrderInfo>? orders;
  final dynamic order;
  final Paging? paging;

  OrderHistoryList({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.orders,
    this.order,
    this.paging,
  });

  factory OrderHistoryList.fromJson(Map<String, dynamic> json) =>
      OrderHistoryList(
        reqSecureKey: json["reqSecureKey"],
        addiParams: json["addiParams"],
        chMessage:
            json["chMessage"] == null
                ? null
                : ChMessage.fromJson(json["chMessage"]),
        urlDecision: json["urlDecision"],
        value: json["value"],
        orders:
            json["orders"] == null
                ? []
                : List<OrderInfo>.from(
                  json["orders"]!.map((x) => OrderInfo.fromJson(x)),
                ),
        order: json["order"],
        paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
      );

  Map<String, dynamic> toJson() => {
    "reqSecureKey": reqSecureKey,
    "addiParams": addiParams,
    "chMessage": chMessage?.toJson(),
    "urlDecision": urlDecision,
    "value": value,
    "orders":
        orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
    "order": order,
    "paging": paging?.toJson(),
  };
}
