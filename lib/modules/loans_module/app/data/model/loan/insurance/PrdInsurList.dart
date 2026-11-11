import 'Logo.dart';

class PrdInsurList {
  PrdInsurList({
      this.insurerName, 
      this.premiumAmt, 
      this.tax, 
      this.totalPremiumAmt, 
      this.idv, 
      this.logo,});

  PrdInsurList.fromJson(dynamic json) {
    insurerName = json['insurerName'];
    premiumAmt = json['premiumAmt'];
    tax = json['tax'];
    totalPremiumAmt = json['totalPremiumAmt'];
    idv = json['idv'];
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
  }
  String? insurerName;
  String? premiumAmt;
  String? tax;
  String? totalPremiumAmt;
  String? idv;
  Logo? logo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['insurerName'] = insurerName;
    map['premiumAmt'] = premiumAmt;
    map['tax'] = tax;
    map['totalPremiumAmt'] = totalPremiumAmt;
    map['idv'] = idv;
    if (logo != null) {
      map['logo'] = logo?.toJson();
    }
    return map;
  }

}