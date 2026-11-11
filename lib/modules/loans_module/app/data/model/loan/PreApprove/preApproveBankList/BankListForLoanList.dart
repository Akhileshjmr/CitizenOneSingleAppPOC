import 'GdbChBank.dart';
import 'Tenure.dart';

class BankListForLoanList {
  BankListForLoanList({
      this.gdbChBank, 
      // this.feeAndCharges,
      this.tenure, 
      this.maxAmount, 
      this.interestRate, 
      this.bankName, 
      this.appliedForLoan, 
      this.totalfeeCharegs,
      this.leadId,
      this.lastMsgSendBy,
      this.chatId,
      this.appType,
      this.status,
  });

  BankListForLoanList.fromJson(dynamic json) {
    gdbChBank = json['gdbChBank'] != null ? GdbChBank.fromJson(json['gdbChBank']) : null;
    // if (json['feeAndCharges'] != null) {
    //   feeAndCharges = [];
    //   json['feeAndCharges'].forEach((v) {
    //     feeAndCharges.add(Dynamic.fromJson(v));
    //   });
    // }
    if (json['tenure'] != null) {
      tenure = [];
      json['tenure'].forEach((v) {
        tenure?.add(Tenure.fromJson(v));
      });
    }
    maxAmount = json['maxAmount'];
    interestRate = json['interestRate'];
    bankName = json['bankName'];
    appliedForLoan = json['appliedForLoan'];
    totalfeeCharegs = json['totalfeeCharegs'];
    leadId = json['leadId'];
    lastMsgSendBy = json['lastMsgSendBy'];
    chatId = json['chatId'];
    appType = json['appType'];
    status = json['status'];
  }
  GdbChBank? gdbChBank;
  // List<dynamic> feeAndCharges;
  List<Tenure>? tenure;
  String? maxAmount;
  String? interestRate;
  String? bankName;
  bool? appliedForLoan;
  dynamic totalfeeCharegs;
  int? leadId;
  String? lastMsgSendBy;
  int? chatId;
  String? appType;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (gdbChBank != null) {
      map['gdbChBank'] = gdbChBank?.toJson();
    }
    // if (feeAndCharges != null) {
    //   map['feeAndCharges'] = feeAndCharges.map((v) => v.toJson()).toList();
    // }
    if (tenure != null) {
      map['tenure'] = tenure?.map((v) => v.toJson()).toList();
    }
    map['maxAmount'] = maxAmount;
    map['interestRate'] = interestRate;
    map['bankName'] = bankName;
    map['appliedForLoan'] = appliedForLoan;
    map['totalfeeCharegs'] = totalfeeCharegs;
    map['leadId'] = leadId;
    map['lastMsgSendBy'] = lastMsgSendBy;
    map['chatId'] = chatId;
    map['appType'] = appType;
    map['status'] = status;
    return map;
  }

}