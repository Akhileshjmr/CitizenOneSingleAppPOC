import 'Fields.dart';

class EmpDetails {
  EmpDetails({
      this.key, 
      this.fields,});

  EmpDetails.fromJson(dynamic json) {
    key = json['key'];
    if (json['fields'] != null) {
      fields = [];
      json['fields'].forEach((v) {
        fields?.add(Fields.fromJson(v));
      });
    }
  }
  String? key;
  List<Fields>? fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    if (fields != null) {
      map['fields'] = fields?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}