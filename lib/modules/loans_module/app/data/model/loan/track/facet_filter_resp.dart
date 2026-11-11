class FacetFilterResp {
  String? key;
  String? value;
  String? type;

  FacetFilterResp({this.key, this.value, this.type});

  @override
  String toString() {
    return 'FacetFilterResp{key: $key, value: $value, type: $type}';
  }

  FacetFilterResp.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    data['type'] = type;
    return data;
  }
}
