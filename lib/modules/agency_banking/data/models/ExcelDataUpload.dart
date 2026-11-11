import 'BulkUploadStatus.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class ExcelDataUpload {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? excelData;
  String bulkBatchId = "";
  String txnType = "";
  String txnMethod = "";
  String filePath = "";
  String apiFlag = "";
  List<BulkUploadStatus> uploadStatusLst = [];

  ExcelDataUpload({
    this.headerInfo,
    this.resMessage,
    this.excelData,
    this.bulkBatchId = "",
    this.txnType = "",
    this.txnMethod = "",
    this.filePath = "",
    this.apiFlag = "",
    this.uploadStatusLst = const [],
  });

  factory ExcelDataUpload.fromJson(Map<String, dynamic> json) {
    return ExcelDataUpload(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      excelData: json['excelData'] ?? "",
      bulkBatchId: json['bulkBatchId'] ?? "",
      txnType: json['txnType'] ?? "",
      txnMethod: json['txnMethod'] ?? "",
      filePath: json['filePath'] ?? "",
      apiFlag: json['apiFlag'] ?? "",
      uploadStatusLst: (json['uploadStatusLst'] as List<dynamic>?)?.map((e) => BulkUploadStatus.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'excelData': excelData,
      'bulkBatchId': bulkBatchId,
      'txnType': txnType,
      'txnMethod': txnMethod,
      'filePath': filePath,
      'apiFlag': apiFlag,
      'uploadStatusLst': uploadStatusLst.map((e) => e.toJson()).toList(),
    };
  }
}