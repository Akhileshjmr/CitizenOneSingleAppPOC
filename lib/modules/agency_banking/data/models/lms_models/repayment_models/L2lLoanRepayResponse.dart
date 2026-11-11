class L2lLoanRepayResponse {
  String? responseCode;
  String? responseType;
  String? custCode;
  String? nationalId;
  String? passportNo;
  String? mobNo;
  String? paymentReffNo;
  String? message;
  String? transactionRef;
  bool? isError;

  L2lLoanRepayResponse({
    this.responseCode,
    this.responseType,
    this.custCode,
    this.nationalId,
    this.passportNo,
    this.mobNo,
    this.paymentReffNo,
    this.message,
    this.transactionRef,
    this.isError,
  });

  factory L2lLoanRepayResponse.fromJson(Map<String, dynamic> json) {
    return L2lLoanRepayResponse(
      responseCode: json['responseCode'],
      responseType: json['responseType'],
      custCode: json['custCode'],
      nationalId: json['nationalId'],
      passportNo: json['passportNo'],
      mobNo: json['mobNo'],
      paymentReffNo: json['paymentReffNo'],
      message: json['message'],
      transactionRef: json['transactionRef'],
      isError: json['isError'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'responseType': responseType,
      'custCode': custCode,
      'nationalId': nationalId,
      'passportNo': passportNo,
      'mobNo': mobNo,
      'paymentReffNo': paymentReffNo,
      'message': message,
      'transactionRef': transactionRef,
      'isError': isError,
    };
  }
}
