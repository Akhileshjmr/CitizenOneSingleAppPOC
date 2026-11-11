class AccSpecificRepaymentRequest {
  String? accountNumber;
  double? settledAmt;
  String? paymentMode;
  DateTime? backDate;
  bool isBackDated = false;

  AccSpecificRepaymentRequest({
    this.accountNumber,
    this.settledAmt,
    this.paymentMode,
    this.backDate,
    this.isBackDated = false,
  });

  factory AccSpecificRepaymentRequest.fromJson(Map<String, dynamic> json) {
    return AccSpecificRepaymentRequest(
      accountNumber: json['accountNumber'] as String?,
      settledAmt: (json['settledAmt'] as num?)?.toDouble(),
      paymentMode: json['paymentMode'] as String?,
      backDate: json['backDate'] != null ? DateTime.parse(json['backDate']) : null,
      isBackDated: json['isBackDated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'settledAmt': settledAmt,
      'paymentMode': paymentMode,
      'backDate': backDate?.toIso8601String(),
      'isBackDated': isBackDated,
    };
  }
}
