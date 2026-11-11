import 'GdbLookupForm.dart';

class GdbCustRtlAddiInfoForm {
  GdbLookupForm? bankAccType;
  GdbLookupForm? existingAppCust;
  GdbLookupForm? timeWithCurrEmployer;
  GdbLookupForm? residentialStatus;
  GdbLookupForm? profession;
  GdbLookupForm? academicDeg;
  GdbLookupForm? maritalStatus;
  GdbLookupForm? levelOfEducation;
  GdbLookupForm? nationalityOrResidency;
  GdbLookupForm? noOfDependents;
  GdbLookupForm? timeAtCurrAddress;

  GdbCustRtlAddiInfoForm({
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

  factory GdbCustRtlAddiInfoForm.fromJson(Map<String, dynamic> json) {
    return GdbCustRtlAddiInfoForm(
      bankAccType: json['bankAccType'] != null
          ? GdbLookupForm.fromJson(json['bankAccType'])
          : null,
      existingAppCust: json['existingAppCust'] != null
          ? GdbLookupForm.fromJson(json['existingAppCust'])
          : null,
      timeWithCurrEmployer: json['timeWithCurrEmployer'] != null
          ? GdbLookupForm.fromJson(json['timeWithCurrEmployer'])
          : null,
      residentialStatus: json['residentialStatus'] != null
          ? GdbLookupForm.fromJson(json['residentialStatus'])
          : null,
      profession: json['profession'] != null
          ? GdbLookupForm.fromJson(json['profession'])
          : null,
      academicDeg: json['academicDeg'] != null
          ? GdbLookupForm.fromJson(json['academicDeg'])
          : null,
      maritalStatus: json['maritalStatus'] != null
          ? GdbLookupForm.fromJson(json['maritalStatus'])
          : null,
      levelOfEducation: json['levelOfEducation'] != null
          ? GdbLookupForm.fromJson(json['levelOfEducation'])
          : null,
      nationalityOrResidency: json['nationalityOrResidency'] != null
          ? GdbLookupForm.fromJson(json['nationalityOrResidency'])
          : null,
      noOfDependents: json['noOfDependents'] != null
          ? GdbLookupForm.fromJson(json['noOfDependents'])
          : null,
      timeAtCurrAddress: json['timeAtCurrAddress'] != null
          ? GdbLookupForm.fromJson(json['timeAtCurrAddress'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankAccType': bankAccType?.toJson(),
      'existingAppCust': existingAppCust?.toJson(),
      'timeWithCurrEmployer': timeWithCurrEmployer?.toJson(),
      'residentialStatus': residentialStatus?.toJson(),
      'profession': profession?.toJson(),
      'academicDeg': academicDeg?.toJson(),
      'maritalStatus': maritalStatus?.toJson(),
      'levelOfEducation': levelOfEducation?.toJson(),
      'nationalityOrResidency': nationalityOrResidency?.toJson(),
      'noOfDependents': noOfDependents?.toJson(),
      'timeAtCurrAddress': timeAtCurrAddress?.toJson(),
    };
  }
}
