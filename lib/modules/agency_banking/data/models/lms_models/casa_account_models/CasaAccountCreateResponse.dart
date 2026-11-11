import '../../common_models/HeaderInfo.dart';
import '../../common_models/ServerMessage.dart';

class CasaAccountCreateResponse {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;
  String? responseCode;
  String? responseMessage;
  bool? accountCreated;
  int? accountId;
  String? accountNumber;
  String? accountStatus;
  DateTime? openingDate;
  double? openingBalance;

  CasaAccountCreateResponse({
    this.headerInfo,
    this.resMessage,
    this.responseCode,
    this.responseMessage,
    this.accountCreated,
    this.accountId,
    this.accountNumber,
    this.accountStatus,
    this.openingDate,
    this.openingBalance,
  });

  factory CasaAccountCreateResponse.fromJson(Map<String, dynamic> json) {
    return CasaAccountCreateResponse(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      responseCode: json['responseCode'],
      responseMessage: json['responseMessage'],
      accountCreated: json['accountCreated'],
      accountId: json['accountId'],
      accountNumber: json['accountNumber'],
      accountStatus: json['accountStatus'],
      openingDate: _parseDate(json['openingDate']),
      openingBalance: (json['openingBalance'] as num?)?.toDouble(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'accountCreated': accountCreated,
      'accountId': accountId,
      'accountNumber': accountNumber,
      'accountStatus': accountStatus,
      'openingDate': openingDate?.toIso8601String(),

      'openingBalance': openingBalance,
    };
  }
}