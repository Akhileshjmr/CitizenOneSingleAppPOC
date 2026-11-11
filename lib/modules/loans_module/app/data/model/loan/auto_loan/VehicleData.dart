class VehicleData {
  VehicleData({
      this.vehicleCondition, 
      this.vehicleType, 
      this.vehicleDesc, 
      this.vehicleMakingYear, 
      this.vehicleColor, 
      this.vehiclePrice, 
      this.vehicleName, 
      this.manufacturerType,});

  VehicleData.fromJson(dynamic json) {
    vehicleCondition = json['vehicleCondition'];
    vehicleType = json['vehicleType'];
    vehicleDesc = json['vehicleDesc'];
    vehicleMakingYear = json['vehicleMakingYear'];
    vehicleColor = json['vehicleColor'];
    vehiclePrice = json['vehiclePrice'];
    vehicleName = json['vehicleName'];
    manufacturerType = json['manufacturerType'];
  }
  String? vehicleCondition;
  String? vehicleType;
  String? vehicleDesc;
  int? vehicleMakingYear;
  String? vehicleColor;
  double? vehiclePrice;
  String? vehicleName;
  String? manufacturerType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicleCondition'] = vehicleCondition;
    map['vehicleType'] = vehicleType;
    map['vehicleDesc'] = vehicleDesc;
    map['vehicleMakingYear'] = vehicleMakingYear;
    map['vehicleColor'] = vehicleColor;
    map['vehiclePrice'] = vehiclePrice;
    map['vehicleName'] = vehicleName;
    map['manufacturerType'] = manufacturerType;
    return map;
  }

}