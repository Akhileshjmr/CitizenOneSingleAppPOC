import 'Options.dart';

class SelectOptionList {
  SelectOptionList({
      this.key, 
      this.options,});

  SelectOptionList.fromJson(dynamic json) {
    key = json['key'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }
  String? key;
  List<Options>? options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    if (options != null) {
      map['options'] = options!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}