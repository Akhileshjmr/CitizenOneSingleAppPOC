class LoginUserCashInfo {
  int? id;
  String openingBal;
  String closingBal;
  String cashLimit;
  String accNum;
  DateTime? cashDate;

  // Constructor
  LoginUserCashInfo({
    this.id,
    String? openingBal,
    String? closingBal,
    String? cashLimit,
    String? accNum,
    this.cashDate,
  })  : openingBal = openingBal ?? '',
        closingBal = closingBal ?? '',
        cashLimit = cashLimit ?? '',
        accNum = accNum ?? '';

  // Factory method to create an instance from JSON
  factory LoginUserCashInfo.fromJson(Map<String, dynamic> json) {
    return LoginUserCashInfo(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      openingBal: json['openingBal']?.toString() ?? '',
      closingBal: json['closingBal']?.toString() ?? '',
      cashLimit: json['cashLimit']?.toString() ?? '',
      accNum: json['accNum']?.toString() ?? '',
      cashDate: json['cashDate'] != null
          ? DateTime.tryParse(json['cashDate'].toString())
          : null,
    );
  }

  // Method to convert instance to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'openingBal': openingBal,
      'closingBal': closingBal,
      'cashLimit': cashLimit,
      'accNum': accNum,
      'cashDate': cashDate?.toIso8601String(),
    };
  }
}
