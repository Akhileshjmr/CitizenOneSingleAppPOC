import 'GdbLookupForm.dart';

class GdbCustAddressForm {
  String? addressLine;
  String? phNum;
  String? emailAddress;
  String? mapLoc;
  String? emerContactPerson;
  String? emerContactPhNum;
  GdbLookupForm? city;
  GdbLookupForm? area;
  String? buildingNo;
  String? floorNumber;
  String? distictName;
  String? flatNumber;
  String? streatNumber;

  GdbCustAddressForm({
    this.addressLine,
    this.phNum,
    this.emailAddress,
    this.mapLoc,
    this.emerContactPerson,
    this.emerContactPhNum,
    this.city,
    this.area,
    this.buildingNo,
    this.floorNumber,
    this.distictName,
    this.flatNumber,
    this.streatNumber,
  });

  factory GdbCustAddressForm.fromJson(Map<String, dynamic> json) {
    return GdbCustAddressForm(
      addressLine: json['addressLine'],
      phNum: json['phNum'],
      emailAddress: json['emailAddress'],
      mapLoc: json['mapLoc'],
      emerContactPerson: json['emerContactPerson'],
      emerContactPhNum: json['emerContactPhNum'],
      city: json['city'] != null ? GdbLookupForm.fromJson(json['city']) : null,
      area: json['area'] != null ? GdbLookupForm.fromJson(json['area']) : null,
      buildingNo: json['buildingNo'],
      floorNumber: json['floorNumber'],
      distictName: json['distictName'],
      flatNumber: json['flatNumber'],
      streatNumber: json['streatNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine': addressLine,
      'phNum': phNum,
      'emailAddress': emailAddress,
      'mapLoc': mapLoc,
      'emerContactPerson': emerContactPerson,
      'emerContactPhNum': emerContactPhNum,
      'city': city?.toJson(),
      'area': area?.toJson(),
      'buildingNo': buildingNo,
      'floorNumber': floorNumber,
      'distictName': distictName,
      'flatNumber': flatNumber,
      'streatNumber': streatNumber,
    };
  }
}
