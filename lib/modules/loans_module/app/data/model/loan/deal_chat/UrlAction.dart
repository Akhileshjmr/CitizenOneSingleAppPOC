class UrlAction {
  UrlAction({
      this.actionType, 
      this.url, 
      this.id,});

  UrlAction.fromJson(dynamic json) {
    actionType = json['actionType'];
    url = json['url'];
    id = json['id'];
  }
  dynamic actionType;
  dynamic url;
  dynamic id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['actionType'] = actionType;
    map['url'] = url;
    map['id'] = id;
    return map;
  }

}