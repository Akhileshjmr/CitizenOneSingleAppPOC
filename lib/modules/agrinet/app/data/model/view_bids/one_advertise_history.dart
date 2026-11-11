import 'package:citizenone_app/modules/agrinet/app/data/model/view_bids/adverise_history_list.dart';

import '../common/ch_message.dart';

class OneAdvertiseHistory {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  AdvertiseProduce? advertiseProduce;
  List<BidPlan>? bidPlanList;

  OneAdvertiseHistory({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.advertiseProduce,
    this.bidPlanList,
  });

  factory OneAdvertiseHistory.fromJson(Map<String, dynamic> json) =>
      OneAdvertiseHistory(
        reqSecureKey: json["reqSecureKey"],
        addiParams: json["addiParams"],
        chMessage:
            json["chMessage"] == null
                ? null
                : ChMessage.fromJson(json["chMessage"]),
        urlDecision: json["urlDecision"],
        advertiseProduce:
            json["advertiseProduce"] == null
                ? null
                : AdvertiseProduce.fromJson(json["advertiseProduce"]),
        bidPlanList:
            json["bidPlanList"] == null
                ? []
                : List<BidPlan>.from(
                  json["bidPlanList"].map((x) => BidPlan.fromJson(x)),
                ),
      );
}

class CropName {
  String? cropName;

  CropName({this.cropName});

  factory CropName.fromJson(Map<String, dynamic> json) =>
      CropName(cropName: json["cropName"]);
}

class BidPlan {
  String? reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  String? buyerId;
  String? buyerImage;
  String? adId;
  String? minPrice;
  String? totalQuantity;
  String? bidId;
  Status? status;
  FarmPlan? farmPlan;
  String? totalPrice;
  String? cropName;
  String? buyerName;
  List<Document>? documents;

  BidPlan({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.buyerId,
    this.buyerImage,
    this.adId,
    this.minPrice,
    this.totalQuantity,
    this.bidId,
    this.status,
    this.farmPlan,
    this.totalPrice,
    this.cropName,
    this.buyerName,
    this.documents,
  });

  BidPlan.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    buyerId = json['buyerId'];
    buyerImage = json['buyerImage'];
    adId = json['adId'];
    minPrice = json['minPrice'];
    totalQuantity = json['totalQuantity'];
    bidId = json['bidId'];

    status = json['status'] != null ? Status.fromJson(json['status']) : null;

    farmPlan =
        json['farmPlan'] != null ? FarmPlan.fromJson(json['farmPlan']) : null;

    totalPrice = json['totalPrice'];
    cropName = json['cropName'];
    buyerName = json['buyerName'];

    if (json['documents'] != null) {
      documents = <Document>[];
      json['documents'].forEach((v) {
        documents!.add(Document.fromJson(v));
      });
    }
  }
}

class Status {
  String? id;
  String? type;
  String? friendlyType;
  String? other;

  Status({this.id, this.type, this.friendlyType, this.other});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['friendlyType'] = friendlyType;
    data['other'] = other;
    return data;
  }
}

class FarmPlan {
  int? id;
  String? type;
  String? friendlyType;
  String? other;

  FarmPlan({this.id, this.type, this.friendlyType, this.other});

  FarmPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    friendlyType = json['friendlyType'];
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['friendlyType'] = friendlyType;
    data['other'] = other;
    return data;
  }
}
