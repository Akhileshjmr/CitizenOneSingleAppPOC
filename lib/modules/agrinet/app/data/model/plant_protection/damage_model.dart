class DamageModel {
  final String damageNum;
  final String damagename;
  final String? documents;

  DamageModel({
    required this.damageNum,
    required this.damagename,
    this.documents,
  });

  factory DamageModel.fromJson(Map<String, dynamic> j) => DamageModel(
    damageNum: j['damageNum'] as String,
    damagename: j['damagename'] as String,
    documents: j['documents'] as String?,
  );
}
