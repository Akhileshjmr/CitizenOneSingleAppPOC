class Features {
  Features({
      this.location, 
      this.bedrooms, 
      this.bathrooms, 
      this.area, 
      this.emi, 
      this.carParking,});

  Features.fromJson(dynamic json) {
    location = json['location'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    area = json['area'];
    emi = json['emi'];
    carParking = json['carParking'];
  }
  String? location;
  String? bedrooms;
  String? bathrooms;
  String? area;
  dynamic emi;
  String? carParking;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location'] = location;
    map['bedrooms'] = bedrooms;
    map['bathrooms'] = bathrooms;
    map['area'] = area;
    map['emi'] = emi;
    map['carParking'] = carParking;
    return map;
  }

}