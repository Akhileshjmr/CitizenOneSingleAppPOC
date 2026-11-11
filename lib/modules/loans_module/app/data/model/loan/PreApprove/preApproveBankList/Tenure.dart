class Tenure {
  Tenure({
      this.tenure, 
      this.tenureSpred, 
      this.appliedIntrest, 
      this.emiPrMonth,});

  Tenure.fromJson(dynamic json) {
    tenure = json['tenure'];
    tenureSpred = json['tenureSpred'];
    appliedIntrest = json['appliedIntrest'];
    emiPrMonth = json['emiPrMonth'];
  }
  String? tenure;
  String? tenureSpred;
  String? appliedIntrest;
  String? emiPrMonth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tenure'] = tenure;
    map['tenureSpred'] = tenureSpred;
    map['appliedIntrest'] = appliedIntrest;
    map['emiPrMonth'] = emiPrMonth;
    return map;
  }

}