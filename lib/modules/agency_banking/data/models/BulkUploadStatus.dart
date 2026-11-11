class BulkUploadStatus {
  String? batchNo;
  int mobNo = 0;
  String? clientName;
  String? clientId;
  String? custType;
  String? custRole;
  String? txnType;
  String? txnMethod;
  String? daccountNo;
  String? caccountNo;
  double txnAmt = 0.0;
  String? uploadStatus;
  String? regStatus;
  String? messageDesc;

  BulkUploadStatus({
    this.batchNo,
    this.mobNo = 0,
    this.clientName,
    this.clientId,
    this.custType,
    this.custRole,
    this.txnType,
    this.txnMethod,
    this.daccountNo,
    this.caccountNo,
    this.txnAmt = 0.0,
    this.uploadStatus,
    this.regStatus,
    this.messageDesc,
  });

  factory BulkUploadStatus.fromJson(Map<String, dynamic> json) {
    return BulkUploadStatus(
      batchNo: json['batch_no'],
      mobNo: json['mob_no'] ?? 0,
      clientName: json['client_name'],
      clientId: json['client_id'],
      custType: json['cust_type'],
      custRole: json['cust_role'],
      txnType: json['txn_type'],
      txnMethod: json['txn_method'],
      daccountNo: json['daccount_no'],
      caccountNo: json['caccount_no'],
      txnAmt: (json['txn_amt'] ?? 0.0).toDouble(),
      uploadStatus: json['upload_status'],
      regStatus: json['reg_status'],
      messageDesc: json['message_desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batch_no': batchNo,
      'mob_no': mobNo,
      'client_name': clientName,
      'client_id': clientId,
      'cust_type': custType,
      'cust_role': custRole,
      'txn_type': txnType,
      'txn_method': txnMethod,
      'daccount_no': daccountNo,
      'caccount_no': caccountNo,
      'txn_amt': txnAmt,
      'upload_status': uploadStatus,
      'reg_status': regStatus,
      'message_desc': messageDesc,
    };
  }
}