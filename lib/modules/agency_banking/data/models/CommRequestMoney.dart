import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommRequestMoney {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  double? reqAmount;
  String? requestId;
  String? requesterMob;
  String? requesterName;
  String? requesting_toMob;
  String? requesting_toName;
  String? requestsubmiterremarks;
  String? paymentsubmiterremarks;
  String? txntype;
  String? status;
  DateTime? initTime;
  String? operation;
  String? usertype;
  String? debitAcc;
  String? creditAcc;
  String? currency;
  String? remarks;

  CommRequestMoney({
    this.headerInfo,
    this.resMessage,
    this.reqAmount,
    this.requestId,
    this.requesterMob,
    this.requesterName,
    this.requesting_toMob,
    this.requesting_toName,
    this.requestsubmiterremarks,
    this.paymentsubmiterremarks,
    this.txntype,
    this.status,
    this.initTime,
    this.operation,
    this.usertype,
    this.debitAcc,
    this.creditAcc,
    this.currency,
    this.remarks,
  });

  // Factory method to create an instance from JSON
  factory CommRequestMoney.fromJson(Map<String, dynamic> json) {
    return CommRequestMoney(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      reqAmount: json['reqAmount']?.toDouble(),
      requestId: json['requestId'] as String?,
      requesterMob: json['requesterMob'] as String?,
      requesterName: json['requesterName'] as String?,
      requesting_toMob: json['requesting_toMob'] as String?,
      requesting_toName: json['requesting_toName'] as String?,
      requestsubmiterremarks: json['requestsubmiterremarks'] as String?,
      paymentsubmiterremarks: json['paymentsubmiterremarks'] as String?,
      txntype: json['txntype'] as String?,
      status: json['status'] as String?,

      initTime: json['initTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['initTime'])
          : null,
      operation: json['operation'] as String?,
      usertype: json['usertype'] as String?,
      debitAcc: json['debitAcc'] as String?,
      creditAcc: json['creditAcc'] as String?,
      currency: json['currency'] as String?,
      remarks: json['remarks'] as String?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'reqAmount': reqAmount,
      'requestId': requestId,
      'requesterMob': requesterMob,
      'requesterName': requesterName,
      'requesting_toMob': requesting_toMob,
      'requesting_toName': requesting_toName,
      'requestsubmiterremarks': requestsubmiterremarks,
      'paymentsubmiterremarks': paymentsubmiterremarks,
      'txntype': txntype,
      'status': status,
      'initTime': initTime?.millisecondsSinceEpoch,
      'operation': operation,
      'usertype': usertype,
      'debitAcc': debitAcc,
      'creditAcc': creditAcc,
      'currency': currency,
      'remarks': remarks,
    };
  }
}
