import '../common/ch_message.dart';
import '../view_bids/one_advertise_history.dart';

class BidPlanResponse {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  List<BidPlan>? bidplanList;

  BidPlanResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.bidplanList,
  });

  BidPlanResponse.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];

    if (json['bidplanList'] != null) {
      bidplanList = <BidPlan>[];
      json['bidplanList'].forEach((v) {
        bidplanList!.add(BidPlan.fromJson(v));
      });
    }
  }
}

class BidPlanItem {
  final String? adId;
  final String? bidId;
  final String? cropName;
  final String? minPrice;
  final String? totalQuantity;
  final String? totalPrice;
  final Status? status;

  BidPlanItem({
    this.adId,
    this.bidId,
    this.cropName,
    this.minPrice,
    this.totalQuantity,
    this.totalPrice,
    this.status,
  });

  factory BidPlanItem.fromJson(Map<String, dynamic> json) {
    return BidPlanItem(
      adId: json['adId'],
      bidId: json['bidId'],
      cropName: json['cropName'],
      minPrice: json['minPrice'],
      totalQuantity: json['totalQuantity'],
      totalPrice: json['totalPrice'],
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
    );
  }
}

class Status {
  final String? type;
  final String? friendlyType;

  Status({this.type, this.friendlyType});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(type: json['type'], friendlyType: json['friendlyType']);
  }
}
