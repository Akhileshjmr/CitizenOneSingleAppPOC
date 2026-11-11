
import 'AbLoanSettlements.dart';
import 'EstatementEntity.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommWalletTransaction {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  double? txnAmount;
  String transMethod;
  String? transId; // RefId
  String? serverTxnId; // CBS
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
  String? bEmailId; ///

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

  List<AbLoanSettlements>? settlements;
  String? upVendorType;
  String? cifId;
  String? otpuniqueid;
  String? otp;
  String? otpvalidty;
  int? otpmaxattempts;
  int? otpfailedattempts;
  String? billNo;
  String? upType;
  String? cpBnkCodDes;
  String? billerNumber;
  DateTime? fdate;//
  DateTime? tdate;//
  List<EstatementEntity>? eStatementEntities;//
  String? dwalltyp;//
  String? cwalltype;//
  String? crIdType;//
  String? drIdType;//
  String? crLname;//
  String? drLname;//
  String? moduleDesc;//
  String? translimitmod;//

  CommWalletTransaction({
   this.headerInfo,
  this.resMessage,
    this.txnAmount,
    this.transMethod = '',
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
    this.bEmailId,
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
    this.settlements,
    this.upVendorType,
    this.cifId,
    this.otpuniqueid,
    this.otp,
    this.otpvalidty,
    this.otpmaxattempts,
    this.otpfailedattempts,
    this.billNo,
    this.upType,
    this.cpBnkCodDes,
    this.billerNumber,
    this.fdate,
    this.tdate,
    this.eStatementEntities,
    this.dwalltyp,
    this.cwalltype,
    this.crIdType,
    this.drIdType,
    this.crLname,
    this.drLname,
    this.moduleDesc,
    this.translimitmod,
  });

  // toJson() method for serialization
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'txnAmount': txnAmount,
      'transMethod': transMethod,
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
      'bEmailId': bEmailId,
      'initTime': initTime?.toIso8601String(),
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
      'valDate': valDate?.toIso8601String(),
      'settlements': settlements?.map((e) => e.toJson()).toList(),
      'upVendorType': upVendorType,
      'cifId': cifId,
      'otpuniqueid': otpuniqueid,
      'otp': otp,
      'otpvalidty': otpvalidty,
      'otpmaxattempts': otpmaxattempts,
      'otpfailedattempts': otpfailedattempts,
      'billNo': billNo,
      'upType': upType,
      'cpBnkCodDes': cpBnkCodDes,
      'billerNumber': billerNumber,
      'fdate': fdate?.toIso8601String(),
      'tdate': tdate?.toIso8601String(),
      'eStatementEntities': eStatementEntities?.map((e) => e.toJson()).toList(),
      'dwalltyp': dwalltyp,
      'cwalltype': cwalltype,
      'crIdType': crIdType,
      'drIdType': drIdType,
      'crLname': crLname,
      'drLname': drLname,
      'moduleDesc': moduleDesc,
      'translimitmod': translimitmod,
    };
  }

  // fromJson() method for deserialization
  factory CommWalletTransaction.fromJson(Map<String, dynamic> json) {
    return CommWalletTransaction(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      txnAmount: json['txnAmount'],
      transMethod: json['transMethod'] ?? '',
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
      bEmailId: json['bEmailId'],
      initTime: json['initTime'] != null ? DateTime.parse(json['initTime']) : null,
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
      txnFee: json['txnFee'],
      deductProcess: json['deductProcess'],
      txnCcy: json['txnCcy'],
      cusBnkCod: json['cusBnkCod'],
      cpBnkCod: json['cpBnkCod'],
      loanAccountNumber: json['loanAccountNumber'],
      lnBrn: json['lnBrn'],
      valDate: json['valDate'] != null ? DateTime.parse(json['valDate']) : null,
      settlements: (json['settlements'] as List<dynamic>?)
          ?.map((e) => AbLoanSettlements.fromJson(e))
          .toList(),
      upVendorType: json['upVendorType'],
      cifId: json['cifId'],
      otpuniqueid: json['otpuniqueid'],
      otp: json['otp'],
      otpvalidty: json['otpvalidty'],
      otpmaxattempts: json['otpmaxattempts'],
      otpfailedattempts: json['otpfailedattempts'],
      billNo: json['billNo'],
      upType: json['upType'],
      cpBnkCodDes: json['cpBnkCodDes'],
      billerNumber: json['billerNumber'],
      fdate: json['fdate'] != null ? DateTime.parse(json['fdate']) : null,
      tdate: json['tdate'] != null ? DateTime.parse(json['tdate']) : null,
      eStatementEntities: (json['eStatementEntities'] as List<dynamic>?)
          ?.map((e) => EstatementEntity.fromJson(e))
          .toList(),
      dwalltyp: json['dwalltyp'],
      cwalltype: json['cwalltype'],
      crIdType: json['crIdType'],
      drIdType: json['drIdType'],
      crLname: json['crLname'],
      drLname: json['drLname'],
      moduleDesc: json['moduleDesc'],
      translimitmod: json['translimitmod'],
    );
  }
}
