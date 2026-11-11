class AddressDelResp {
  int? id;
  String? personName;
  String? addressLine;
  dynamic contactNum;
  bool? isDefault;
  String? landMark;
  String? stateInfo;
  String? cityInfo;
  String? areaInfo;
  String? lastName;
  String? typeOfAddress;
  String? stateName;
  String? cityName;
  String? flatNumber;
  String? buildingName;
  dynamic postalCode = 0;
  String? customerId;
  double? latitude = 0;
  double? longitude = 0;

  AddressDelResp(
      {this.id,
      this.postalCode = 0,
      this.personName,
      this.addressLine,
      this.contactNum,
      this.isDefault,
      this.landMark,
      this.stateInfo,
      this.cityInfo,
      this.areaInfo,
      this.lastName,
      this.stateName,
      this.cityName,
      this.flatNumber,
      this.buildingName,
      this.typeOfAddress,
      this.customerId,
      this.latitude,
      this.longitude,
      });

  @override
  String toString() {
    return 'AddressDelResp{id: $id, personName: $personName, addressLine: $addressLine, contactNum: $contactNum, isDefault: $isDefault, landMark: $landMark, stateInfo: $stateInfo, cityInfo: $cityInfo, areaInfo: $areaInfo, lastName: $lastName, typeOfAddress: $typeOfAddress, stateName: $stateName, cityName: $cityName}';
  }

  String get address =>
      'PB No:${postalCode.toString() ?? ''},${personName ?? ''},${addressLine ?? ''},${stateName ?? ''}'
          ',${cityName ?? ''}';

  AddressDelResp.fromJson(dynamic json) {
    id = json['id'] == null ? 0 : json['id'];
    postalCode = json['postalCode'] == null ? 0 : json['postalCode'];
    personName = json['personName'];
    addressLine = json['addressLine'];
    contactNum = json['contactNum'];
    isDefault = json['isDefault'];
    landMark = json['landMark'];
    stateInfo = json['stateInfo'];
    cityInfo = json['cityInfo'];
    areaInfo = json['areaInfo'];
    lastName = json['lastName'];
    typeOfAddress = json['typeOfAddress'];
    stateName = json['stateName'];
    cityName = json['cityName'];
    buildingName = json['buildingName'];
    flatNumber = json['flatNumber'];
    customerId = json['customerId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['personName'] = personName;
    map['addressLine'] = addressLine;
    map['contactNum'] = contactNum;
    map['isDefault'] = isDefault;
    map['landMark'] = landMark;
    map['stateInfo'] = stateInfo;
    map['cityInfo'] = cityInfo;
    map['stateInfo'] = areaInfo;
    map['stateInfo'] = lastName;
    map['stateInfo'] = typeOfAddress;
    map['postalCode'] = postalCode;
    map['stateName'] = stateName;
    map['cityName'] = cityName;
    map['flatNumber'] = flatNumber;
    map['buildingName'] = buildingName;
    map['customerId'] = customerId;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
