import 'AcademicDeg.dart';
import 'BankAccType.dart';
import 'ExistingAppCust.dart';
import 'LevelOfEducation.dart';
import 'MaritalStatus.dart';
import 'NationalityOrResidency.dart';
import 'NoOfDependents.dart';
import 'Profession.dart';
import 'ResidentialStatus.dart';
import 'TimeAtCurrAddress.dart';
import 'TimeWithCurrEmployer.dart';

class AddiDet {
  AddiDet({
    this.bankAccType,
    this.existingAppCust,
    this.timeWithCurrEmployer,
    this.residentialStatus,
    this.profession,
    this.academicDeg,
    this.maritalStatus,
    this.levelOfEducation,
    this.nationalityOrResidency,
    this.noOfDependents,
    this.timeAtCurrAddress,
  });

  AddiDet.fromJson(dynamic json) {
    bankAccType =
        json['bankAccType'] != null
            ? BankAccType.fromJson(json['existingAppCust'])
            : null;
    existingAppCust =
        json['existingAppCust'] != null
            ? ExistingAppCust.fromJson(json['existingAppCust'])
            : null;
    timeWithCurrEmployer =
        json['timeWithCurrEmployer'] != null
            ? TimeWithCurrEmployer.fromJson(json['timeWithCurrEmployer'])
            : null;
    residentialStatus =
        json['residentialStatus'] != null
            ? ResidentialStatus.fromJson(json['residentialStatus'])
            : null;
    profession =
        json['profession'] != null
            ? Profession.fromJson(json['academicDeg'])
            : null;
    academicDeg =
        json['academicDeg'] != null
            ? AcademicDeg.fromJson(json['academicDeg'])
            : null;
    maritalStatus =
        json['maritalStatus'] != null
            ? MaritalStatus.fromJson(json['maritalStatus'])
            : null;
    levelOfEducation =
        json['levelOfEducation'] != null
            ? LevelOfEducation.fromJson(json['levelOfEducation'])
            : null;
    nationalityOrResidency =
        json['nationalityOrResidency'] != null
            ? NationalityOrResidency.fromJson(json['nationalityOrResidency'])
            : null;
    noOfDependents =
        json['noOfDependents'] != null
            ? NoOfDependents.fromJson(json['noOfDependents'])
            : null;
    timeAtCurrAddress =
        json['timeAtCurrAddress'] != null
            ? TimeAtCurrAddress.fromJson(json['timeAtCurrAddress'])
            : null;
  }
  BankAccType? bankAccType;
  ExistingAppCust? existingAppCust;
  TimeWithCurrEmployer? timeWithCurrEmployer;
  ResidentialStatus? residentialStatus;
  Profession? profession;
  AcademicDeg? academicDeg;
  MaritalStatus? maritalStatus;
  LevelOfEducation? levelOfEducation;
  NationalityOrResidency? nationalityOrResidency;
  NoOfDependents? noOfDependents;
  TimeAtCurrAddress? timeAtCurrAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bankAccType != null) {
      map['bankAccType'] = bankAccType?.toJson();
    }
    if (existingAppCust != null) {
      map['existingAppCust'] = existingAppCust?.toJson();
    }
    if (timeWithCurrEmployer != null) {
      map['timeWithCurrEmployer'] = timeWithCurrEmployer?.toJson();
    }
    if (residentialStatus != null) {
      map['residentialStatus'] = residentialStatus?.toJson();
    }
    if (profession != null) {
      map['profession'] = profession?.toJson();
    }
    if (academicDeg != null) {
      map['academicDeg'] = academicDeg?.toJson();
    }
    if (maritalStatus != null) {
      map['maritalStatus'] = maritalStatus?.toJson();
    }
    if (levelOfEducation != null) {
      map['levelOfEducation'] = levelOfEducation?.toJson();
    }
    if (nationalityOrResidency != null) {
      map['nationalityOrResidency'] = nationalityOrResidency?.toJson();
    }
    if (noOfDependents != null) {
      map['noOfDependents'] = noOfDependents?.toJson();
    }
    if (timeAtCurrAddress != null) {
      map['timeAtCurrAddress'] = timeAtCurrAddress?.toJson();
    }
    return map;
  }
}
