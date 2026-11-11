// class LocationOption {
//   final int id;
//   final String name;
//   final int? parentId;

//   LocationOption({
//     required this.id,
//     required this.name,
//     this.parentId,
//   });

//   factory LocationOption.fromJson(Map<String, dynamic> json) {
//     return LocationOption(
//       id: json["id"],
//       name: json["friendlyType"] ?? json["type"],
//       parentId: json["other"]?["id"],
//     );
//   }
// }
class LocationOption {
  final int id;
  final String name;
  final int? parentId;

  LocationOption({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory LocationOption.fromJson(Map<String, dynamic> json) {
    return LocationOption(
      id: json["id"],
      name: json["friendlyType"] ?? json["type"],
      parentId: json["other"]?["id"],
    );
  }
}