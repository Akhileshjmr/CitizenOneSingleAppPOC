class DocumentName {
  DocumentName({
      this.id, 
      this.type, 
      this.friendlyType,});

  DocumentName.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
  }
  dynamic id;
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