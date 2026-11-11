class TdAccNomineeResponse {
  String? applicantCode;
  String? customerName;
  DateTime? dob;
  String? address;
  String? relationship;
  String? ifOthers;

  TdAccNomineeResponse({
    this.applicantCode,
    this.customerName,
    this.dob,
    this.address,
    this.relationship,
    this.ifOthers,
  });

  factory TdAccNomineeResponse.fromJson(Map<String, dynamic> json) {
    return TdAccNomineeResponse(
      applicantCode: json['applicantCode'] as String?,
      customerName: json['customerName'] as String?,
      dob: _parseDate(json['dob']),
      address: json['address'] as String?,
      relationship: json['relationship'] as String?,
      ifOthers: json['ifOthers'] as String?,
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
      'applicantCode': applicantCode,
      'customerName': customerName,
      'dob': dob?.toIso8601String(),
      'address': address,
      'relationship': relationship,
      'ifOthers': ifOthers,
    };
  }
}
