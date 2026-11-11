class Valuess {
  Valuess({
    this.feature,
    this.featureVal,});

  Valuess.fromJson(dynamic json) {
    feature = json['feature'];
    featureVal = json['featureVal'];
  }
  String? feature;
  int? featureVal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feature'] = feature;
    map['featureVal'] = featureVal;
    return map;
  }

}