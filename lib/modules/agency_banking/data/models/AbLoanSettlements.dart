import 'dart:convert';

import 'LoanCompstld.dart';

class AbLoanSettlements {
  String? rvrsd;
  String? stlmod;
  String? stlccy;
  String? stlamt;
  String? lonccyeqv;
  String? stlbrn;
  String? stlrefno;
  String? settlementtype;
  String? stlacc;
  String? exRate;
  List<LoanCompstld>? compstld;

  // Constructor
  AbLoanSettlements({
    this.rvrsd,
    this.stlmod,
    this.stlccy,
    this.stlamt,
    this.lonccyeqv,
    this.stlbrn,
    this.stlrefno,
    this.settlementtype,
    this.stlacc,
    this.exRate,
    this.compstld,
  });

  // Factory method to create an object from JSON
  factory AbLoanSettlements.fromJson(Map<String, dynamic> json) {
    return AbLoanSettlements(
      rvrsd: json['rvrsd'],
      stlmod: json['stlmod'],
      stlccy: json['stlccy'],
      stlamt: json['stlamt'],
      lonccyeqv: json['lonccyeqv'],
      stlbrn: json['stlbrn'],
      stlrefno: json['stlrefno'],
      settlementtype: json['settlementtype'],
      stlacc: json['stlacc'],
      exRate: json['exRate'],
      compstld: (json['compstld'] as List<dynamic>?)
          ?.map((item) => LoanCompstld.fromJson(item))
          .toList(),
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'rvrsd': rvrsd,
      'stlmod': stlmod,
      'stlccy': stlccy,
      'stlamt': stlamt,
      'lonccyeqv': lonccyeqv,
      'stlbrn': stlbrn,
      'stlrefno': stlrefno,
      'settlementtype': settlementtype,
      'stlacc': stlacc,
      'exRate': exRate,
      'compstld': compstld?.map((item) => item.toJson()).toList(),
    };
  }
}


