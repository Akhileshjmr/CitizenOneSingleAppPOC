import '../LoginUserCashInfo.dart';
import '../common_models/ChanneCustInfo.dart';
import 'TenantDetails.dart';

class LoginUserInfo {
  String? userCode;

  String? userName;

  String? deviceID;

  String? password;

  String? newPassword;

  String? passwordPolicy;

  String? defaultCountry;

  String? defaultBranch;

  String? defaultCurrency;

  String? firsttimelogin;

  String? rolesList;

  String? gender;

  DateTime? dob;

  String? locationCode;

  String? authStatus;

  String? lang;

  String? lastName;

  String? firstName;

  String? userType;

  ChanneCustInfo? channeCustInfo;

  LoginUserCashInfo? loginUserCashInfo;

  String? imagePath;

  String? lastLoginStamp;

  String? blockType;

  int? mPin;

  String? usertype;

  // Changed from Long to String in Java on 28_09_26

  String? mobileno;

  Map<String, dynamic>? permission;

  List<int>? qrcodeImage;

  String language = '';

  String? wallet_acc_no;

  String? cbs_acc_no;

  double walletBalance = 0.0;

  double cbsBalance = 0.0;

  String? defaultISDCode;

  String? latitude;

  String? longitude;

  List<TenantDetails>? tenantDetails;

  String jwtToken = '';

  LoginUserInfo({
    this.userCode,
    this.userName,
    this.deviceID,
    this.password,
    this.newPassword,
    this.passwordPolicy,
    this.defaultCountry,
    this.defaultBranch,
    this.defaultCurrency,
    this.firsttimelogin,
    this.rolesList,
    this.gender,
    this.dob,
    this.locationCode,
    this.authStatus,
    this.lang,
    this.lastName,
    this.firstName,
    this.userType,
    this.channeCustInfo,
    this.loginUserCashInfo,
    this.imagePath,
    this.lastLoginStamp,
    this.blockType,
    this.mPin,
    this.usertype,
    this.mobileno,
    this.permission,
    this.qrcodeImage,
    this.language = '',
    this.wallet_acc_no,
    this.cbs_acc_no,
    this.walletBalance = 0.0,
    this.cbsBalance = 0.0,
    this.defaultISDCode,
    this.latitude,
    this.longitude,
    this.tenantDetails,
    this.jwtToken = '',
  });

  factory LoginUserInfo.fromJson(Map<String, dynamic> json) {
    return LoginUserInfo(
      userCode: json['userCode'],

      userName: json['userName'],

      deviceID: json['deviceID'],

      password: json['password'],

      newPassword: json['newPassword'],

      passwordPolicy: json['passwordPolicy'],

      defaultCountry: json['defaultCountry'],

      defaultBranch: json['defaultBranch'],

      defaultCurrency: json['defaultCurrency'],

      firsttimelogin: json['firsttimelogin'],

      rolesList: json['rolesList'],

      gender: json['gender'],

      dob: json['dob'] != null
          ? DateTime.tryParse(json['dob'].toString())
          : null,

      locationCode: json['locationCode'],

      authStatus: json['authStatus'],

      lang: json['lang'],

      lastName: json['lastName'],

      firstName: json['firstName'],

      userType: json['userType'],

      channeCustInfo: json['channeCustInfo'] != null
          ? ChanneCustInfo.fromJson(
              Map<String, dynamic>.from(json['channeCustInfo']),
            )
          : null,

      loginUserCashInfo: json['loginUserCashInfo'] != null
          ? LoginUserCashInfo.fromJson(
              Map<String, dynamic>.from(json['loginUserCashInfo']),
            )
          : null,

      imagePath: json['imagePath'],

      lastLoginStamp: json['lastLoginStamp'],

      blockType: json['blockType'],

      mPin: json['mPin'] != null ? int.tryParse(json['mPin'].toString()) : null,

      usertype: json['usertype'],

      // Important: mobile number is String

      mobileno: json['mobileno']?.toString(),

      permission: json['permission'] != null
          ? Map<String, dynamic>.from(json['permission'])
          : null,

      qrcodeImage: json['qrcodeImage'] != null
          ? List<int>.from(json['qrcodeImage'])
          : null,

      language: json['language']?.toString() ?? '',

      wallet_acc_no: json['wallet_acc_no'],

      cbs_acc_no: json['cbs_acc_no'],

      walletBalance: _toDouble(json['walletBalance']),

      cbsBalance: _toDouble(json['cbsBalance']),

      defaultISDCode: json['defaultISDCode'],

      latitude: json['latitude'],

      longitude: json['longitude'],

      tenantDetails: json['tenantDetails'] != null
          ? (json['tenantDetails'] as List)
              .map(
                (e) => TenantDetails.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : null,

      jwtToken: json['jwtToken']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userCode': userCode,
      'userName': userName,
      'deviceID': deviceID,
      'password': password,
      'newPassword': newPassword,
      'passwordPolicy': passwordPolicy,
      'defaultCountry': defaultCountry,
      'defaultBranch': defaultBranch,
      'defaultCurrency': defaultCurrency,
      'firsttimelogin': firsttimelogin,
      'rolesList': rolesList,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'locationCode': locationCode,
      'authStatus': authStatus,
      'lang': lang,
      'lastName': lastName,
      'firstName': firstName,
      'userType': userType,
      'channeCustInfo': channeCustInfo?.toJson(),
      'loginUserCashInfo': loginUserCashInfo?.toJson(),
      'imagePath': imagePath,
      'lastLoginStamp': lastLoginStamp,
      'blockType': blockType,
      'mPin': mPin,
      'usertype': usertype,
      'mobileno': mobileno,
      'permission': permission,
      'qrcodeImage': qrcodeImage,
      'language': language,
      'wallet_acc_no': wallet_acc_no,
      'cbs_acc_no': cbs_acc_no,
      'walletBalance': walletBalance,
      'cbsBalance': cbsBalance,
      'defaultISDCode': defaultISDCode,
      'latitude': latitude,
      'longitude': longitude,
      'tenantDetails': tenantDetails?.map((e) => e.toJson()).toList(),
      'jwtToken': jwtToken,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) return value;

    if (value is int) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0.0;
  }
}
