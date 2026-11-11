import 'EstatementEntity.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class AccountTransHistory {
  DateTime? fdate;
  DateTime? tdate;
  String? moduleType;
  String? transMethod;
  String? transId;
  List<EstatementEntity>? eStatementEntities;
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;

  // Constructor
  AccountTransHistory({
    this.fdate,
    this.tdate,
    this.moduleType,
    this.transMethod,
    this.transId,
    this.eStatementEntities,
    this.headerInfo,
    this.resMessage,
  });

  // fromJson factory method
  factory AccountTransHistory.fromJson(Map<String, dynamic> json) {
    return AccountTransHistory(
      fdate: json['fdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fdate'])
          : null,
      tdate: json['tdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['tdate'])
          : null,
      moduleType: json['moduleType'],
      transMethod: json['transMethod'],
      transId: json['transId'],
      eStatementEntities: json['eStatementEntities'] != null
          ? (json['eStatementEntities'] as List)
          .map((e) => EstatementEntity.fromJson(e))
          .toList()
          : null,
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'fdate': fdate?.millisecondsSinceEpoch,
      'tdate': tdate?.millisecondsSinceEpoch,
      'moduleType': moduleType,
      'transMethod': transMethod,
      'transId': transId,
      'eStatementEntities':
      eStatementEntities?.map((e) => e.toJson()).toList(),
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
    };
  }
}
