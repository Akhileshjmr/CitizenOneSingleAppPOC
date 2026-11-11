import 'Relationship.dart';

class LoanRefDetails {
  LoanRefDetails({
      this.name, 
      this.mobNum, 
      this.companyName, 
      this.relationship,});

  LoanRefDetails.fromJson(dynamic json) {
    name = json['name'];
    mobNum = json['mobNum'];
    companyName = json['companyName'];
    relationship = json['relationship'] != null ? Relationship.fromJson(json['relationship']) : null;
  }
  String? name;
  String? mobNum;
  String? companyName;
  Relationship? relationship;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['mobNum'] = mobNum;
    map['companyName'] = companyName;
    if (relationship != null) {
      map['relationship'] = relationship?.toJson();
    }
    return map;
  }

}