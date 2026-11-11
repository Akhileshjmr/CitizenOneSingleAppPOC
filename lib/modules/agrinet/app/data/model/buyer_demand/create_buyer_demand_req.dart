class CreateBuyerDemandReq {
  String filterVal;
  String cropName;
  String desc;
  double pricePerKg;
  int requestedOn;
  int totalQuantity;

  CreateBuyerDemandReq({
    required this.filterVal,
    required this.cropName,
    required this.desc,
    required this.pricePerKg,
    required this.requestedOn,
    required this.totalQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "filterVal": filterVal,
      "cropName": cropName,
      "desc": desc,
      "pricePerKg": pricePerKg,
      "requestedOn": requestedOn,
      "totalQuantity": totalQuantity,
    };
  }
}
