class EmiInfoDetails {
  EmiInfoDetails({
      this.refNum, 
      this.totalAmount, 
      this.tenure, 
      this.interestRate, 
      this.emiAmount, 
      this.downPayment, 
      this.bankName, 
      this.loanAmount, 
      this.totalAmtToBePaid,});

  EmiInfoDetails.fromJson(dynamic json) {
    refNum = json['refNum'];
    totalAmount = json['totalAmount'];
    tenure = json['tenure'];
    interestRate = json['interestRate'];
    emiAmount = json['emiAmount'];
    downPayment = json['downPayment'];
    bankName = json['bankName'];
    loanAmount = json['loanAmount'];
    totalAmtToBePaid = json['totalAmtToBePaid'];
  }
  String? refNum;
  String? totalAmount;
  String? tenure;
  String? interestRate;
  String? emiAmount;
  String? downPayment;
  String? bankName;
  String? loanAmount;
  String? totalAmtToBePaid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refNum'] = refNum;
    map['totalAmount'] = totalAmount;
    map['tenure'] = tenure;
    map['interestRate'] = interestRate;
    map['emiAmount'] = emiAmount;
    map['downPayment'] = downPayment;
    map['bankName'] = bankName;
    map['loanAmount'] = loanAmount;
    map['totalAmtToBePaid'] = totalAmtToBePaid;
    return map;
  }

}