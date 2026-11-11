class GdbMerchantDisProductListRequest {
  String? vendorId;
  String? productGroupName;

  GdbMerchantDisProductListRequest({this.vendorId, this.productGroupName});

  factory GdbMerchantDisProductListRequest.fromJson(Map<String, dynamic> json) {
    return GdbMerchantDisProductListRequest(
      vendorId: json['vendorId'],
      productGroupName: json['productGroupName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'productGroupName': productGroupName,
    };
  }
}
