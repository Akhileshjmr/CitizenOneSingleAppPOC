import 'AbLoanAccountStats.dart';
import 'AbLoanSettlements.dart';

class AbLoanDetailLiqResp {
  String? valdt;
  String? execdt;
  String? lmtdt;
  String? custId;
  String? rslvVal;
  String? txnStat;
  String? authStat;
  String? customerName;
  String? prodDesc;
  String? productCode;
  String? totalPrinOut;
  List<AbLoanSettlements>? abLoanSettelments;
  List<AbLoanAccountStats>? abLoanAccountStats;

  AbLoanDetailLiqResp({
    this.valdt,
    this.execdt,
    this.lmtdt,
    this.custId,
    this.rslvVal,
    this.txnStat,
    this.authStat,
    this.customerName,
    this.prodDesc,
    this.productCode,
    this.totalPrinOut,
    this.abLoanSettelments,
    this.abLoanAccountStats,
  });

  factory AbLoanDetailLiqResp.fromJson(Map<String, dynamic> json) {
    return AbLoanDetailLiqResp(
      valdt: json['valdt'],
      execdt: json['execdt'],
      lmtdt: json['lmtdt'],
      custId: json['custId'],
      rslvVal: json['rslvVal'],
      txnStat: json['txnStat'],
      authStat: json['authStat'],
      customerName: json['customerName'],
      prodDesc: json['prodDesc'],
      productCode: json['productCode'],
      totalPrinOut: json['totalPrinOut'],
      abLoanSettelments: (json['abLoanSettelments'] as List<dynamic>?)
          ?.map((e) => AbLoanSettlements.fromJson(e))
          .toList(),
      abLoanAccountStats: (json['abLoanAccountStats'] as List<dynamic>?)
          ?.map((e) => AbLoanAccountStats.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valdt': valdt,
      'execdt': execdt,
      'lmtdt': lmtdt,
      'custId': custId,
      'rslvVal': rslvVal,
      'txnStat': txnStat,
      'authStat': authStat,
      'customerName': customerName,
      'prodDesc': prodDesc,
      'productCode': productCode,
      'totalPrinOut': totalPrinOut,
      'abLoanSettelments': abLoanSettelments?.map((e) => e.toJson()).toList(),
      'abLoanAccountStats': abLoanAccountStats?.map((e) => e.toJson()).toList(),
    };
  }
}