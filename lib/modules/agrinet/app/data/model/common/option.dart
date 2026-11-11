class Option {
  int? id;
  String? type;
  String? friendlyType;
  Option? other;

  Option({this.id, this.type, this.friendlyType, this.other});

  factory Option.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Option();

    return Option(
      id: json['id'] as int?,
      type: json['type'] as String?,
      friendlyType: json['friendlyType'] as String?,
      other:
          json['other'] != null
              ? Option.fromJson(json['other'] as Map<String, dynamic>?)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'friendlyType': friendlyType,
      'other': other?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option &&
          runtimeType == other.runtimeType &&
          (type?.toUpperCase() == other.type?.toUpperCase());

  @override
  int get hashCode => type?.toUpperCase().hashCode ?? 0;
}
