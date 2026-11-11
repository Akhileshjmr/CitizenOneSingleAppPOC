import 'CompValues.dart';

class Attrs {
  Attrs({
      this.key, 
      this.compValues, 
      this.fldType,});

  Attrs.fromJson(dynamic json) {
    key = json['key'];
    if (json['compValues'] != null) {
      compValues = [];
      json['compValues'].forEach((v) {
        compValues?.add(CompValues.fromJson(v));
      });
    }
    fldType = json['fldType'];
  }
  String? key;
  List<CompValues>? compValues;
  dynamic fldType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    if (compValues != null) {
      map['compValues'] = compValues?.map((v) => v.toJson()).toList();
    }
    map['fldType'] = fldType;
    return map;
  }

}