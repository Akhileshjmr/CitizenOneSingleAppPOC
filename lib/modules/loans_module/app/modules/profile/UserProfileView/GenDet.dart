import 'MaritalStatus.dart';

class GenDet {
  GenDet({
      this.fullName, 
      this.pNumber, 
      this.levelOfEducation, 
      this.expiryDate, 
      this.firstName, 
      this.middleName, 
      this.lastName, 
      this.dob, 
      this.email, 
      this.gender, 
      this.maritalStatus, 
      this.nationality, 
      this.emiratesId, 
      this.title,});

  GenDet.fromJson(dynamic json) {
    fullName = json['fullName'];
    pNumber = json['pNumber'];
    levelOfEducation = json['levelOfEducation'];
    expiryDate = json['expiryDate'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    dob = json['dob'];
    email = json['email'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'] != null ? MaritalStatus.fromJson(json['maritalStatus']) : null;
    nationality = json['nationality'];
    emiratesId = json['emiratesId'];
    title = json['title'];
  }
  dynamic fullName;
  String? pNumber;
  dynamic levelOfEducation;
  dynamic expiryDate;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  String? email;
  String? gender;
  MaritalStatus? maritalStatus;
  dynamic nationality;
  dynamic emiratesId;
  String? title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['pNumber'] = pNumber;
    map['levelOfEducation'] = levelOfEducation;
    map['expiryDate'] = expiryDate;
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['dob'] = dob;
    map['email'] = email;
    map['gender'] = gender;
    if (maritalStatus != null) {
      map['maritalStatus'] = maritalStatus?.toJson();
    }
    map['nationality'] = nationality;
    map['emiratesId'] = emiratesId;
    map['title'] = title;
    return map;
  }

}