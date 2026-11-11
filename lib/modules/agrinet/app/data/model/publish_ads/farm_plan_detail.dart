import '../common/ch_message.dart';

class CropDetailResponse {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final String? id;
  final String? farmPlanID;
  final String? groupID;
  final List<CropName>? cropName;
  final dynamic minPrice;
  final dynamic totalQuantity;
  final dynamic readyBy;
  final dynamic bidClose;
  final dynamic transportationProvided;
  final dynamic documents;
  final dynamic status;
  final String? username;
  final dynamic country;
  final dynamic state;
  final dynamic city;

  CropDetailResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.id,
    this.farmPlanID,
    this.groupID,
    this.cropName,
    this.minPrice,
    this.totalQuantity,
    this.readyBy,
    this.bidClose,
    this.transportationProvided,
    this.documents,
    this.status,
    this.username,
    this.country,
    this.state,
    this.city,
  });

  factory CropDetailResponse.fromJson(Map<String, dynamic> json) {
    return CropDetailResponse(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      id: json['id'],
      farmPlanID: json['farmPlanID'],
      groupID: json['groupID'],
      cropName:
          json['cropName'] != null
              ? List<CropName>.from(
                json['cropName'].map((x) => CropName.fromJson(x)),
              )
              : null,
      minPrice: json['minPrice'],
      totalQuantity: json['totalQuantity'],
      readyBy: json['readyBy'],
      bidClose: json['bidClose'],
      transportationProvided: json['transportationProvided'],
      documents: json['documents'],
      status: json['status'],
      username: json['username'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {
    "reqSecureKey": reqSecureKey,
    "addiParams": addiParams,
    "chMessage": chMessage?.toJson(),
    "urlDecision": urlDecision,
    "id": id,
    "farmPlanID": farmPlanID,
    "groupID": groupID,
    "cropName": cropName?.map((x) => x.toJson()).toList(),
    "minPrice": minPrice,
    "totalQuantity": totalQuantity,
    "readyBy": readyBy,
    "bidClose": bidClose,
    "transportationProvided": transportationProvided,
    "documents": documents,
    "status": status,
    "username": username,
    "country": country,
    "state": state,
    "city": city,
  };
}

class CropName {
  final String? cropName;

  CropName({this.cropName});

  factory CropName.fromJson(Map<String, dynamic> json) {
    return CropName(cropName: json['cropName']);
  }

  Map<String, dynamic> toJson() => {"cropName": cropName};
}
