import 'UrlAction.dart';

class GdbChMediaAction {
  GdbChMediaAction({
      this.type, 
      this.urlAction,});

  GdbChMediaAction.fromJson(dynamic json) {
    type = json['type'];
    urlAction = json['urlAction'] != null ? UrlAction.fromJson(json['urlAction']) : null;
  }
  String? type;
  UrlAction? urlAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (urlAction != null) {
      map['urlAction'] = urlAction?.toJson();
    }
    return map;
  }

}