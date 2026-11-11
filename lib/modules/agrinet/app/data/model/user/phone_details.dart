import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';

class PhoneDetails {
  String? areaCode;
  String? number;
  Option? phoneType;

  PhoneDetails({this.areaCode, this.number, this.phoneType});

  factory PhoneDetails.fromJson(Map<String, dynamic> json) {
    return PhoneDetails(
      areaCode: json['areaCode'],
      number: json['number'],
      phoneType:
          json['phoneType'] != null ? Option.fromJson(json['phoneType']) : null,
    );
  }
}
