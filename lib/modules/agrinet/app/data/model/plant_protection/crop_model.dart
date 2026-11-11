class CropModel {
  final String serialNum;
  final String name;
  final String? documents;

  CropModel({required this.serialNum, required this.name, this.documents});

  factory CropModel.fromJson(Map<String, dynamic> j) => CropModel(
    serialNum: j['serialNum'] as String,
    name: j['name'] as String,
    documents: j['documents'] as String?,
  );
}
