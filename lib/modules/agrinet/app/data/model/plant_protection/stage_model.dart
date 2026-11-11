class SeedModel {
  final String damageID; // or stage id
  final String cropName;
  final String stage;
  final String? stageImage;

  SeedModel({
    required this.damageID,
    required this.cropName,
    required this.stage,
    this.stageImage,
  });

  factory SeedModel.fromJson(Map<String, dynamic> j) => SeedModel(
    damageID: j['damageID'] as String,
    cropName: j['cropName'] as String,
    stage: j['stage'] as String,
    stageImage: j['stageImage'] as String?,
  );
}
