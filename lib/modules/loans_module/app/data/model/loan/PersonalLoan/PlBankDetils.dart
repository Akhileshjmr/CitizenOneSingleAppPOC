class PlBankDetils {
  PlBankDetils({
      this.bankId, 
      this.productCode, 
      this.bankLogo, 
      this.bankName,
      this.minimumSalary, 
      this.maxLoanAmount, 
      this.flatRate, 
      this.salaryTransfer, 
      this.maxTenure, 
      this.minTenure, 
      this.loanType,
    this.isSelected = false});

  PlBankDetils.fromJson(dynamic json) {
    bankId = json['bankId'];
    productCode = json['productCode'];
    bankLogo = json['bankLogo'];
    bankName = json['bankName'];
    minimumSalary = json['minimumSalary'];
    maxLoanAmount = json['maxLoanAmount'];
    flatRate = json['flatRate'];
    salaryTransfer = json['salaryTransfer'];
    maxTenure = json['maxTenure'];
    minTenure = json['minTenure'];
    loanType = json['loanType'];
    isSelected = false;
  }
  int? bankId;
  String? productCode;
  String? bankLogo;
  String? bankName;
  String? minimumSalary;
  String? maxLoanAmount;
  String? flatRate;
  bool? salaryTransfer;
  int? maxTenure;
  int? minTenure;
  String? loanType;
  bool isSelected = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bankId'] = bankId;
    map['productCode'] = productCode;
    map['bankLogo'] = bankLogo;
    map['bankName'] = bankName;
    map['minimumSalary'] = minimumSalary;
    map['maxLoanAmount'] = maxLoanAmount;
    map['flatRate'] = flatRate;
    map['salaryTransfer'] = salaryTransfer;
    map['maxTenure'] = maxTenure;
    map['minTenure'] = minTenure;
    map['loanType'] = loanType;
    return map;
  }

}