import 'City.dart';
import 'Area.dart';

class PrimaryAddress {
  PrimaryAddress({
      this.addressLine, 
      this.phNum, 
      this.emailAddress, 
      this.mapLoc, 
      this.emerContactPerson, 
      this.emerContactPhNum, 
      this.city, 
      this.area, 
      this.country, 
      this.state, 
      this.emirate, 
      this.building, 
      this.houseNo, 
      this.postBoxNum, 
      this.landMark,});

  PrimaryAddress.fromJson(dynamic json) {
    addressLine = json['addressLine'];
    phNum = json['phNum'];
    emailAddress = json['emailAddress'];
    mapLoc = json['mapLoc'];
    emerContactPerson = json['emerContactPerson'];
    emerContactPhNum = json['emerContactPhNum'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    country = json['country'];
    state = json['state'];
    emirate = json['emirate'];
    building = json['building'];
    houseNo = json['houseNo'];
    postBoxNum = json['postBoxNum'];
    landMark = json['landMark'];
  }
  String? addressLine;
  String? phNum;
  String? emailAddress;
  dynamic mapLoc;
  String? emerContactPerson;
  String? emerContactPhNum;
  City? city;
  Area? area;
  dynamic country;
  dynamic state;
  dynamic emirate;
  dynamic building;
  dynamic houseNo;
  dynamic postBoxNum;
  dynamic landMark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addressLine'] = addressLine;
    map['phNum'] = phNum;
    map['emailAddress'] = emailAddress;
    map['mapLoc'] = mapLoc;
    map['emerContactPerson'] = emerContactPerson;
    map['emerContactPhNum'] = emerContactPhNum;
    if (city != null) {
      map['city'] = city?.toJson();
    }
    if (area != null) {
      map['area'] = area?.toJson();
    }
    map['country'] = country;
    map['state'] = state;
    map['emirate'] = emirate;
    map['building'] = building;
    map['houseNo'] = houseNo;
    map['postBoxNum'] = postBoxNum;
    map['landMark'] = landMark;
    return map;
  }

}