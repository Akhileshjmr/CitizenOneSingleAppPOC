import 'ipm_practice.dart';

class InsectModel {
  final String insNum;
  final String insName;
  final String? insDocument;
  final String? insType;
  final String? insStage;
  final List<IPMPractice>? ipmPractice;

  InsectModel({
    required this.insNum,
    required this.insName,
    this.insDocument,
    this.insType,
    this.insStage,
    this.ipmPractice,
  });

  factory InsectModel.fromJson(Map<String, dynamic> j) {
    final ipm = j['ipmPractice'];
    return InsectModel(
      insNum: j['insNum'] as String,
      insName: j['insName'] as String,
      insDocument: j['insDocument'] as String?,
      insType: j['insType'] as String?,
      insStage: j['insStage'] as String?,
      ipmPractice:
          ipm == null
              ? null
              : (ipm as List).map((e) => IPMPractice.fromJson(e)).toList(),
    );
  }
}
