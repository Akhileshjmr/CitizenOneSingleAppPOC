class CommWalletCharges {
  String chargeCode;
  String chargeDescription;
  String debitAccountNo;
  String creditAccountNo;
  String debitGlAccountNo;
  String creditGlAccountNo;
  String chargeType;
  String eventName;
  double charges;
  double txnFee;

  // Constructor with default values
  CommWalletCharges({
    this.chargeCode = "",
    this.chargeDescription = "",
    this.debitAccountNo = "",
    this.creditAccountNo = "",
    this.debitGlAccountNo = "",
    this.creditGlAccountNo = "",
    this.chargeType = "",
    this.eventName = "",
    this.charges = 0.0,
    this.txnFee = 0.0,
  });

  // Factory method to create an instance from JSON
  factory CommWalletCharges.fromJson(Map<String, dynamic> json) {
    return CommWalletCharges(
      chargeCode: json['charge_code'] ?? "",
      chargeDescription: json['charge_description'] ?? "",
      debitAccountNo: json['debit_account_no'] ?? "",
      creditAccountNo: json['credit_account_no'] ?? "",
      debitGlAccountNo: json['debit_glaccount_no'] ?? "",
      creditGlAccountNo: json['credit_glaccount_no'] ?? "",
      chargeType: json['charge_type'] ?? "",
      eventName: json['event_name'] ?? "",
      charges: (json['charges'] ?? 0.0).toDouble(),
      txnFee: (json['txn_fee'] ?? 0.0).toDouble(),
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'charge_code': chargeCode,
      'charge_description': chargeDescription,
      'debit_account_no': debitAccountNo,
      'credit_account_no': creditAccountNo,
      'debit_glaccount_no': debitGlAccountNo,
      'credit_glaccount_no': creditGlAccountNo,
      'charge_type': chargeType,
      'event_name': eventName,
      'charges': charges,
      'txn_fee': txnFee,
    };
  }
}
