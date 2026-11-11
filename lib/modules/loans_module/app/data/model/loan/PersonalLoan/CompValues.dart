class CompValues {
  CompValues({
      this.values,});

  CompValues.fromJson(dynamic json) {
    values = json['values'] != null ? json['values'].cast<String>() : [];
  }
  List<String>? values;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['values'] = values;
    return map;
  }

}