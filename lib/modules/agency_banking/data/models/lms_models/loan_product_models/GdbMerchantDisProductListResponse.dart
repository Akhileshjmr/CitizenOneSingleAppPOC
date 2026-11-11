import 'GdbVendorProductDetails.dart';

class GdbMerchantDisProductListResponse {
  String? responseCode;
  String? responseDesc;
  List<GdbVendorProductDetails>? productList;

  GdbMerchantDisProductListResponse({
    this.responseCode,
    this.responseDesc,
    this.productList,
  });

  factory GdbMerchantDisProductListResponse.fromJson(Map<String, dynamic> json) {
    return GdbMerchantDisProductListResponse(
      responseCode: json['responseCode'],
      responseDesc: json['responseDesc'],
      productList: (json['productList'] as List<dynamic>?)
          ?.map((e) => GdbVendorProductDetails.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'responseDesc': responseDesc,
      'productList': productList?.map((e) => e.toJson()).toList(),
    };
  }
}
