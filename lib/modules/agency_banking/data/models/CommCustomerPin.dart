import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommCustomerPin {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? customerID;
  String? customerPin;
  DateTime? pinGeneratedDate;
  String? agentCode;
  String? deviceId;
  String? wallet_account;
  String? mobile_no;
  String? oldCustomerPin;
  String? confirmCustomerPin;
  String? otp;
  String? unique_id;

  CommCustomerPin({
    this.headerInfo,
    this.resMessage,
    this.customerID,
    this.customerPin,
    this.pinGeneratedDate,
    this.agentCode,
    this.deviceId,
    this.wallet_account,
    this.mobile_no,
    this.oldCustomerPin,
    this.confirmCustomerPin,
    this.otp,
    this.unique_id,
  });

  // Factory method to create an instance from a JSON object
  factory CommCustomerPin.fromJson(Map<String, dynamic> json) {
    return CommCustomerPin(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      customerID: json['customerID'],
      customerPin: json['customerPin'],
      pinGeneratedDate: json['pinGeneratedDate'] != null
          ? DateTime.parse(json['pinGeneratedDate'])
          : null,
      agentCode: json['agentCode'],
      deviceId: json['deviceId'],
      wallet_account: json['wallet_account'],
      mobile_no: json['mobile_no'],
      oldCustomerPin: json['oldCustomerPin'],
      confirmCustomerPin: json['confirmCustomerPin'],
      otp: json['otp'],
      unique_id: json['unique_id'],
    );
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'customerID': customerID,
      'customerPin': customerPin,
      'pinGeneratedDate': pinGeneratedDate?.toIso8601String(),
      'agentCode': agentCode,
      'deviceId': deviceId,
      'wallet_account': wallet_account,
      'mobile_no': mobile_no,
      'oldCustomerPin': oldCustomerPin,
      'confirmCustomerPin': confirmCustomerPin,
      'otp': otp,
      'unique_id': unique_id,
    };
  }
}