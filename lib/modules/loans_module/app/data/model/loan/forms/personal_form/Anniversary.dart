class Anniversary {
  Anniversary({
      this.id, 
      this.type, 
      this.friendlyType,});

  Anniversary.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
  }
  int? id;
  String? type;
  String? friendlyType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['friendlyType'] = friendlyType;
    return map;
  }

}