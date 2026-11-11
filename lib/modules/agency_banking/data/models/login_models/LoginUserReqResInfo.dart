import '../common_models/HeaderInfo.dart';
import 'LoginUserInfo.dart';
import '../common_models/ServerMessage.dart';

class LoginUserReqResInfo {
  HeaderInfo _headerInfo;
  LoginUserInfo _loginUserInfo;
  ServerMessage _resMessage;

  // Constructor
  LoginUserReqResInfo({
    HeaderInfo? headerInfo,
    LoginUserInfo? loginUserInfo,
    ServerMessage? resMessage,
  })  : _headerInfo = headerInfo ?? HeaderInfo(),
        _loginUserInfo = loginUserInfo ?? LoginUserInfo(),
        _resMessage = resMessage ?? ServerMessage();

  // Getters
  HeaderInfo get headerInfo => _headerInfo;
  LoginUserInfo get loginUserInfo => _loginUserInfo;
  ServerMessage get resMessage => _resMessage;

  // Setters
  set headerInfo(HeaderInfo value) => _headerInfo = value;
  set loginUserInfo(LoginUserInfo value) => _loginUserInfo = value;
  set resMessage(ServerMessage value) => _resMessage = value;

  // Factory method to create an instance from JSON
  factory LoginUserReqResInfo.fromJson(Map<String, dynamic> json) {
    return LoginUserReqResInfo(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : HeaderInfo(),
      loginUserInfo: json['loginUserInfo'] != null
          ? LoginUserInfo.fromJson(json['loginUserInfo'])
          : LoginUserInfo(),
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
    );
  }
  // Method to convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': _headerInfo.toJson(),
      'loginUserInfo': _loginUserInfo.toJson(),
      'resMessage': _resMessage.toJson(),
    };
  }
}
