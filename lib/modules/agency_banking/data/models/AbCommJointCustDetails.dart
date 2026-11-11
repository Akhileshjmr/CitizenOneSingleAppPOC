import 'dart:convert';

class AbCommJointCustDetails {
  String? _jFirstName;
  String? _jMidName;
  String? _jLastName;
  DateTime? _jDob;
  String? _jntCustGender;
  String? _jAddr1;
  String? _jAddr2;
  String? _jAddr3;

  // Constructor
  AbCommJointCustDetails({
    String? jFirstName,
    String? jMidName,
    String? jLastName,
    DateTime? jDob,
    String? jntCustGender,
    String? jAddr1,
    String? jAddr2,
    String? jAddr3,
  })  : _jFirstName = jFirstName,
        _jMidName = jMidName,
        _jLastName = jLastName,
        _jDob = jDob,
        _jntCustGender = jntCustGender,
        _jAddr1 = jAddr1,
        _jAddr2 = jAddr2,
        _jAddr3 = jAddr3;

  // Getters and Setters
  String? get jFirstName => _jFirstName;
  set jFirstName(String? value) => _jFirstName = value;

  String? get jMidName => _jMidName;
  set jMidName(String? value) => _jMidName = value;

  String? get jLastName => _jLastName;
  set jLastName(String? value) => _jLastName = value;

  DateTime? get jDob => _jDob;
  set jDob(DateTime? value) => _jDob = value;

  String? get jntCustGender => _jntCustGender;
  set jntCustGender(String? value) => _jntCustGender = value;

  String? get jAddr1 => _jAddr1;
  set jAddr1(String? value) => _jAddr1 = value;

  String? get jAddr2 => _jAddr2;
  set jAddr2(String? value) => _jAddr2 = value;

  String? get jAddr3 => _jAddr3;
  set jAddr3(String? value) => _jAddr3 = value;

  // Factory method to create an instance from JSON
  factory AbCommJointCustDetails.fromJson(Map<String, dynamic> json) {
    return AbCommJointCustDetails(
      jFirstName: json['jFirstName'] as String?,
      jMidName: json['jMidName'] as String?,
      jLastName: json['jLastName'] as String?,
      jDob: json['jDob'] != null ? DateTime.parse(json['jDob']) : null,
      jntCustGender: json['jntCustGender'] as String?,
      jAddr1: json['jAddr1'] as String?,
      jAddr2: json['jAddr2'] as String?,
      jAddr3: json['jAddr3'] as String?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'jFirstName': _jFirstName,
      'jMidName': _jMidName,
      'jLastName': _jLastName,
      'jDob': _jDob?.toIso8601String(),
      'jntCustGender': _jntCustGender,
      'jAddr1': _jAddr1,
      'jAddr2': _jAddr2,
      'jAddr3': _jAddr3,
    };
  }
}