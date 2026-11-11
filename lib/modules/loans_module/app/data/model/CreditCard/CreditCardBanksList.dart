class CreditCardBanksList {
  CreditCardBanksList({
      this.id, 
      this.bankName, 
      this.bankCode, 
      this.isEnabled,});

  CreditCardBanksList.fromJson(dynamic json) {
    id = json['id'];
    bankName = json['bankName'];
    bankCode = json['bankCode'];
    isEnabled = json['isEnabled'];
  }
  int? id;
  String? bankName;
  String? bankCode;
  bool? isEnabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['bankName'] = bankName;
    map['bankCode'] = bankCode;
    map['isEnabled'] = isEnabled;
    return map;
  }

}