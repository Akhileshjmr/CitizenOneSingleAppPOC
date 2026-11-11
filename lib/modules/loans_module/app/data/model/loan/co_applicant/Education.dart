class Education {
  Education({
      this.id, 
      this.type, 
      this.friendlyType,});

  Education.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
  }
  dynamic id;
  dynamic type;
  dynamic friendlyType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['friendlyType'] = friendlyType;
    return map;
  }

}