import 'Education.dart';
import 'Gender.dart';
import 'Relationship.dart';

class CoApplForm {
  CoApplForm({
      this.name, 
      this.gender, 
      this.relationship, 
      this.dateOfbirth, 
      this.passportNum, 
      this.passportExpDate, 
      this.nationalId, 
      this.nationalIdExpDate, 
      this.education, 
      this.mobileNum, 
      this.companyName, 
      this.jobTitle, 
      this.monthlyIncome,});

  CoApplForm.fromJson(dynamic json) {
    name = json['name'];
    gender = json['gender'] != null ? Gender?.fromJson(json['gender']) : null;
    relationship = json['relationship'] != null ? Relationship.fromJson(json['relationship']) : null;
    dateOfbirth = json['dateOfbirth'];
    passportNum = json['passportNum'];
    passportExpDate = json['passportExpDate'];
    nationalId = json['nationalId'];
    nationalIdExpDate = json['nationalIdExpDate'];
    education = json['education'] != null ? Education.fromJson(json['education']) : null;
    mobileNum = json['mobNum'];
    companyName = json['companyName'];
    jobTitle = json['jobTitle'];
    monthlyIncome = json['monthlyIncome'];
  }
  String? name;
  Gender? gender;
  Relationship? relationship;
  String? dateOfbirth;
  String? passportNum;
  String? passportExpDate;
  String? nationalId;
  String? nationalIdExpDate;
  Education? education;
  String? mobileNum;
  String? companyName;
  String? jobTitle;
  double? monthlyIncome;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    if (gender != null) {
      map['gender'] = gender?.toJson();
    }
    if (relationship != null) {
      map['relationship'] = relationship?.toJson();
    }
    map['dateOfbirth'] = dateOfbirth;
    map['passportNum'] = passportNum;
    map['passportExpDate'] = passportExpDate;
    map['nationalId'] = nationalId;
    map['nationalIdExpDate'] = nationalIdExpDate;
    if (education != null) {
      map['education'] = education?.toJson();
    }
    map['mobNum'] = mobileNum;
    map['companyName'] = companyName;
    map['jobTitle'] = jobTitle;
    map['monthlyIncome'] = monthlyIncome;
    return map;
  }

}