import 'Items.dart';

class Layouts {
  Layouts({
      this.type, 
      this.title, 
      this.subtitle, 
      this.imageUrl, 
      this.items,});

  Layouts.fromJson(dynamic json) {
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];
    imageUrl = json['imageUrl'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }
  String? type;
  String? title;
  dynamic subtitle;
  dynamic imageUrl;
  List<Items>? items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['title'] = title;
    map['subtitle'] = subtitle;
    map['imageUrl'] = imageUrl;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}