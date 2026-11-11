class GdbLookupForm {
  int? id;
  String? type;
  String? friendlyType;

  GdbLookupForm({
    this.id,
    this.type,
    this.friendlyType,
  });

  factory GdbLookupForm.fromJson(Map<String, dynamic> json) {
    return GdbLookupForm(
      id: json['id'],
      type: json['type'],
      friendlyType: json['friendlyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'friendlyType': friendlyType,
    };
  }
}
