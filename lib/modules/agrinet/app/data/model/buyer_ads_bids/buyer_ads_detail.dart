import '../common/ch_message.dart';
import '../view_bids/adverise_history_list.dart';

class BuyerAdsBidDetailRes {
  final ChMessage? chMessage;
  final String? id;
  final String? farmPlanID;
  final String? groupID;
  final List<CropName> cropName;
  final String? minPrice;
  final String? totalQuantity;
  final String? readyBy;
  final String? bidClose;
  final bool? transportationProvided;
  final List<Document> documents;
  final BidStatus? status;
  final String? username;
  final String? country;
  final String? state;
  final String? city;

  BuyerAdsBidDetailRes({
    this.chMessage,
    this.id,
    this.farmPlanID,
    this.groupID,
    required this.cropName,
    this.minPrice,
    this.totalQuantity,
    this.readyBy,
    this.bidClose,
    this.transportationProvided,
    required this.documents,
    this.status,
    this.username,
    this.country,
    this.state,
    this.city,
  });

  factory BuyerAdsBidDetailRes.fromJson(Map<String, dynamic> json) {
    return BuyerAdsBidDetailRes(
      chMessage:
          json["chMessage"] != null
              ? ChMessage.fromJson(json["chMessage"])
              : null,

      id: json["id"],
      farmPlanID: json["farmPlanID"],
      groupID: json["groupID"], // keep raw string "$12000.0"

      cropName:
          json["cropName"] == null
              ? []
              : List<CropName>.from(
                json["cropName"].map((x) => CropName.fromJson(x)),
              ),

      minPrice: json["minPrice"], // "$12.0"
      totalQuantity: json["totalQuantity"], // "1000"
      readyBy: json["readyBy"], // "2025-12-08 00:00:00.0"
      bidClose: json["bidClose"], // "2025-12-10 00:00:00.0"

      transportationProvided: json["transportationProvided"],
      documents:
          json["documents"] == null
              ? []
              : List<Document>.from(
                json["documents"].map((x) => Document.fromJson(x)),
              ),

      /*json["documents"] ?? [],*/
      status:
          json["status"] != null ? BidStatus.fromJson(json["status"]) : null,

      username: json["username"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
    );
  }
}

class BidStatus {
  final String? id;
  final String? type;
  final String? friendlyType;

  BidStatus({this.id, this.type, this.friendlyType});

  factory BidStatus.fromJson(Map<String, dynamic> json) {
    return BidStatus(
      id: json["id"],
      type: json["type"],
      friendlyType: json["friendlyType"],
    );
  }
}

class CropName {
  final String cropName;

  CropName({required this.cropName});

  factory CropName.fromJson(Map<String, dynamic> json) {
    return CropName(cropName: json["cropName"] ?? "-");
  }
}
