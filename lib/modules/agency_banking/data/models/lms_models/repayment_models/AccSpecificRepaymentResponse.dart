class AccSpecificRepaymentResponse {
  String? responseCode;
  String? responseMessage;
  String? repaymentId;
  double? settledAmt;

  AccSpecificRepaymentResponse({
    this.responseCode,
    this.responseMessage,
    this.repaymentId,
    this.settledAmt,
  });

  factory AccSpecificRepaymentResponse.fromJson(Map<String, dynamic> json) {
    return AccSpecificRepaymentResponse(
      responseCode: json['responseCode'] as String?,
      responseMessage: json['responseMessage'] as String?,
      repaymentId: json['repaymentId'] as String?,
      settledAmt: (json['settledAmt'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'repaymentId': repaymentId,
      'settledAmt': settledAmt,
    };
  }
}
