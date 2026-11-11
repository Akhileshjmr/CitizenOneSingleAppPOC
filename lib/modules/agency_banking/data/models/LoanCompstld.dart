import 'dart:convert';

class LoanCompstld {
  String? compName;
  String? comoccyeqv;

  // Constructor
  LoanCompstld({
    this.compName,
    this.comoccyeqv,
  });

  // Factory method to create an instance from JSON
  factory LoanCompstld.fromJson(Map<String, dynamic> json) {
    return LoanCompstld(
      compName: json['compName'] as String?,
      comoccyeqv: json['comoccyeqv'] as String?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'compName': compName,
      'comoccyeqv': comoccyeqv,
    };
  }

  // Convenience method to convert an object to a JSON string
  String toJsonString() => jsonEncode(toJson());

  // Convenience method to create an object from a JSON string
  factory LoanCompstld.fromJsonString(String jsonString) =>
      LoanCompstld.fromJson(jsonDecode(jsonString));
}
