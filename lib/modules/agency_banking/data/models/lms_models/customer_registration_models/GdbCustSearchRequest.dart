class GdbCustSearchRequest {
  String? mobileNumber;
  String? custCode;
  String? gdbCustId;

  GdbCustSearchRequest({
    this.mobileNumber,
    this.custCode,
    this.gdbCustId,
  });

  factory GdbCustSearchRequest.fromJson(Map<String, dynamic> json) {
    return GdbCustSearchRequest(
      mobileNumber: json['mobileNumber'],
      custCode: json['custCode'],
      gdbCustId: json['gdbCustId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobileNumber': mobileNumber,
      'custCode': custCode,
      'gdbCustId': gdbCustId,
    };
  }
}
