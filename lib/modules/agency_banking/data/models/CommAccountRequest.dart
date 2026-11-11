/*
import 'AbCommJointCustDetails.dart';
import 'CommCustDoc.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommAccountRequest {
  HeaderInfo headerInfo;
  ServerMessage resMessage;
  String customerId;
  String customerName;
  String accountNum;
  double initialBalance;
  DateTime createdDate;
  String phoneNum;
  String requestId;
  String accountType;
  String requestStatus;
  String accCcy;
  String accoutClass;
  String accountKitNo;
  String media;
  String location;
  String isJointAccount;
  String availabeBal;
  String currentBal;
  String openingBal;
  String branch;
  String rmcode;
  List<AbCommJointCustDetails> jointAcc;
  List<CommCustDoc> custDoc;
  String mobileno;
  List<CommAccountRequest> additionalAccountList;
  String selfAccountCheck;
  String isSelected;
  String branchname;

  CommAccountRequest({
    ServerMessage? resMessage,
    HeaderInfo? headerInfo,
    this.customerId = '',
    this.customerName = '',
    this.accountNum = '',
    this.initialBalance = 0.0,
    DateTime? createdDate,
    this.phoneNum = '',
    this.requestId = '',
    this.accountType = '',
    this.requestStatus = '',
    this.accCcy = '',
    this.accoutClass = '',
    this.accountKitNo = '',
    this.media = '',
    this.location = '',
    this.isJointAccount = '',
    this.availabeBal = '',
    this.currentBal = '',
    this.openingBal = '',
    this.branch = '',
    this.rmcode = '',
    this.jointAcc = const [],
    this.custDoc = const [],
    this.mobileno = '',
    this.additionalAccountList = const [],
    this.selfAccountCheck = '',
    this.isSelected = '',
    this.branchname='',
  })  :  headerInfo = headerInfo ?? HeaderInfo(),
        resMessage = resMessage ?? ServerMessage(),
        createdDate = createdDate ?? DateTime.now();

  // Getters for private fields
  // HeaderInfo get headerInfo => _headerInfo;
  // ServerMessage get resMessage => _resMessage;
  //
  // // Setters for private fields
  // set headerInfo(HeaderInfo headerInfo) {
  //   _headerInfo = headerInfo;
  // }
  //
  // set resMessage(ServerMessage resMessage) {
  //   _resMessage = resMessage;
  // }

  // Convert JSON to CommAccountRequest
  factory CommAccountRequest.fromJson(Map<String, dynamic> json) {
    return CommAccountRequest(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      accountNum: json['accountNum'] ?? '',
      initialBalance: json['initialBalance']?.toDouble() ?? 0.0,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      phoneNum: json['phoneNum'] ?? '',
      requestId: json['requestId'] ?? '',
      accountType: json['accountType'] ?? '',
      requestStatus: json['requestStatus'] ?? '',
      accCcy: json['accCcy'] ?? '',
      accoutClass: json['accoutClass'] ?? '',
      accountKitNo: json['accountKitNo'] ?? '',
      media: json['media'] ?? '',
      location: json['location'] ?? '',
      isJointAccount: json['isJointAccount'] ?? '',
      availabeBal: json['availabeBal'] ?? '',
      currentBal: json['currentBal'] ?? '',
      openingBal: json['openingBal'] ?? '',
      branch: json['branch'] ?? '',
      rmcode: json['rmcode'] ?? '',
      mobileno: json['mobileno'] ?? '',
      jointAcc: (json['jointAcc'] as List<dynamic>?)
          ?.map((item) => AbCommJointCustDetails.fromJson(item))
          .toList() ??
          [],
      custDoc: (json['custDoc'] as List<dynamic>?)
          ?.map((item) => CommCustDoc.fromJson(item))
          .toList() ??
          [],
      additionalAccountList: (json['additionalAccountList'] as List<dynamic>?)
          ?.map((item) => CommAccountRequest.fromJson(item))
          .toList() ??
          [],
      selfAccountCheck: json['selfAccountCheck'] ?? '',
      isSelected: json['isSelected'] ?? '',
      branchname: json['branchname'] ?? '',
    );
  }

  // Convert CommAccountRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo.toJson(),
      'resMessage': resMessage.toJson(),
      'customerId': customerId,
      'customerName': customerName,
      'accountNum': accountNum,
      'initialBalance': initialBalance,
      'createdDate': createdDate.toIso8601String(),
      'phoneNum': phoneNum,
      'requestId': requestId,
      'accountType': accountType,
      'requestStatus': requestStatus,
      'accCcy': accCcy,
      'accoutClass': accoutClass,
      'accountKitNo': accountKitNo,
      'media': media,
      'location': location,
      'isJointAccount': isJointAccount,
      'availabeBal': availabeBal,
      'currentBal': currentBal,
      'openingBal': openingBal,
      'branch': branch,
      'rmcode': rmcode,
      'mobileno': mobileno,
      'jointAcc': jointAcc.map((item) => item.toJson()).toList(),
      'custDoc': custDoc.map((item) => item.toJson()).toList(),
      'additionalAccountList':
      additionalAccountList.map((item) => item.toJson()).toList(),
      'selfAccountCheck': selfAccountCheck,
      'isSelected': isSelected,
      'branchname': branchname,
    };
  }
}*/

