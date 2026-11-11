class Options {
  Options({
      this.id, 
      this.type, 
      this.friendlyType,
      this.isEnabled
  });

  Options.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
    isEnabled = json['isEnabled'];
  }
  int? id;
  String? type;
  String? friendlyType;
  bool? isEnabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['friendlyType'] = friendlyType;
    map['isEnabled'] = isEnabled;
    return map;
  }

}