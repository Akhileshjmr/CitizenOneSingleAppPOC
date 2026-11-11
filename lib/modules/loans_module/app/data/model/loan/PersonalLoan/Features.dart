import 'Valuess.dart';

class Features {
  Features({
      this.key, 
      required this.values,});

  Features.fromJson(dynamic json) {
    key = json['key'];
    if (json['values'] != null) {
      values = [];
      json['values'].forEach((v) {
        values?.add(Valuess?.fromJson(v));
      });
    }
  }
  String? key;
  List<Valuess>? values;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    if (values != null) {
      map['values'] = values?.map((v) => v?.toJson()).toList();
    }
    return map;
  }

}