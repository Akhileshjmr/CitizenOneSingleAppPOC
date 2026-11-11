class Industry {
  final int? id;
  final String? type;
  final String? friendlyType;

  const Industry({this.id, this.type, this.friendlyType});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: (json['id'] as num?)?.toInt(),
      type: json['type']?.toString(),
      friendlyType: json['friendlyType']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'friendlyType': friendlyType};
  }

  Industry copyWith({int? id, String? type, String? friendlyType}) {
    return Industry(
      id: id ?? this.id,
      type: type ?? this.type,
      friendlyType: friendlyType ?? this.friendlyType,
    );
  }
}
