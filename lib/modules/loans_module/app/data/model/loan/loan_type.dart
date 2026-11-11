import 'package:flutter/widgets.dart';

class LoanType {
  LoanType({this.id, this.name, this.image,this.backgroundColor1,this.backgroundColor2,this.subTitle,this.icon});

  LoanType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    backgroundColor1 = json['backgroundColor1'];
    backgroundColor2 = json['backgroundColor2'];
    subTitle = json['subTitle'];
    icon = json['icon'];
  }
  int? id;
  String? name;
  String? image;
  Color? backgroundColor1;
  Color? backgroundColor2;
  String? subTitle;
  Icon? icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['backgroundColor1'] = backgroundColor1;
    map['backgroundColor2'] = backgroundColor2;
    map['subTitle'] = subTitle;
    map['icon'] = icon;
    return map;
  }
}
