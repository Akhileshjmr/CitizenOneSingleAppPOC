class GdbMerchantDisProductPurList {
  String? loanNumber;
  double? dueAmount;
  String? firstEmiDueDate;
  double? adminFees;
  int? tenure;
  double? emi;
  double? downPayment;
  double? pricing;
  double? discount;
  String? transactionId;
  String? orderId;
  String? productId;
  double? productPrice;

  GdbMerchantDisProductPurList({
    this.loanNumber,
    this.dueAmount,
    this.firstEmiDueDate,
    this.adminFees,
    this.tenure,
    this.emi,
    this.downPayment,
    this.pricing,
    this.discount,
    this.transactionId,
    this.orderId,
    this.productId,
    this.productPrice,
  });

  factory GdbMerchantDisProductPurList.fromJson(Map<String, dynamic> json) {
    return GdbMerchantDisProductPurList(
      loanNumber: json['loanNumber'],
      dueAmount: (json['dueAmount'] as num?)?.toDouble(),
      firstEmiDueDate: json['firstEmiDueDate'],
      adminFees: (json['adminFees'] as num?)?.toDouble(),
      tenure: json['tenure'],
      emi: (json['emi'] as num?)?.toDouble(),
      downPayment: (json['downPayment'] as num?)?.toDouble(),
      pricing: (json['pricing'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      transactionId: json['transactionId'],
      orderId: json['orderId'],
      productId: json['productId'],
      productPrice: (json['productPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanNumber': loanNumber,
      'dueAmount': dueAmount,
      'firstEmiDueDate': firstEmiDueDate,
      'adminFees': adminFees,
      'tenure': tenure,
      'emi': emi,
      'downPayment': downPayment,
      'pricing': pricing,
      'discount': discount,
      'transactionId': transactionId,
      'orderId': orderId,
      'productId': productId,
      'productPrice': productPrice,
    };
  }
}
