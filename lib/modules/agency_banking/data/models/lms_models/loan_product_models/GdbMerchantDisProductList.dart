class GdbMerchantDisProductList {
  String? productId;
  double? productPrice;
  String? orderId;
  double? pricing;
  double? adminFees;
  int? discountType;
  double? discount;
  int expenseType = 0;
  double expense = 0.0;
  int? tenure;
  double? downPayment;

  GdbMerchantDisProductList();

  factory GdbMerchantDisProductList.fromJson(Map<String, dynamic> json) {
    return GdbMerchantDisProductList()
      ..productId = json['productId']
      ..productPrice = (json['productPrice'] as num?)?.toDouble()
      ..orderId = json['orderId']
      ..pricing = (json['pricing'] as num?)?.toDouble()
      ..adminFees = (json['adminFees'] as num?)?.toDouble()
      ..discountType = json['discountType']
      ..discount = (json['discount'] as num?)?.toDouble()
      ..expenseType = json['expenseType'] ?? 0
      ..expense = (json['expense'] as num?)?.toDouble() ?? 0.0
      ..tenure = json['tenure']
      ..downPayment = (json['downPayment'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productPrice': productPrice,
      'orderId': orderId,
      'pricing': pricing,
      'adminFees': adminFees,
      'discountType': discountType,
      'discount': discount,
      'expenseType': expenseType,
      'expense': expense,
      'tenure': tenure,
      'downPayment': downPayment,
    };
  }
}
