import 'National.dart';
import 'CntryOfBirth.dart';
import 'Language.dart';

class GenDet {
  GenDet({
      this.fullName, 
      this.pNumber, 
      this.passportType, 
      this.passportDoe, 
      this.nationalIdNo, 
      this.nationalIdDoe, 
      this.firstName, 
      this.middleName, 
      this.lastName, 
      this.dob, 
      this.address, 
      this.email, 
      this.gender, 
      this.maritalStatus, 
      this.isEgyptian, 
      this.nationality, 
      this.national, 
      this.cntryOfBirth, 
      this.language, 
      this.emiratesId, 
      this.uaeResidenceVisaNo, 
      this.title,});

  GenDet.fromJson(dynamic json) {
    fullName = json['fullName'];
    pNumber = json['pNumber'];
    passportType = json['passportType'];
    passportDoe = json['passportDoe'];
    nationalIdNo = json['nationalIdNo'];
    nationalIdDoe = json['nationalIdDoe'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    dob = json['dob'];
    address = json['address'];
    email = json['email'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'];
    isEgyptian = json['isEgyptian'];
    nationality = json['nationality'];
    national = json['national'] != null ? National.fromJson(json['national']) : null;
    cntryOfBirth = json['cntryOfBirth'] != null ? CntryOfBirth.fromJson(json['cntryOfBirth']) : null;
    language = json['language'] != null ? Language.fromJson(json['language']) : null;
    emiratesId = json['emiratesId'];
    uaeResidenceVisaNo = json['uaeResidenceVisaNo'];
    title = json['title'];
  }
  String? fullName;
  String? pNumber;
  dynamic passportType;
  dynamic passportDoe;
  String? nationalIdNo;
  String? nationalIdDoe;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  dynamic address;
  dynamic email;
  dynamic gender;
  dynamic maritalStatus;
  bool? isEgyptian;
  dynamic nationality;
  National? national;
  CntryOfBirth? cntryOfBirth;
  Language? language;
  dynamic emiratesId;
  dynamic uaeResidenceVisaNo;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['pNumber'] = pNumber;
    map['passportType'] = passportType;
    map['passportDoe'] = passportDoe;
    map['nationalIdNo'] = nationalIdNo;
    map['nationalIdDoe'] = nationalIdDoe;
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['dob'] = dob;
    map['address'] = address;
    map['email'] = email;
    map['gender'] = gender;
    map['maritalStatus'] = maritalStatus;
    map['isEgyptian'] = isEgyptian;
    map['nationality'] = nationality;
    if (national != null) {
      map['national'] = national?.toJson();
    }
    if (cntryOfBirth != null) {
      map['cntryOfBirth'] = cntryOfBirth?.toJson();
    }
    if (language != null) {
      map['language'] = language?.toJson();
    }
    map['emiratesId'] = emiratesId;
    map['uaeResidenceVisaNo'] = uaeResidenceVisaNo;
    map['title'] = title;
    return map;
  }

}