import 'LevelOfEducation.dart';
import 'MaritalStatus.dart';
import 'Nationality.dart';
import 'Birthday.dart';
import 'Anniversary.dart';
import 'CountryOfBirth.dart';

class PersonalDet {
  PersonalDet({
      this.fullName, 
      this.pNumber, 
      this.passportType, 
      this.levelOfEducation, 
      this.expiryDate, 
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
      this.nationality, 
      this.national, 
      this.language, 
      this.emiratesId, 
      this.uaeResidenceVisaNo, 
      this.title, 
      this.lastUpdatedDate, 
      this.facematchPercentage, 
      this.livelinessPercentage, 
      this.birthday, 
      this.anniversary, 
      this.preApprovedRefNum, 
      this.preApprovedAmt, 
      this.preApprovedBankId, 
      this.noOfDependents, 
      this.countryOfBirth, 
      this.dateSinceInUAE, 
      this.passportNum, 
      this.passportExpDate, 
      this.egyptian,});

  PersonalDet.fromJson(dynamic json) {
    fullName = json['fullName'];
    pNumber = json['pNumber'];
    passportType = json['passportType'];
    levelOfEducation = json['levelOfEducation'] != null ? LevelOfEducation.fromJson(json['levelOfEducation']) : null;
    expiryDate = json['expiryDate'];
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
    maritalStatus = json['maritalStatus'] != null ? MaritalStatus.fromJson(json['maritalStatus']) : null;
    nationality = json['nationality'] != null ? Nationality.fromJson(json['nationality']) : null;
    national = json['national'];
    language = json['language'];
    emiratesId = json['emiratesId'];
    uaeResidenceVisaNo = json['uaeResidenceVisaNo'];
    title = json['title'];
    // lastUpdatedDate = json['lastUpdatedDate'];
    facematchPercentage = json['facematchPercentage'];
    livelinessPercentage = json['livelinessPercentage'];
    birthday = json['birthday'] != null ? Birthday.fromJson(json['birthday']) : null;
    anniversary = json['anniversary'] != null ? Anniversary.fromJson(json['anniversary']) : null;
    preApprovedRefNum = json['preApprovedRefNum'];
    preApprovedAmt = json['preApprovedAmt'];
    preApprovedBankId = json['preApprovedBankId'];
    noOfDependents = json['noOfDependents'];
    countryOfBirth = json['countryOfBirth'] != null ? CountryOfBirth.fromJson(json['countryOfBirth']) : null;
    dateSinceInUAE = json['dateSinceInUAE'];
    passportNum = json['passportNum'];
    passportExpDate = json['passportExpDate'];
    egyptian = json['egyptian'];
  }
  String? fullName;
  String? pNumber;
  dynamic passportType;
  LevelOfEducation? levelOfEducation;
  String? expiryDate;
  String? passportDoe;
  dynamic nationalIdNo;
  dynamic nationalIdDoe;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  dynamic address;
  String? email;
  String? gender;
  MaritalStatus? maritalStatus;
  Nationality? nationality;
  dynamic national;
  dynamic language;
  String? emiratesId;
  dynamic uaeResidenceVisaNo;
  String? title;
  String? lastUpdatedDate;
  double? facematchPercentage;
  double? livelinessPercentage;
  Birthday? birthday;
  Anniversary? anniversary;
  dynamic preApprovedRefNum;
  dynamic preApprovedAmt;
  dynamic preApprovedBankId;
  String? noOfDependents;
  CountryOfBirth? countryOfBirth;
  String? dateSinceInUAE;
  String? passportNum;
  String? passportExpDate;
  bool? egyptian;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['pNumber'] = pNumber;
    map['passportType'] = passportType;
    if (levelOfEducation != null) {
      map['levelOfEducation'] = levelOfEducation?.toJson();
    }
    map['expiryDate'] = expiryDate;
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
    if (maritalStatus != null) {
      map['maritalStatus'] = maritalStatus?.toJson();
    }
    if (nationality != null) {
      map['nationality'] = nationality?.toJson();
    }
    map['national'] = national;
    map['language'] = language;
    map['emiratesId'] = emiratesId;
    map['uaeResidenceVisaNo'] = uaeResidenceVisaNo;
    map['title'] = title;
    map['lastUpdatedDate'] = lastUpdatedDate;
    map['facematchPercentage'] = facematchPercentage;
    map['livelinessPercentage'] = livelinessPercentage;
    if (birthday != null) {
      map['birthday'] = birthday?.toJson();
    }
    if (anniversary != null) {
      map['anniversary'] = anniversary?.toJson();
    }
    map['preApprovedRefNum'] = preApprovedRefNum;
    map['preApprovedAmt'] = preApprovedAmt;
    map['preApprovedBankId'] = preApprovedBankId;
    map['noOfDependents'] = noOfDependents;
    if (countryOfBirth != null) {
      map['countryOfBirth'] = countryOfBirth?.toJson();
    }
    map['dateSinceInUAE'] = dateSinceInUAE;
    map['passportNum'] = passportNum;
    map['passportExpDate'] = passportExpDate;
    map['egyptian'] = egyptian;
    return map;
  }

}