import 'MediaActions.dart';

class Categories {
  Categories({
      this.key, 
      this.name, 
      this.imgUrl, 
      this.desc, 
      this.id, 
      this.prdType, 
      this.mediaActions,});

  Categories.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    imgUrl = json['imgUrl'];
    desc = json['desc'];
    id = json['id'];
    prdType = json['prdType'];
    if (json['mediaActions'] != null) {
      mediaActions = [];
      json['mediaActions'].forEach((v) {
        mediaActions?.add(MediaActions.fromJson(v));
      });
    }
  }
  String? key;
  String? name;
  dynamic imgUrl;
  dynamic desc;
  String? id;
  String? prdType;
  List<MediaActions>? mediaActions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    map['imgUrl'] = imgUrl;
    map['desc'] = desc;
    map['id'] = id;
    map['prdType'] = prdType;
    if (mediaActions != null) {
      map['mediaActions'] = mediaActions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}