import 'AbCommJointCustDetails.dart';
import 'CommCustDoc.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommAccountRequest {
  HeaderInfo headerInfo;
  ServerMessage resMessage;

  String customerId;
  String customerName;
  String accountNum;
  double initialBalance;
  DateTime createdDate;
  String phoneNum;
  String requestId;
  String accountType;
  String requestStatus;
  String accCcy;
  String accoutClass;
  String accountKitNo;
  String media;
  String location;
  String isJointAccount;
  String availabeBal;
  String currentBal;
  String openingBal;
  String branch;
  String rmcode;
  List<AbCommJointCustDetails> jointAcc;
  List<CommCustDoc> custDoc;
  String mobileno;
  List<CommAccountRequest> additionalAccountList;
  String selfAccountCheck;
  String isSelected;
  String branchname;

  /// ✅ NEW FIELD
  String service_id;   // previously service_id in Java

  CommAccountRequest({
    ServerMessage? resMessage,
    HeaderInfo? headerInfo,
    this.customerId = '',
    this.customerName = '',
    this.accountNum = '',
    this.initialBalance = 0.0,
    DateTime? createdDate,
    this.phoneNum = '',
    this.requestId = '',
    this.accountType = '',
    this.requestStatus = '',
    this.accCcy = '',
    this.accoutClass = '',
    this.accountKitNo = '',
    this.media = '',
    this.location = '',
    this.isJointAccount = '',
    this.availabeBal = '',
    this.currentBal = '',
    this.openingBal = '',
    this.branch = '',
    this.rmcode = '',
    this.jointAcc = const [],
    this.custDoc = const [],
    this.mobileno = '',
    this.additionalAccountList = const [],
    this.selfAccountCheck = '',
    this.isSelected = '',
    this.branchname = '',

    /// ✅ NEW FIELD IN CONSTRUCTOR
    this.service_id = '',
  })  : headerInfo = headerInfo ?? HeaderInfo(),
        resMessage = resMessage ?? ServerMessage(),
        createdDate = createdDate ?? DateTime.now();

  factory CommAccountRequest.fromJson(Map<String, dynamic> json) {
    return CommAccountRequest(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      accountNum: json['accountNum'] ?? '',
      initialBalance: json['initialBalance']?.toDouble() ?? 0.0,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      phoneNum: json['phoneNum'] ?? '',
      requestId: json['requestId'] ?? '',
      accountType: json['accountType'] ?? '',
      requestStatus: json['requestStatus'] ?? '',
      accCcy: json['accCcy'] ?? '',
      accoutClass: json['accoutClass'] ?? '',
      accountKitNo: json['accountKitNo'] ?? '',
      media: json['media'] ?? '',
      location: json['location'] ?? '',
      isJointAccount: json['isJointAccount'] ?? '',
      availabeBal: json['availabeBal'] ?? '',
      currentBal: json['currentBal'] ?? '',
      openingBal: json['openingBal'] ?? '',
      branch: json['branch'] ?? '',
      rmcode: json['rmcode'] ?? '',
      mobileno: json['mobileno'] ?? '',
      jointAcc: (json['jointAcc'] as List<dynamic>?)
          ?.map((item) => AbCommJointCustDetails.fromJson(item))
          .toList() ??
          [],
      custDoc: (json['custDoc'] as List<dynamic>?)
          ?.map((item) => CommCustDoc.fromJson(item))
          .toList() ??
          [],
      additionalAccountList: (json['additionalAccountList'] as List<dynamic>?)
          ?.map((item) => CommAccountRequest.fromJson(item))
          .toList() ??
          [],

      selfAccountCheck: json['selfAccountCheck'] ?? '',
      isSelected: json['isSelected'] ?? '',
      branchname: json['branchname'] ?? '',

      /// ✅ NEW FIELD MAPPED FROM JSON
      service_id: json['service_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo.toJson(),
      'resMessage': resMessage.toJson(),
      'customerId': customerId,
      'customerName': customerName,
      'accountNum': accountNum,
      'initialBalance': initialBalance,
      'createdDate': createdDate.toIso8601String(),
      'phoneNum': phoneNum,
      'requestId': requestId,
      'accountType': accountType,
      'requestStatus': requestStatus,
      'accCcy': accCcy,
      'accoutClass': accoutClass,
      'accountKitNo': accountKitNo,
      'media': media,
      'location': location,
      'isJointAccount': isJointAccount,
      'availabeBal': availabeBal,
      'currentBal': currentBal,
      'openingBal': openingBal,
      'branch': branch,
      'rmcode': rmcode,
      'mobileno': mobileno,
      'jointAcc': jointAcc.map((e) => e.toJson()).toList(),
      'custDoc': custDoc.map((e) => e.toJson()).toList(),
      'additionalAccountList':
      additionalAccountList.map((e) => e.toJson()).toList(),
      'selfAccountCheck': selfAccountCheck,
      'isSelected': isSelected,
      'branchname': branchname,

      /// ✅ NEW FIELD INCLUDED IN JSON
      'service_id': service_id,
    };
  }
}
