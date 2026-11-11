import '../common/option.dart';

class MemberDetails {
  String? firstName;
  String? lastName;
  String? dob;
  Option? gender;
  Option? relationship;
  dynamic dependent;
  String? occupation;
  String? monthlyInc;
  String? contactNo;
  Option? idType;
  String? idNumber;

  MemberDetails({
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.relationship,
    this.dependent,
    this.occupation,
    this.monthlyInc,
    this.contactNo,
    this.idType,
    this.idNumber,
  });

  factory MemberDetails.fromJson(Map<String, dynamic> json) => MemberDetails(
    firstName: json["firstName"],
    lastName: json["lastName"],
    dob: json["dob"],
    gender: json["gender"] != null ? Option.fromJson(json["gender"]) : null,
    relationship:
        json["relationship"] != null
            ? Option.fromJson(json["relationship"])
            : null,
    dependent: json["dependent"],
    occupation: json["occupation"],
    monthlyInc: json["monthlyInc"],
    contactNo: json["contactNo"],
    idType: json["idType"] != null ? Option.fromJson(json["idType"]) : null,
    idNumber: json["idNumber"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "dob": dob,
    "gender": gender?.toJson(),
    "relationship": relationship?.toJson(),
    "dependent": dependent,
    "occupation": occupation,
    "monthlyInc": monthlyInc,
    "contactNo": contactNo,
    "idType": idType?.toJson(),
    "idNumber": idNumber,
  };
}
