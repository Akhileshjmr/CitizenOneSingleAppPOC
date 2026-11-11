class EmpStatus {
  final int? id;
  final String? type;
  final String? friendlyType;

  const EmpStatus({this.id, this.type, this.friendlyType});

  // -------------------------------
  // From JSON
  // -------------------------------

  factory EmpStatus.fromJson(Map<String, dynamic> json) {
    return EmpStatus(
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
  // CopyWith (Important)
  // -------------------------------

  EmpStatus copyWith({int? id, String? type, String? friendlyType}) {
    return EmpStatus(
      id: id ?? this.id,
      type: type ?? this.type,
      friendlyType: friendlyType ?? this.friendlyType,
    );
  }
}
