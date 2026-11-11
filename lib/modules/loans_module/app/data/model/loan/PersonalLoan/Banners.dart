class Banners {
  Banners({
      this.key, 
      this.imageUrl, 
      this.targetUrl, 
      this.targetType, 
      this.productDetails, 
      this.vendorDetails, 
      this.categoryDetails,});

  Banners.fromJson(dynamic json) {
    key = json['key'];
    imageUrl = json['imageUrl'];
    targetUrl = json['targetUrl'];
    targetType = json['targetType'];
    productDetails = json['productDetails'];
    vendorDetails = json['vendorDetails'];
    categoryDetails = json['categoryDetails'];
  }
  dynamic key;
  String? imageUrl;
  dynamic targetUrl;
  dynamic targetType;
  dynamic productDetails;
  dynamic vendorDetails;
  dynamic categoryDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['imageUrl'] = imageUrl;
    map['targetUrl'] = targetUrl;
    map['targetType'] = targetType;
    map['productDetails'] = productDetails;
    map['vendorDetails'] = vendorDetails;
    map['categoryDetails'] = categoryDetails;
    return map;
  }

}