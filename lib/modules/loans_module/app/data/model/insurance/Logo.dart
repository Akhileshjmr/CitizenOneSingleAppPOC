class Logo {
  Logo({
      this.actionType, 
      this.url, 
      this.id,});

  Logo.fromJson(dynamic json) {
    actionType = json['actionType'];
    url = json['url'];
    id = json['id'];
  }
  dynamic actionType;
  String? url;
  dynamic id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['actionType'] = actionType;
    map['url'] = url;
    map['id'] = id;
    return map;
  }

}