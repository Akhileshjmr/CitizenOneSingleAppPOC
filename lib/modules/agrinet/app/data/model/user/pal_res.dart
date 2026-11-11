import 'document.dart';
import 'mentor.dart';

class PalRes {
  Documents? documents;
  String? firstName;
  String? grade;
  String? mobileNum;
  String? email;
  dynamic fundingAgency;
  dynamic unitType;
  dynamic measurementUnit;
  dynamic currencyType;
  List<Mentor>? mentor;

  PalRes({
    this.documents,
    this.firstName,
    this.grade,
    this.mobileNum,
    this.email,
    this.fundingAgency,
    this.unitType,
    this.measurementUnit,
    this.currencyType,
    this.mentor,
  });

  factory PalRes.fromJson(Map<String, dynamic> json) {
    return PalRes(
      documents:
          json['documents'] != null
              ? Documents.fromJson(json['documents'])
              : null,
      firstName: json['firstName'],
      grade: json['grade'],
      mobileNum: json['mobileNum'],
      email: json['email'],
      fundingAgency: json['fundingAgency'],
      unitType: json['unitType'],
      measurementUnit: json['measurementUnit'],
      currencyType: json['currencyType'],
      mentor:
          (json['mentor'] as List<dynamic>?)
              ?.map((e) => Mentor.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documents': documents?.toJson(),
      'firstName': firstName,
      'grade': grade,
      'mobileNum': mobileNum,
      'email': email,
      'fundingAgency': fundingAgency,
      'unitType': unitType,
      'measurementUnit': measurementUnit,
      'currencyType': currencyType,
      'mentor': mentor?.map((e) => e.toJson()).toList(),
    };
  }
}
