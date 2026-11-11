import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class LoginQRImage {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? merchantCode;
  String? merchantUniqueId;
  String? userMob;
  String? qrcodeImage;

  // Constructor
  LoginQRImage({
    this.headerInfo,
    this.resMessage,
    this.merchantCode,
    this.merchantUniqueId,
    this.userMob,
    this.qrcodeImage,
  });

  // Factory method to create an instance from a JSON object
  factory LoginQRImage.fromJson(Map<String, dynamic> json) {
    return LoginQRImage(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      merchantCode: json['merchant_code'] ?? '',
      merchantUniqueId: json['merchant_unique_id'] ?? '',
      userMob: json['user_mob'] ?? '',
      qrcodeImage: json['qrcodeImage'] ?? '',
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'merchant_code': merchantCode,
      'merchant_unique_id': merchantUniqueId,
      'user_mob': userMob,
      'qrcodeImage': qrcodeImage,
    };
  }
}
