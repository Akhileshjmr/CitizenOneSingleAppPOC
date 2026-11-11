import 'package:intl/intl.dart';

class TdAccNomineeRequest {
  String? applicantCode;
  String? customerName;
  String? dob; // Changed from DateTime? to String?
  String? address;
  String? relationship;
  String? ifOthers;

  TdAccNomineeRequest({
    this.applicantCode,
    this.customerName,
    this.dob,
    this.address,
    this.relationship,
    this.ifOthers,
  });

  factory TdAccNomineeRequest.fromJson(Map<String, dynamic> json) {
    return TdAccNomineeRequest(
      applicantCode: json['applicantCode']?.toString(),
      customerName: json['customerName']?.toString(),
      dob: _formatDate(json['dob']),
      address: json['address']?.toString(),
      relationship: json['relationship']?.toString(),
      ifOthers: json['ifOthers']?.toString(),
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
      'applicantCode': applicantCode,
      'customerName': customerName,
      'dob': dob, // Already a string
      'address': address,
      'relationship': relationship,
      'ifOthers': ifOthers,
    };
  }
}
