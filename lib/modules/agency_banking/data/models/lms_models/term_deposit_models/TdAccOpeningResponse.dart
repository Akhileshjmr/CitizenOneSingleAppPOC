import 'TdAccNomineeResponse.dart';

class TdAccOpeningResponse {
  String? responseCode;
  String? responseMessage;
  String? tdAccNo;
  String? accountStatus;
  DateTime? bookDate;
  DateTime? maturityDate;
  double? maturityAmt;
  String? customerName;
  String? productName;
  List<TdAccNomineeResponse>? nomineeDetails;

  TdAccOpeningResponse({
    this.responseCode,
    this.responseMessage,
    this.tdAccNo,
    this.accountStatus,
    this.bookDate,
    this.maturityDate,
    this.maturityAmt,
    this.customerName,
    this.productName,
    this.nomineeDetails,
  });

  factory TdAccOpeningResponse.fromJson(Map<String, dynamic> json) {
    return TdAccOpeningResponse(
      responseCode: json['responseCode'] as String?,
      responseMessage: json['responseMessage'] as String?,
      tdAccNo: json['tdAccNo'] as String?,
      accountStatus: json['accountStatus'] as String?,
      bookDate: _parseDate(json['bookDate']),
      maturityDate: _parseDate(json['maturityDate']),
      maturityAmt: (json['maturityAmt'] as num?)?.toDouble(),
      customerName: json['customerName'] as String?,
      productName: json['productName'] as String?,
      nomineeDetails: (json['nomineeDetails'] as List<dynamic>?)
          ?.map((e) => TdAccNomineeResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'tdAccNo': tdAccNo,
      'accountStatus': accountStatus,
      'bookDate': bookDate?.toIso8601String(),
      'maturityDate': maturityDate?.toIso8601String(),
      'maturityAmt': maturityAmt,
      'customerName': customerName,
      'productName': productName,
      'nomineeDetails': nomineeDetails?.map((e) => e.toJson()).toList(),
    };
  }
}
