class L2lLoanRepayRequest {
  String? userName;
  String? custCode;
  String? mobNo;
  String? nationalId;
  String? passportNo;
  double? paidAmt;
  String? transactionRef;
  String? paymentMode;
  String? clientName;
  String? glId;
  double? payFee;

  L2lLoanRepayRequest({
    this.userName,
    this.custCode,
    this.mobNo,
    this.nationalId,
    this.passportNo,
    this.paidAmt,
    this.transactionRef,
    this.paymentMode,
    this.clientName,
    this.glId,
    this.payFee,
  });

  factory L2lLoanRepayRequest.fromJson(Map<String, dynamic> json) {
    return L2lLoanRepayRequest(
      userName: json['userName'],
      custCode: json['custCode'],
      mobNo: json['mobNo'],
      nationalId: json['nationalId'],
      passportNo: json['passportNo'],
      paidAmt: (json['paidAmt'] as num?)?.toDouble(),
      transactionRef: json['transactionRef'],
      paymentMode: json['paymentMode'],
      clientName: json['clientName'],
      glId: json['glId'],
      payFee: (json['payFee'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'custCode': custCode,
      'mobNo': mobNo,
      'nationalId': nationalId,
      'passportNo': passportNo,
      'paidAmt': paidAmt,
      'transactionRef': transactionRef,
      'paymentMode': paymentMode,
      'clientName': clientName,
      'glId': glId,
      'payFee': payFee,
    };
  }
}
