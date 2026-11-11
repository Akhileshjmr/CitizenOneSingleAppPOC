class Fields {
  Fields({
      this.key, 
      this.lable, 
      this.value, 
      this.type, 
      this.id,});

  Fields.fromJson(dynamic json) {
    key = json['key'];
    lable = json['lable'];
    value = json['value'];
    type = json['type'];
    id = json['id'];
  }
  String? key;
  String? lable;
  String? value;
  String? type;
  dynamic id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['lable'] = lable;
    map['value'] = value;
    map['type'] = type;
    map['id'] = id;
    return map;
  }

}