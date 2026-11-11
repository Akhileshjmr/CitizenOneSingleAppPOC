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
  String? actionType;
  String? url;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['actionType'] = actionType;
    map['url'] = url;
    map['id'] = id;
    return map;
  }

}