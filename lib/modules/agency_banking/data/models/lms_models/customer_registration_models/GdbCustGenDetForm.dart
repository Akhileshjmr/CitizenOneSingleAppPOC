import 'GdbLookupForm.dart';

class GdbCustGenDetForm {
  String? dob;
  String? gender;
  String? fullName;
  String? pNumber;
  String? passportType;
  String? passportDoe;
  String? nationalIdNo;
  String? nationalIdDoe;
  String? firstName;
  String? middleName;
  String? lastName;
  String? emailAddress;
  bool isEgyptian;
  GdbLookupForm? nationality;

  GdbCustGenDetForm({
    this.dob,
    this.gender,
    this.fullName,
    this.pNumber,
    this.passportType,
    this.passportDoe,
    this.nationalIdNo,
    this.nationalIdDoe,
    this.firstName,
    this.middleName,
    this.lastName,
    this.emailAddress,
    this.isEgyptian = false,
    this.nationality,
  });

  factory GdbCustGenDetForm.fromJson(Map<String, dynamic> json) {
    return GdbCustGenDetForm(
      dob: json['dob'],
      gender: json['gender'],
      fullName: json['fullName'],
      pNumber: json['pNumber'],
      passportType: json['passportType'],
      passportDoe: json['passportDoe'],
      nationalIdNo: json['nationalIdNo'],
      nationalIdDoe: json['nationalIdDoe'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      emailAddress: json['emailAddress'],
      isEgyptian: json['isEgyptian'] ?? false,
      nationality: json['nationality'] != null
          ? GdbLookupForm.fromJson(json['nationality'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dob': dob,
      'gender': gender,
      'fullName': fullName,
      'pNumber': pNumber,
      'passportType': passportType,
      'passportDoe': passportDoe,
      'nationalIdNo': nationalIdNo,
      'nationalIdDoe': nationalIdDoe,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'isEgyptian': isEgyptian,
      'nationality': nationality?.toJson(),
    };
  }
}
