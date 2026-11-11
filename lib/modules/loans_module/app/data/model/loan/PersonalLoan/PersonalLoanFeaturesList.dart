class PersonalLoanFeaturesList {
  PersonalLoanFeaturesList({
      required this.feature,
      required this.featureVal,});

  PersonalLoanFeaturesList.fromJson(dynamic json) {
    feature = json['feature'];
    featureVal = json['featureVal'];
  }
  String? feature;
  String? featureVal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feature'] = feature;
    map['featureVal'] = featureVal;
    return map;
  }

}