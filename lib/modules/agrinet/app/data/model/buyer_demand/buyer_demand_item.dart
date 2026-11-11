class BuyerDemandItem {
  final int buyerCommodityId;
  final String cropName;
  final double pricePerKg;
  final int totalQuantity;
  final int requestedOn;
  final String buyerStatus;
  final String? desc;

  BuyerDemandItem({
    required this.buyerCommodityId,
    required this.cropName,
    required this.pricePerKg,
    required this.totalQuantity,
    required this.requestedOn,
    required this.buyerStatus,
    this.desc,
  });

  factory BuyerDemandItem.fromJson(Map<String, dynamic> json) {
    return BuyerDemandItem(
      buyerCommodityId: json["buyerComdityId"],
      cropName: json["cropName"] ?? "",
      pricePerKg: (json["pricePerKg"] ?? 0).toDouble(),
      totalQuantity: json["totalQuantity"] ?? 0,
      requestedOn: json["requestedOn"] ?? 0,
      buyerStatus: json["buyerStatus"] ?? "",
      desc: json["desc"],
    );
  }
}
