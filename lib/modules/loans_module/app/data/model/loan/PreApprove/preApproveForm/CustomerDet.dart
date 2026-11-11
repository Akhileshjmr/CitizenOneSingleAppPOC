import 'GenDet.dart';
import 'CommDet.dart';
import 'EmpDetails.dart';
import 'AddiDet.dart';

class CustomerDet {
  CustomerDet({
      this.isTcAgreed, 
      this.docs, 
      this.genDet, 
      this.commDet, 
      this.empDetails, 
      this.addiDet, 
      this.appllnLevel, 
      this.profilePic, 
      this.orderId, 
      this.loanDetails, 
      this.addressDet,});

  CustomerDet.fromJson(dynamic json) {
    isTcAgreed = json['isTcAgreed'];
    docs = json['docs'];
    genDet = json['genDet'] != null ? GenDet.fromJson(json['genDet']) : null;
    commDet = json['commDet'] != null ? CommDet.fromJson(json['commDet']) : null;
    empDetails = json['empDetails'] != null ? EmpDetails.fromJson(json['empDetails']) : null;
    addiDet = json['addiDet'] != null ? AddiDet.fromJson(json['addiDet']) : null;
    appllnLevel = json['appllnLevel'];
    profilePic = json['profilePic'];
    orderId = json['orderId'];
    loanDetails = json['loanDetails'];
    addressDet = json['addressDet'];
  }
  bool? isTcAgreed;
  dynamic docs;
  GenDet? genDet;
  CommDet? commDet;
  EmpDetails? empDetails;
  AddiDet? addiDet;
  dynamic appllnLevel;
  dynamic profilePic;
  dynamic orderId;
  dynamic loanDetails;
  dynamic addressDet;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isTcAgreed'] = isTcAgreed;
    map['docs'] = docs;
    if (genDet != null) {
      map['genDet'] = genDet?.toJson();
    }
    if (commDet != null) {
      map['commDet'] = commDet?.toJson();
    }
    if (empDetails != null) {
      map['empDetails'] = empDetails?.toJson();
    }
    if (addiDet != null) {
      map['addiDet'] = addiDet?.toJson();
    }
    map['appllnLevel'] = appllnLevel;
    map['profilePic'] = profilePic;
    map['orderId'] = orderId;
    map['loanDetails'] = loanDetails;
    map['addressDet'] = addressDet;
    return map;
  }

}