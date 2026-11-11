import 'AbCommJntAccDetails.dart';
import 'CommCustDoc.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommWalletAccountRequest {
  HeaderInfo headerInfo;
  ServerMessage resMessage;
  String customerId;
  String customerName;
  String accountNum;
  double initialBalance;
  DateTime? createdDate;  // Made nullable
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
  String branch;
  String rmcode;
  List<AbCommJntAccDetails> jointAcc;
  List<CommCustDoc> custDoc;
  String mobileno;
  String selfAccountCheck;
  String moduleCode;
  String custType;
  String isSelected;
  List<CommWalletAccountRequest> additionalAccountList;

  // Constructor
  CommWalletAccountRequest({
    ServerMessage? resMessage,
    HeaderInfo? headerInfo,
    this.customerId = '',
    this.customerName = '',
    this.accountNum = '',
    this.initialBalance = 0.0,
    this.createdDate,  // No longer required, made optional
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
    this.branch = '',
    this.rmcode = '',
    List<AbCommJntAccDetails>? jointAcc,
    List<CommCustDoc>? custDoc,
    this.mobileno = '',
    this.selfAccountCheck = '',
    this.moduleCode = '',
    this.custType = '',
    this.isSelected = '',
    List<CommWalletAccountRequest>? additionalAccountList,
  })  : jointAcc = jointAcc ?? [],  // Initialize to empty list if null
        custDoc = custDoc ?? [],    // Initialize to empty list if null
        additionalAccountList = additionalAccountList ?? [],  // Empty list if null
        headerInfo = headerInfo ?? HeaderInfo(),
        resMessage = resMessage ?? ServerMessage();

  // Factory method to create an instance from JSON
  factory CommWalletAccountRequest.fromJson(Map<String, dynamic> json) {
    return CommWalletAccountRequest(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      accountNum: json['accountNum'] ?? '',
      initialBalance: json['initialBalance']?.toDouble() ?? 0.0,
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null, // Parse if exists
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
      branch: json['branch'] ?? '',
      rmcode: json['rmcode'] ?? '',
      jointAcc: (json['jointAcc'] as List<dynamic>?)
          ?.map((item) => AbCommJntAccDetails.fromJson(item))
          .toList() ?? [],
      custDoc: (json['custDoc'] as List<dynamic>?)
          ?.map((item) => CommCustDoc.fromJson(item))
          .toList() ?? [],
      mobileno: json['mobileno'] ?? '',
      selfAccountCheck: json['selfAccountCheck'] ?? '',
      moduleCode: json['moduleCode'] ?? '',
      custType: json['custType'] ?? '',
      isSelected: json['isSelected'] ?? '',
      additionalAccountList: (json['additionalAccountList'] as List<dynamic>?)
          ?.map((item) => CommWalletAccountRequest.fromJson(item))
          .toList() ?? [],
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo.toJson(),
      'resMessage': resMessage.toJson(),
      'customerId': customerId,
      'customerName': customerName,
      'accountNum': accountNum,
      'initialBalance': initialBalance,
      'createdDate': createdDate?.toIso8601String(),  // Handle nullable DateTime
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
      'branch': branch,
      'rmcode': rmcode,
      'jointAcc': jointAcc.map((item) => item.toJson()).toList(),
      'custDoc': custDoc.map((item) => item.toJson()).toList(),
      'mobileno': mobileno,
      'selfAccountCheck': selfAccountCheck,
      'moduleCode': moduleCode,
      'custType': custType,
      'isSelected': isSelected,
      'additionalAccountList': additionalAccountList.map((item) => item.toJson()).toList(),
    };
  }
}