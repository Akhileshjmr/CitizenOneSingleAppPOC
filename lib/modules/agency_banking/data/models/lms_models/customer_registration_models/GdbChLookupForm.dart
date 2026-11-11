class GdbChLookupForm {
  String? key;
  String? type;
  String? friendlyType;

  GdbChLookupForm({this.key, this.type, this.friendlyType});

  factory GdbChLookupForm.fromJson(Map<String, dynamic> json) {
    return GdbChLookupForm(
      key: json['key'],
      type: json['type'],
      friendlyType: json['friendlyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      'friendlyType': friendlyType,
    };
  }
}