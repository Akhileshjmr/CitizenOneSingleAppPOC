import 'option.dart';

class SelectOptionItem {
  String? key;
  List<Option>? options;

  SelectOptionItem({this.key, this.options});

  factory SelectOptionItem.fromJson(Map<String, dynamic> json) {
    return SelectOptionItem(
      key: json['key'],
      options:
          json['options'] != null
              ? (json['options'] as List)
                  .map((e) => Option.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'options': options?.map((e) => e.toJson()).toList()};
  }
}
