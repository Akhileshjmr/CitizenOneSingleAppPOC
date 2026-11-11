import '../common/option.dart';

class SelectOption {
  final String? key;
  final List<Option>? options;

  SelectOption({this.key, this.options});

  factory SelectOption.fromJson(Map<String, dynamic> json) => SelectOption(
    key: json["key"],
    options:
        json["options"] == null
            ? []
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "options": options?.map((x) => x.toJson()).toList(),
  };
}
