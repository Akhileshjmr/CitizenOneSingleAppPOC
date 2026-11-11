import '../common/ch_message.dart';

class AdvertiseProductResponse {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  List<AdvertiseProduce>? advertiseProduce;

  AdvertiseProductResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.advertiseProduce,
  });

  factory AdvertiseProductResponse.fromJson(Map<String, dynamic> json) {
    return AdvertiseProductResponse(
      reqSecureKey: json["reqSecureKey"],
      addiParams: json["addiParams"],
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,
      urlDecision: json["urlDecision"],
      advertiseProduce:
          json["advertiseProduce"] != null
              ? List<AdvertiseProduce>.from(
                json["advertiseProduce"].map(
                  (x) => AdvertiseProduce.fromJson(x),
                ),
              )
              : null,
    );
  }
}

class AdvertiseProduce {
  String? id;
  String? farmPlanID;
  String? groupID;
  List<CropName>? cropName;
  String? minPrice;
  String? totalQuantity;
  String? readyBy;
  String? bidClose;
  bool? transportationProvided;
  List<Document>? documents;
  String? status;
  String? username;
  String? country;
  String? state;
  String? city;

  AdvertiseProduce({
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

  factory AdvertiseProduce.fromJson(Map<String, dynamic> json) {
    return AdvertiseProduce(
      id: json["id"],
      farmPlanID: json["farmPlanID"],
      groupID: json["groupID"],
      cropName:
          json["cropName"] != null
              ? List<CropName>.from(
                json["cropName"].map((x) => CropName.fromJson(x)),
              )
              : null,
      minPrice: json["minPrice"],
      totalQuantity: json["totalQuantity"],
      readyBy: json["readyBy"],
      bidClose: json["bidClose"],
      transportationProvided: json["transportationProvided"],
      documents:
          json["documents"] != null
              ? List<Document>.from(
                json["documents"].map((x) => Document.fromJson(x)),
              )
              : null,
      status: json["status"],
      username: json["username"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
    );
  }
}

class CropName {
  String? cropName;

  CropName({this.cropName});

  factory CropName.fromJson(Map<String, dynamic> json) {
    return CropName(cropName: json["cropName"]);
  }
}

class Document {
  String? fileName;

  Document({this.fileName});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(fileName: json["fileName"]);
  }
}
