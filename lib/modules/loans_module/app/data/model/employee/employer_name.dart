class EmployerName {
  final int? id;
  final String? type;
  final String? friendlyType;

  const EmployerName({this.id, this.type, this.friendlyType});

  // -------------------------------
  // From JSON
  // -------------------------------

  factory EmployerName.fromJson(Map<String, dynamic> json) {
    return EmployerName(
      id: (json['id'] as num?)?.toInt(),
      type: json['type']?.toString(),
      friendlyType: json['friendlyType']?.toString(),
    );
  }

  // -------------------------------
  // To JSON
  // -------------------------------

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'friendlyType': friendlyType};
  }

  // -------------------------------
  // CopyWith
  // -------------------------------

  EmployerName copyWith({int? id, String? type, String? friendlyType}) {
    return EmployerName(
      id: id ?? this.id,
      type: type ?? this.type,
      friendlyType: friendlyType ?? this.friendlyType,
    );
  }
}
