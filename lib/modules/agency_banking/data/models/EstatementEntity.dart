class EstatementEntity {
  double? dAmount;
  double? dCharges;
  double? dTax;
  double? cAmount;
  String? dAccountNo;
  String? cAccountNo;
  String? dMobileNo;
  String? cMobileNo;
  String? dTxnCcy;
  String? cTxnCcy;
  String? dBranchCode;
  String? cBranchCode;
  String? dCustomerName;
  String? cCustomerName;
  int? txtnDate;
  String? moduleType;
  String? txnId;
  String? cbsTxnId;
  String? txnStatus;
  String? bankCode;
  String? bankName;
  String? bankLogo;
  String? drCr;
  double? balance;
  String? txnReason;
  String? txnBank;
  int? txnDate;

  // Constructor
  EstatementEntity({
    this.dAmount,
    this.dCharges,
    this.dTax,
    this.cAmount,
    this.dAccountNo,
    this.cAccountNo,
    this.dMobileNo,
    this.cMobileNo,
    this.dTxnCcy,
    this.cTxnCcy,
    this.dBranchCode,
    this.cBranchCode,
    this.dCustomerName,
    this.cCustomerName,
    this.txtnDate,
    this.moduleType,
    this.txnId,
    this.cbsTxnId,
    this.txnStatus,
    this.bankCode,
    this.bankName,
    this.bankLogo,
    this.drCr,
    this.balance,
    this.txnReason,
    this.txnBank,
    this.txnDate,
  });

  // Factory method to create an instance from JSON
  factory EstatementEntity.fromJson(Map<String, dynamic> json) {
    return EstatementEntity(
      dAmount: (json['dAmount'] as num?)?.toDouble(),
      dCharges: (json['dCharges'] as num?)?.toDouble(),
      dTax: (json['dTax'] as num?)?.toDouble(),
      cAmount: (json['cAmount'] as num?)?.toDouble(),
      dAccountNo: json['dAccountNo'] as String?,
      cAccountNo: json['cAccountNo'] as String?,
      dMobileNo: json['dMobileNo']?.toString(),
      cMobileNo: json['cMobileNo']?.toString(),
      dTxnCcy: json['dTxnCcy'] as String?,
      cTxnCcy: json['cTxnCcy'] as String?,
      dBranchCode: json['dBranchCode'] as String?,
      cBranchCode: json['cBranchCode'] as String?,
      dCustomerName: json['dCustomerName'] as String?,
      cCustomerName: json['cCustomerName'] as String?,
      txtnDate: json['txtnDate'] as int?,
      moduleType: json['moduleType'] as String?,
      txnId: json['txnId'] as String?,
      cbsTxnId: json['cbsTxnId'] as String?,
      txnStatus: json['txnStatus'] as String?,
      bankCode: json['bankCode'] as String?,
      bankName: json['bankName'] as String?,
      bankLogo: json['bankLogo'] as String?,
      drCr: json['drCr'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      txnReason: json['txnReason'] as String?,
      txnBank: json['txnBank'] as String?,
      txnDate: json['txnDate'] as int?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'dAmount': dAmount,
      'dCharges': dCharges,
      'dTax': dTax,
      'cAmount': cAmount,
      'dAccountNo': dAccountNo,
      'cAccountNo': cAccountNo,
      'dMobileNo': dMobileNo,
      'cMobileNo': cMobileNo,
      'dTxnCcy': dTxnCcy,
      'cTxnCcy': cTxnCcy,
      'dBranchCode': dBranchCode,
      'cBranchCode': cBranchCode,
      'dCustomerName': dCustomerName,
      'cCustomerName': cCustomerName,
      'txtnDate': txtnDate,
      'moduleType': moduleType,
      'txnId': txnId,
      'cbsTxnId': cbsTxnId,
      'txnStatus': txnStatus,
      'bankCode': bankCode,
      'bankName': bankName,
      'bankLogo': bankLogo,
      'drCr': drCr,
      'balance': balance,
      'txnReason': txnReason,
      'txnBank': txnBank,
      'txnDate': txnDate,
    };
  }
}
