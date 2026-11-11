class SectorOption {
  final int id;
  final String type;
  final String friendlyType;

  SectorOption({
    required this.id,
    required this.type,
    required this.friendlyType,
  });

  factory SectorOption.fromJson(Map<String, dynamic> json) {
    return SectorOption(
      id: json["id"],
      type: json["type"],
      friendlyType: json["friendlyType"],
    );
  }
}