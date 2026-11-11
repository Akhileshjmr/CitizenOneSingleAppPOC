import 'package:intl/intl.dart';

import 'TdAccNomineeRequest.dart';

class TdAccOpeningRequest {
  String? custType;
  String? customerCode;
  String? productCode;
  String? accountNumber;
  String? bookedBy;
  String? valueDate; // Changed from DateTime? to String?
  double? initDepositAmt;
  double? spreadVrble;
  String? maturityInstrctns;
  String? intrPaymentType;
  bool? nominee;
  bool? existNominee;
  List<TdAccNomineeRequest>? nomineeDetails;

  TdAccOpeningRequest({
    this.custType,
    this.customerCode,
    this.productCode,
    this.accountNumber,
    this.bookedBy,
    this.valueDate,
    this.initDepositAmt,
    this.spreadVrble,
    this.maturityInstrctns,
    this.intrPaymentType,
    this.nominee,
    this.existNominee,
    this.nomineeDetails,
  });

  factory TdAccOpeningRequest.fromJson(Map<String, dynamic> json) {
    return TdAccOpeningRequest(
      custType: json['custType'] as String?,
      customerCode: json['customerCode'] as String?,
      productCode: json['productCode'] as String?,
      accountNumber: json['accountNumber'] as String?,
      bookedBy: json['bookedBy'] as String?,
      valueDate: _formatDate(json['valueDate']),
      initDepositAmt: (json['initDepositAmt'] as num?)?.toDouble(),
      spreadVrble: (json['spreadVrble'] as num?)?.toDouble(),
      maturityInstrctns: json['maturityInstrctns'] as String?,
      intrPaymentType: json['intrPaymentType'] as String?,
      nominee: json['nominee'] as bool?,
      existNominee: json['existNominee'] as bool?,
      nomineeDetails: (json['nomineeDetails'] as List<dynamic>?)
          ?.map((e) => TdAccNomineeRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static String? _formatDate(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return DateFormat('yyyy-MM-dd')
          .format(DateTime.fromMillisecondsSinceEpoch(value));
    }
    if (value is String) {
      try {
        return DateFormat('yyyy-MM-dd').format(DateTime.parse(value));
      } catch (_) {
        return value;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'custType': custType,
      'customerCode': customerCode,
      'productCode': productCode,
      'accountNumber': accountNumber,
      'bookedBy': bookedBy,
      'valueDate': valueDate, // Already a string
      'initDepositAmt': initDepositAmt,
      'spreadVrble': spreadVrble,
      'maturityInstrctns': maturityInstrctns,
      'intrPaymentType': intrPaymentType,
      'nominee': nominee,
      'existNominee': existNominee,
      'nomineeDetails': nomineeDetails?.map((e) => e?.toJson()).toList(),
    };
  }
}
