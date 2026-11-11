import 'order_sub_item_info.dart';

class OrderBasicResp {
  String? key;
  String? desc;
  String? totalAmount = '0.0';
  String? subTotalAmount = '0.0';
  int? noOfItems = 0;
  String? totalOfferValue;
  String? offerName;
  String? offerDetail;
  String? status;
  String? startDate;
  String? statusDate;
  bool? isCheckout = false;
  String? imgUrl;
  String? orderType;
  String? flowStatus;
  String? refCode;
  String? custName;
  bool? isOrderHasLoan = false;
  String? categoryType;
  String? totalTax;
  String? giftWrapAmount;
  String? skuName;
  List<String?>? itemsInfo;
  String? offrMsg;
  String? currencyCode;
  String? transactionDate;
  bool? isPayNow = false;
  List<String?>? productName;
  String? vendor;
  String? productSku;
  double? interesrRate;
  ExternalOrderDetails? externalOrderDetails;

  OrderBasicResp({
    this.key,
    this.desc,
    this.totalAmount = '0.0',
    this.subTotalAmount = '0.0',
    this.noOfItems = 0,
    this.totalOfferValue,
    this.offerName,
    this.offerDetail,
    this.status,
    this.startDate,
    this.statusDate,
    this.isCheckout = false,
    this.imgUrl,
    this.orderType,
    this.flowStatus,
    this.refCode,
    this.custName,
    this.isOrderHasLoan = false,
    this.categoryType,
    this.totalTax,
    this.giftWrapAmount,
    this.skuName,
    this.itemsInfo,
    this.offrMsg,
    this.currencyCode,
    this.transactionDate,
    this.isPayNow,
    this.productName,
    this.vendor,
    this.productSku,
    this.interesrRate,
    this.externalOrderDetails,
  });

  @override
  String toString() {
    return 'OrderBasicResp{key: $key, desc: $desc, totalAmount: $totalAmount, subTotalAmount: $subTotalAmount, noOfItems: $noOfItems, totalOfferValue: $totalOfferValue, offerName: $offerName, offerDetail: $offerDetail, status: $status, startDate: $startDate, statusDate: $statusDate, isCheckout: $isCheckout, imgUrl: $imgUrl, orderType: $orderType, flowStatus: $flowStatus, refCode: $refCode, custName: $custName, isOrderHasLoan: $isOrderHasLoan, categoryType: $categoryType, totalTax: $totalTax, giftWrapAmount: $giftWrapAmount, skuName: $skuName, itemsInfo: $itemsInfo, offrMsg: $offrMsg, currencyCode: $currencyCode, transactionDate: $transactionDate, isPayNow: $isPayNow, productName: $productName, vendor: $vendor, productSku: $productSku, interesrRate: $interesrRate}';
  }

  OrderBasicResp.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    desc = json['desc'];
    totalAmount = json['totalAmount'];
    subTotalAmount = json['subTotalAmount'];
    noOfItems = json['noOfItems'];
    totalOfferValue = json['totalOfferValue'];
    offerName = json['offerName'];
    offerDetail = json['offerDetail'];
    status = json['status'];
    startDate = json['startDate'];
    statusDate = json['statusDate'];
    isCheckout = json['isCheckout'];
    imgUrl = json['imgUrl'];
    orderType = json['orderType'];
    flowStatus = json['flowStatus'];
    refCode = json['refCode'];
    custName = json['custName'];
    isOrderHasLoan = json['isOrderHasLoan'];
    categoryType = json['categoryType'];
    totalTax = json['totalTax'];
    giftWrapAmount = json['giftWrapAmount'];
    skuName = json['skuName'];
    itemsInfo =
        json["itemsInfo"] == null
            ? []
            : List<String?>.from(json["itemsInfo"].map((x) => x));
    offrMsg = json['offrMsg'];
    currencyCode = json['currencyCode'];
    transactionDate = json['transactionDate'];
    isPayNow = json['isPayNow'];
    productName =
        json["productName"] == null ? [] : json['productName'].cast<String>();
    vendor = json['vendor'];
    productSku = json['productSku'];
    interesrRate = json['interesrRate'];
    externalOrderDetails =
        json['externalOrderDetails'] != null
            ? new ExternalOrderDetails.fromJson(json['externalOrderDetails'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['desc'] = this.desc;
    data['totalAmount'] = this.totalAmount;
    data['subTotalAmount'] = this.subTotalAmount;
    data['noOfItems'] = this.noOfItems;
    data['totalOfferValue'] = this.totalOfferValue;
    data['offerName'] = this.offerName;
    data['offerDetail'] = this.offerDetail;
    data['status'] = this.status;
    data['startDate'] = this.startDate;
    data['statusDate'] = this.statusDate;
    data['isCheckout'] = this.isCheckout;
    data['imgUrl'] = this.imgUrl;
    data['orderType'] = this.orderType;
    data['flowStatus'] = this.flowStatus;
    data['refCode'] = this.refCode;
    data['custName'] = this.custName;
    data['isOrderHasLoan'] = this.isOrderHasLoan;
    data['categoryType'] = this.categoryType;
    data['totalTax'] = this.totalTax;
    data['giftWrapAmount'] = this.giftWrapAmount;
    data['skuName'] = this.skuName;
    data['itemsInfo'] = this.itemsInfo;
    data['offrMsg'] = this.offrMsg;
    data['currencyCode'] = this.currencyCode;
    data['transactionDate'] = this.transactionDate;
    data['isPayNow'] = this.isPayNow;
    data['productName'] = this.productName;
    data['vendor'] = this.vendor;
    data['productSku'] = this.productSku;
    data['interesrRate'] = this.interesrRate;
    return data;
  }
}

class OrderInfo {
  final String? key;
  final dynamic desc;
  final String? totalAmount;
  final String? subTotalAmount;
  final int? noOfItems;
  final String? status;
  final String? startDate;
  final String? statusDate;
  final dynamic imgUrl;
  final dynamic orderType;
  final dynamic flowStatus;
  final String? refCode;
  final String? categoryType;
  final dynamic totalTax;
  final dynamic skuName;
  final List<OrderSubItemsInfo>? itemsInfo;
  final String? transactionDate;
  final dynamic externalOrderDetails;

