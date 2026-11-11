class VehicleInfo {
  VehicleInfo({
      this.vehicleCondition, 
      this.vehiclePrice, 
      this.vehicleType, 
      this.vehicleDesc, 
      this.vehicleMakingYear, 
      this.vehicleColor, 
      this.vehicleName, 
      this.manufacturerType,});

  VehicleInfo.fromJson(dynamic json) {
    vehicleCondition = json['vehicleCondition'];
    vehiclePrice = json['vehiclePrice'];
    vehicleType = json['vehicleType'];
    vehicleDesc = json['vehicleDesc'];
    vehicleMakingYear = json['vehicleMakingYear'];
    vehicleColor = json['vehicleColor'];
    vehicleName = json['vehicleName'];
    manufacturerType = json['manufacturerType'];
  }
  String? vehicleCondition;
  double? vehiclePrice;
  String? vehicleType;
  String? vehicleDesc;
  int? vehicleMakingYear;
  String? vehicleColor;
  String? vehicleName;
  String? manufacturerType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicleCondition'] = vehicleCondition;
    map['vehiclePrice'] = vehiclePrice;
    map['vehicleType'] = vehicleType;
    map['vehicleDesc'] = vehicleDesc;
    map['vehicleMakingYear'] = vehicleMakingYear;
    map['vehicleColor'] = vehicleColor;
    map['vehicleName'] = vehicleName;
    map['manufacturerType'] = manufacturerType;
    return map;
  }

}