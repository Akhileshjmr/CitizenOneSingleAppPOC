class OrderView {
  OrderView({
      this.propertyName, 
      this.propertyValue, 
      this.propertyType, 
      this.propertySize, 
      this.yearsOfConstruction, 
      this.registrationDate, 
      this.propertyAddress, 
      this.reraNumber, 
      this.sellerName, 
      this.sellerContactDetails, 
      this.primaryImage, 
      this.otherImages, 
      this.zipCode,});

  OrderView.fromJson(dynamic json) {
    propertyName = json['propertyName'];
    propertyValue = json['propertyValue'];
    propertyType = json['propertyType'];
    propertySize = json['propertySize'];
    yearsOfConstruction = json['yearsOfConstruction'];
    registrationDate = json['registrationDate'];
    propertyAddress = json['propertyAddress'];
    reraNumber = json['reraNumber'];
    sellerName = json['sellerName'];
    sellerContactDetails = json['sellerContactDetails'];
    primaryImage = json['primaryImage'];
    otherImages = json['otherImages'];
    zipCode = json['zipCode'];
  }
  String? propertyName;
  double? propertyValue;
  String? propertyType;
  String? propertySize;
  int? yearsOfConstruction;
  String? registrationDate;
  String? propertyAddress;
  String? reraNumber;
  String? sellerName;
  String? sellerContactDetails;
  String? primaryImage;
  String? otherImages;
  int? zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['propertyName'] = propertyName;
    map['propertyValue'] = propertyValue;
    map['propertyType'] = propertyType;
    map['propertySize'] = propertySize;
    map['yearsOfConstruction'] = yearsOfConstruction;
    map['registrationDate'] = registrationDate;
    map['propertyAddress'] = propertyAddress;
    map['reraNumber'] = reraNumber;
    map['sellerName'] = sellerName;
    map['sellerContactDetails'] = sellerContactDetails;
    map['primaryImage'] = primaryImage;
    map['otherImages'] = otherImages;
    map['zipCode'] = zipCode;
    return map;
  }

}