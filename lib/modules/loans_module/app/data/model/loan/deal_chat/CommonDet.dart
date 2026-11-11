class CommonDet {
  String? cUSTOMERNAME;
  String? mOBILENUMBER;
  String? eMAIL;

  CommonDet({this.cUSTOMERNAME, this.mOBILENUMBER, this.eMAIL});

  CommonDet.fromJson(Map<String, dynamic> json) {
    cUSTOMERNAME = json['CUSTOMER_NAME'];
    mOBILENUMBER = json['MOBILE_NUMBER'];
    eMAIL = json['EMAIL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CUSTOMER_NAME'] = this.cUSTOMERNAME;
    data['MOBILE_NUMBER'] = this.mOBILENUMBER;
    data['EMAIL'] = this.eMAIL;
    return data;
  }
}