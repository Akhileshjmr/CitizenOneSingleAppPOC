class FeesAndCharges {
  FeesAndCharges({
      this.feesChargeName, 
      this.amount, 
      this.appliedCharge, 
      this.isExcluded,});

  FeesAndCharges.fromJson(dynamic json) {
    feesChargeName = json['feesChargeName'];
    amount = json['amount'];
    appliedCharge = json['appliedCharge'];
    isExcluded = json['isExcluded'];
  }
  String? feesChargeName;
  dynamic amount;
  String? appliedCharge;
  dynamic isExcluded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feesChargeName'] = feesChargeName;
    map['amount'] = amount;
    map['appliedCharge'] = appliedCharge;
    map['isExcluded'] = isExcluded;
    return map;
  }

}