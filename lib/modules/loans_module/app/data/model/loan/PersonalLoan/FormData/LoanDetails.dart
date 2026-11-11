class LoanDetails {
  LoanDetails({
      this.monthlyIncome, 
      this.otherIncome, 
      this.allowances, 
      this.deductions, 
      this.lastUpdatedDate, 
      this.purposeOfLoan, 
      this.tenure, 
      this.loanAmount,});

  LoanDetails.fromJson(dynamic json) {
    monthlyIncome = json['monthlyIncome'];
    otherIncome = json['otherIncome'];
    allowances = json['allowances'];
    deductions = json['deductions'];
    lastUpdatedDate = json['lastUpdatedDate'];
    purposeOfLoan = json['purposeOfLoan'];
    tenure = json['tenure'];
    loanAmount = json['loanAmount'];
  }
  dynamic monthlyIncome;
  dynamic otherIncome;
  dynamic allowances;
  dynamic deductions;
  dynamic lastUpdatedDate;
  String? purposeOfLoan;
  int? tenure;
  double? loanAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['monthlyIncome'] = monthlyIncome;
    map['otherIncome'] = otherIncome;
    map['allowances'] = allowances;
    map['deductions'] = deductions;
    map['lastUpdatedDate'] = lastUpdatedDate;
    map['purposeOfLoan'] = purposeOfLoan;
    map['tenure'] = tenure;
    map['loanAmount'] = loanAmount;
    return map;
  }

}