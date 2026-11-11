class WorkingAddress {
  WorkingAddress({
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

  WorkingAddress.fromJson(dynamic json) {
    addressLine = json['addressLine'];
    phNum = json['phNum'];
    emailAddress = json['emailAddress'];
    mapLoc = json['mapLoc'];
    emerContactPerson = json['emerContactPerson'];
    emerContactPhNum = json['emerContactPhNum'];
    city = json['city'];
    area = json['area'];
    country = json['country'];
    state = json['state'];
    emirate = json['emirate'];
    building = json['building'];
    houseNo = json['houseNo'];
    postBoxNum = json['postBoxNum'];
    landMark = json['landMark'];
  }
  dynamic addressLine;
  dynamic phNum;
  dynamic emailAddress;
  dynamic mapLoc;
  dynamic emerContactPerson;
  dynamic emerContactPhNum;
  dynamic city;
  dynamic area;
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
    map['city'] = city;
    map['area'] = area;
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