  OrderInfo({
    this.key,
    this.desc,
    this.totalAmount,
    this.subTotalAmount,
    this.noOfItems,
    this.status,
    this.startDate,
    this.statusDate,
    this.imgUrl,
    this.orderType,
    this.flowStatus,
    this.refCode,
    this.categoryType,
    this.totalTax,
    this.skuName,
    this.itemsInfo,
    this.transactionDate,
    this.externalOrderDetails,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
    key: json["key"],
    desc: json["desc"],
    totalAmount: json["totalAmount"],
    subTotalAmount: json["subTotalAmount"],
    noOfItems: json["noOfItems"],
    status: json["status"],
    startDate: json["startDate"],
    statusDate: json["statusDate"],
    imgUrl: json["imgUrl"],
    orderType: json["orderType"],
    flowStatus: json["flowStatus"],
    refCode: json["refCode"],
    categoryType: json["categoryType"],
    totalTax: json["totalTax"],
    skuName: json["skuName"],
    itemsInfo:
        json["itemsInfo"] == null
            ? []
            : List<OrderSubItemsInfo>.from(
              json["itemsInfo"]!.map((x) => OrderSubItemsInfo.fromJson(x)),
            ),
    transactionDate: json["transactionDate"],
    externalOrderDetails: json["externalOrderDetails"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "desc": desc,
    "totalAmount": totalAmount,
    "subTotalAmount": subTotalAmount,
    "noOfItems": noOfItems,
    "status": status,
    "startDate": startDate,
    "statusDate": statusDate,
    "imgUrl": imgUrl,
    "orderType": orderType,
    "flowStatus": flowStatus,
    "refCode": refCode,
    "categoryType": categoryType,
    "totalTax": totalTax,
    "skuName": skuName,
    "itemsInfo":
        itemsInfo == null
            ? []
            : List<dynamic>.from(itemsInfo!.map((x) => x.toJson())),
    "transactionDate": transactionDate,
    "externalOrderDetails": externalOrderDetails,
  };
}

///
class OrderBasicDet {
  ///
  OrderBasicDet({
    this.key,
    this.totalAmount,
    this.subTotalAmount,
    this.noOfItems,
    this.status,
    this.startDate,
    this.statusDate,
    this.imgUrl,
    this.orderType,
    this.flowStatus,
    this.refCode,
    this.categoryType,
    this.totalTax,
    this.skuName,
    this.itemsInfo,
    this.transactionDate,
    this.externalOrderDetails,
    this.orderId,
  });

  ///
  factory OrderBasicDet.fromJson(Map<String, dynamic> json) => OrderBasicDet(
    key: json['key'],
    totalAmount: json['totalAmount'],
    subTotalAmount: json['subTotalAmount'],
    noOfItems: json['noOfItems'],
    status: json['status'],
    startDate: json['startDate'],
    statusDate: json['statusDate'],
    imgUrl: json['imgUrl'],
    orderType: json['orderType'],
    flowStatus: json['flowStatus'],
    refCode: json['refCode'],
    categoryType: json['categoryType'],
    totalTax: json['totalTax'],
    skuName: json['skuName'],
    itemsInfo:
        json['itemsInfo'] == null
            ? []
            : List<dynamic>.from(json['itemsInfo']!.map((x) => x)),
    transactionDate: json['transactionDate'],
    externalOrderDetails:
        json['externalOrderDetails'] == null
            ? null
            : ExternalOrderDetails.fromJson(json['externalOrderDetails']),
    orderId: json['orderId'],
  );
  final String? key;
  final String? totalAmount;
  final String? subTotalAmount;
  final int? noOfItems;
  final String? status;
  final String? startDate;
  final String? statusDate;
  final String? imgUrl;
  final String? orderType;
  final String? flowStatus;
  final String? refCode;
  final String? categoryType;
  final String? totalTax;
  final dynamic skuName;
  final List<dynamic>? itemsInfo;
  final String? transactionDate;
  final ExternalOrderDetails? externalOrderDetails;
  final dynamic orderId;

  ///
  Map<String, dynamic> toJson() => {
    'key': key,
    'totalAmount': totalAmount,
    'subTotalAmount': subTotalAmount,
    'noOfItems': noOfItems,
    'status': status,
    'startDate': startDate,
    'statusDate': statusDate,
    'imgUrl': imgUrl,
    'orderType': orderType,
    'flowStatus': flowStatus,
    'refCode': refCode,
    'categoryType': categoryType,
    'totalTax': totalTax,
    'skuName': skuName,
    'itemsInfo':
        itemsInfo == null ? [] : List<dynamic>.from(itemsInfo!.map((x) => x)),
    'transactionDate': transactionDate,
    'externalOrderDetails': externalOrderDetails?.toJson(),
    'orderId': orderId,
  };
}

///
class ExternalOrderDetails {
  int? id;
  int? externalOrderId;
  String? externalOrderRef;
  String? status;

  ExternalOrderDetails({
    this.id,
    this.externalOrderId,
    this.externalOrderRef,
    this.status,
  });

  ExternalOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    externalOrderId = json['externalOrderId'];
    externalOrderRef = json['externalOrderRef'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['externalOrderId'] = this.externalOrderId;
    data['externalOrderRef'] = this.externalOrderRef;
    data['status'] = this.status;
    return data;
  }
}
