import '../common_models/HeaderInfo.dart';
import '../common_models/ServerMessage.dart';

class UserOTPValidationInfo {
  String accountNo;
  String customerNo;
  HeaderInfo headerInfo;
  String mobileNo;
  String? otp;
  int? otpfailedattempts;
  int? otpmaxattempts;
  String? otpuniqueid;
  String? otpvalidty; // As per the request spelling
  ServerMessage resMessage;
  String userName;

  // Constructor
  UserOTPValidationInfo({
    this.accountNo = "",
    this.customerNo = "",
    HeaderInfo? headerInfo,
    this.mobileNo = "",
    this.otp,
    this.otpfailedattempts,
    this.otpmaxattempts,
    this.otpuniqueid,
    this.otpvalidty, // Matches the request spelling
    ServerMessage? resMessage,
    this.userName = "",
  })  : headerInfo = headerInfo ?? HeaderInfo(),
        resMessage = resMessage ?? ServerMessage();

  // Factory method to create an instance from JSON
  factory UserOTPValidationInfo.fromJson(Map<String, dynamic> json) {
    return UserOTPValidationInfo(
      accountNo: json['accountNo'] ?? '',
      customerNo: json['customerNo'] ?? '',
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      mobileNo: json['mobileNo'] ?? '',
      otp: json['otp'],
      otpfailedattempts: json['otpfailedattempts'],
      otpmaxattempts: json['otpmaxattempts'],
      otpuniqueid: json['otpuniqueid'],
      otpvalidty: json['otpvalidty'], // Matches the request spelling
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      userName: json['userName'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'accountNo': accountNo,
      'customerNo': customerNo,
      'headerInfo': headerInfo.toJson(),
      'mobileNo': mobileNo,
      'otp': otp,
      'otpfailedattempts': otpfailedattempts,
      'otpmaxattempts': otpmaxattempts,
      'otpuniqueid': otpuniqueid,
      'otpvalidty': otpvalidty, // Matches the request spelling
      'resMessage': resMessage.toJson(),
      'userName': userName,
    };
  }
}
