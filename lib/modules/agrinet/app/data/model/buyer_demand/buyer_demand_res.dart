import 'buyer_demand_item.dart';

class BuyerDemandResponse {
  List<BuyerDemandItem> items;

  BuyerDemandResponse({required this.items});

  factory BuyerDemandResponse.fromJson(Map<String, dynamic> json) {
    final list = (json["buyerComdities"] as List?) ?? [];

    return BuyerDemandResponse(
      items: list.map((e) => BuyerDemandItem.fromJson(e)).toList(),
    );
  }
}
