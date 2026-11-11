import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommTransaction {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  double? txnAmount;
  String? txnAmt;
  String? transId;
  String? serverTxnId;
  String? dBranch;
  String? cBranch;
  String? dAccountNo;
  String? dName;
  String? dLoc;
  String? dCurrency;
  String? dMob;
  String? bAccountNo;
  String? bName;
  String? bLoc;
  String? bMob;
  String? bCurrency;
  String? bIdType;
  String? bIdNum;
  DateTime? initTime;
  String? moduleType;
  String? dIdType;
  String? dIdNum;
  String? remarks;
  String? txnStatus;
  String? paymentType;
  String? depLastName;
  String? benfLastName;
  String? chargeType;
  String? validationType;
  String? securirityQuestion;
  String? securirityAns;
  String? secType;
  String? uniqueId;
  double? txnFee;
  String? deductProcess;
  String? txnCcy;
  String? cusBnkCod;
  String? cpBnkCod;
  String? loanAccountNumber;
  String? lnBrn;
  DateTime? valDate;
  DateTime? exeDate;
  String? authStatus;
  String? custPin;

  CommTransaction({
    this.headerInfo,
    this.resMessage,
    this.txnAmount,
    this.txnAmt,
    this.transId,
    this.serverTxnId,
    this.dBranch,
    this.cBranch,
    this.dAccountNo,
    this.dName,
    this.dLoc,
    this.dCurrency,
    this.dMob,
    this.bAccountNo,
    this.bName,
    this.bLoc,
    this.bMob,
    this.bCurrency,
    this.bIdType,
    this.bIdNum,
    this.initTime,
    this.moduleType,
    this.dIdType,
    this.dIdNum,
    this.remarks,
    this.txnStatus,
    this.paymentType,
    this.depLastName,
    this.benfLastName,
    this.chargeType,
    this.validationType,
    this.securirityQuestion,
    this.securirityAns,
    this.secType,
    this.uniqueId,
    this.txnFee,
    this.deductProcess,
    this.txnCcy,
    this.cusBnkCod,
    this.cpBnkCod,
    this.loanAccountNumber,
    this.lnBrn,
    this.valDate,
    this.exeDate,
    this.authStatus,
    this.custPin,
  });

  /// Helper: parse dynamic value into DateTime
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      // epoch millis
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      // ISO string
      return DateTime.tryParse(value);
    }
    return null;
  }

  factory CommTransaction.fromJson(Map<String, dynamic> json) {
    return CommTransaction(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      txnAmount: (json['txnAmount'] as num?)?.toDouble(),
      txnAmt: json['txnAmt'],
      transId: json['transId'],
      serverTxnId: json['serverTxnId'],
      dBranch: json['dBranch'],
      cBranch: json['cBranch'],
      dAccountNo: json['dAccountNo'],
      dName: json['dName'],
      dLoc: json['dLoc'],
      dCurrency: json['dCurrency'],
      dMob: json['dMob'],
      bAccountNo: json['bAccountNo'],
      bName: json['bName'],
      bLoc: json['bLoc'],
      bMob: json['bMob'],
      bCurrency: json['bCurrency'],
      bIdType: json['bIdType'],
      bIdNum: json['bIdNum'],
      initTime: _parseDate(json['initTime']),
      moduleType: json['moduleType'],
      dIdType: json['dIdType'],
      dIdNum: json['dIdNum'],
      remarks: json['remarks'],
      txnStatus: json['txnStatus'],
      paymentType: json['paymentType'],
      depLastName: json['depLastName'],
      benfLastName: json['benfLastName'],
      chargeType: json['chargeType'],
      validationType: json['validationType'],
      securirityQuestion: json['securirityQuestion'],
      securirityAns: json['securirityAns'],
      secType: json['secType'],
      uniqueId: json['uniqueId'],
      txnFee: (json['txnFee'] as num?)?.toDouble(),
      deductProcess: json['deductProcess'],
      txnCcy: json['txnCcy'],
      cusBnkCod: json['cusBnkCod'],
      cpBnkCod: json['cpBnkCod'],
      loanAccountNumber: json['loanAccountNumber'],
      lnBrn: json['lnBrn'],
      valDate: _parseDate(json['valDate']),
      exeDate: _parseDate(json['exeDate']),
      authStatus: json['authStatus'],
      custPin: json['custPin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'txnAmount': txnAmount,
      'txnAmt': txnAmt,
      'transId': transId,
      'serverTxnId': serverTxnId,
      'dBranch': dBranch,
      'cBranch': cBranch,
      'dAccountNo': dAccountNo,
      'dName': dName,
      'dLoc': dLoc,
      'dCurrency': dCurrency,
      'dMob': dMob,
      'bAccountNo': bAccountNo,
      'bName': bName,
      'bLoc': bLoc,
      'bMob': bMob,
      'bCurrency': bCurrency,
      'bIdType': bIdType,
      'bIdNum': bIdNum,
      // Always send epoch millis
      'initTime': initTime?.millisecondsSinceEpoch,
      'moduleType': moduleType,
      'dIdType': dIdType,
      'dIdNum': dIdNum,
      'remarks': remarks,
      'txnStatus': txnStatus,
      'paymentType': paymentType,
      'depLastName': depLastName,
      'benfLastName': benfLastName,
      'chargeType': chargeType,
      'validationType': validationType,
      'securirityQuestion': securirityQuestion,
      'securirityAns': securirityAns,
      'secType': secType,
      'uniqueId': uniqueId,
      'txnFee': txnFee,
      'deductProcess': deductProcess,
      'txnCcy': txnCcy,
      'cusBnkCod': cusBnkCod,
      'cpBnkCod': cpBnkCod,
      'loanAccountNumber': loanAccountNumber,
      'lnBrn': lnBrn,
      // Always send epoch millis
      'valDate': valDate?.millisecondsSinceEpoch,
      'exeDate': exeDate?.millisecondsSinceEpoch,
      'authStatus': authStatus,
      'custPin': custPin,
    };
  }
}
