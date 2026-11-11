import '../common_models/HeaderInfo.dart';

class AbAgentForgetChangePwd {
  HeaderInfo headerInfo = HeaderInfo();
  String userName = "";
  String status = "";
  String newPwd = "";
  String pwd = "";
  String confPword = "";
  String agentCode = "";
  String deviceId = "";
  String otp = "";
  String email = "";
  String ph_no = "";

  // Constructor
  AbAgentForgetChangePwd({
    required this.headerInfo,
    required this.userName,
    required this.status,
    required this.newPwd,
    required this.pwd,
    required this.confPword,
    required this.agentCode,
    required this.deviceId,
    required this.otp,
    required this.email,
    required this.ph_no,
  });

  // Factory method to create an instance from JSON
  factory AbAgentForgetChangePwd.fromJson(Map<String, dynamic> json) {
    return AbAgentForgetChangePwd(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      userName: json['userName'] ?? '',
      status: json['status'] ?? '',
      newPwd: json['newPwd'] ?? '',
      pwd: json['pwd'] ?? '',
      confPword: json['confPword'] ?? '',
      agentCode: json['agentCode'] ?? '',
      deviceId: json['deviceId'] ?? '',
      otp: json['otp'] ?? '',
      email: json['email'] ?? '',
      ph_no: json['ph_no'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo.toJson(),
      'userName': userName,
      'status': status,
      'newPwd': newPwd,
      'pwd': pwd,
      'confPword': confPword,
      'agentCode': agentCode,
      'deviceId': deviceId,
      'otp': otp,
      'email': email,
      'ph_no': ph_no,
    };
  }
}