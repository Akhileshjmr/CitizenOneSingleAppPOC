import 'dart:convert';
import 'CommCustDoc.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class WalletKycCustomerReq {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? walletAccountNo;
  String? fname;
  String? mname;
  String? lname;
  String? dob;
  String? gender;
  String? nlty;
  String? custAddress1;
  String? custAddress2;
  String? custAddress3;
  String? city;
  int? zip; // Long -> int
  String? country;
  String? mobIsd;
  int? mobNo; // Long -> int
  int? resNo; // Long -> int
  int? officeNo; // Long -> int
  String? custDesig;
  String? custEmployer;
  int? custAvgMonthlyIncome; // Long -> int
  int? custAvgAnnualIncome; // Long -> int
  String? custType;
  String? acType;
  String? idType;
  String? idNo;
  String? idIssueby;
  List<int>? custImage; // byte[] -> List<int>
  List<int>? custSignature; // byte[] -> List<int>
  String? docType;
  String? docRefnum;
  String? username;
  String? password;
  String? channelId = "";
  List<CommCustDoc>? custDoc; // List<CommCustDoc>
  String? cbsAccEnable;
  String? walletAccEnable;
  String? accountNumber;
  String? branch;
  String? currency;
  String? accountType;
  String? customerId;
  String? userPin;
  String? beforeorAfterlogin;

  WalletKycCustomerReq({
    this.headerInfo,
    this.resMessage,
    this.walletAccountNo,
    this.fname,
    this.mname,
    this.lname,
    this.dob,
    this.gender,
    this.nlty,
    this.custAddress1,
    this.custAddress2,
    this.custAddress3,
    this.city,
    this.zip,
    this.country,
    this.mobIsd,
    this.mobNo,
    this.resNo,
    this.officeNo,
    this.custDesig,
    this.custEmployer,
    this.custAvgMonthlyIncome,
    this.custAvgAnnualIncome,
    this.custType,
    this.acType,
    this.idType,
    this.idNo,
    this.idIssueby,
    this.custImage,
    this.custSignature,
    this.docType,
    this.docRefnum,
    this.username,
    this.password,
    this.channelId,
    this.custDoc,
    this.cbsAccEnable,
    this.walletAccEnable,
    this.accountNumber,
    this.branch,
    this.currency,
    this.accountType,
    this.customerId,
    this.userPin,
    this.beforeorAfterlogin,
  });

  factory WalletKycCustomerReq.fromJson(Map<String, dynamic> json) {
    return WalletKycCustomerReq(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      walletAccountNo: json['walletAccountNo'],
      fname: json['fname'],
      mname: json['mname'],
      lname: json['lname'],
      dob: json['dob'],
      gender: json['gender'],
      nlty: json['nlty'],
      custAddress1: json['custAddress1'],
      custAddress2: json['custAddress2'],
      custAddress3: json['custAddress3'],
      city: json['city'],
      zip: json['zip'],
      country: json['country'],
      mobIsd: json['mobIsd'],
      mobNo: json['mobNo'],
      resNo: json['resNo'],
      officeNo: json['officeNo'],
      custDesig: json['custDesig'],
      custEmployer: json['custEmployer'],
      custAvgMonthlyIncome: json['custAvgMonthlyIncome'],
      custAvgAnnualIncome: json['custAvgAnnualIncome'],
      custType: json['custType'],
      acType: json['acType'],
      idType: json['idType'],
      idNo: json['idNo'],
      idIssueby: json['idIssueby'],
      custImage:
      json['custImage'] != null ? base64Decode(json['custImage']) : null,
      custSignature:
      json['custSignature'] != null ? base64Decode(json['custSignature']) : null,
      docType: json['docType'],
      docRefnum: json['docRefnum'],
      username: json['username'],
      password: json['password'],
      channelId: json['channelId'],
      custDoc: json['custDoc'] != null
          ? (json['custDoc'] as List)
          .map((item) => CommCustDoc.fromJson(item))
          .toList()
          : null,
      cbsAccEnable: json['cbsAccEnable'],
      walletAccEnable: json['walletAccEnable'],
      accountNumber: json['accountNumber'],
      branch: json['branch'],
      currency: json['currency'],
      accountType: json['accountType'],
      customerId: json['customerId'],
      userPin: json['userPin'],
      beforeorAfterlogin: json['beforeorAfterlogin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'walletAccountNo': walletAccountNo,
      'fname': fname,
      'mname': mname,
      'lname': lname,
      'dob': dob,
      'gender': gender,
      'nlty': nlty,
      'custAddress1': custAddress1,
      'custAddress2': custAddress2,
      'custAddress3': custAddress3,
      'city': city,
      'zip': zip,
      'country': country,
      'mobIsd': mobIsd,
      'mobNo': mobNo,
      'resNo': resNo,
      'officeNo': officeNo,
      'custDesig': custDesig,
      'custEmployer': custEmployer,
      'custAvgMonthlyIncome': custAvgMonthlyIncome,
      'custAvgAnnualIncome': custAvgAnnualIncome,
      'custType': custType,
      'acType': acType,
      'idType': idType,
      'idNo': idNo,
      'idIssueby': idIssueby,
      'custImage': custImage != null ? base64Encode(custImage!) : null,
      'custSignature': custSignature != null ? base64Encode(custSignature!) : null,
      'docType': docType,
      'docRefnum': docRefnum,
      'username': username,
      'password': password,
      'channelId': channelId,
      'custDoc': custDoc?.map((item) => item.toJson()).toList(),
      'cbsAccEnable': cbsAccEnable,
      'walletAccEnable': walletAccEnable,
      'accountNumber': accountNumber,
      'branch': branch,
      'currency': currency,
      'accountType': accountType,
      'customerId': customerId,
      'userPin': userPin,
      'beforeorAfterlogin': beforeorAfterlogin,
    };
  }
}
