class ProductDetails {
  ProductDetails({
      this.productCode, 
      this.bankLogo, 
      this.bankName,});

  ProductDetails.fromJson(dynamic json) {
    productCode = json['productCode'];
    bankLogo = json['bankLogo'];
    bankName = json['bankName'];
  }
  String? productCode;
  String? bankLogo;
  String? bankName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productCode'] = productCode;
    map['bankLogo'] = bankLogo;
    map['bankName'] = bankName;
    return map;
  }

}