class Orders {
  Orders({
      this.key, 
      this.desc, 
      this.totalAmount, 
      this.subTotalAmount, 
      this.noOfItems, 
      this.totalOfferValue, 
      this.offerName, 
      this.offerDetail, 
      this.status, 
      this.startDate, 
      this.statusDate, 
      this.isCheckout, 
      this.imgUrl, 
      this.orderType, 
      this.flowStatus, 
      this.refCode, 
      this.custName, 
      this.isOrderHasLoan, 
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
      this.interesrRate,});

  Orders.fromJson(dynamic json) {
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
    itemsInfo = json['itemsInfo'] != null ? json['itemsInfo'].cast<String>() : [];
    offrMsg = json['offrMsg'];
    currencyCode = json['currencyCode'];
    transactionDate = json['transactionDate'];
    isPayNow = json['isPayNow'];
    productName = json['productName'] != null ? json['productName'].cast<String>() : [];
    vendor = json['vendor'];
    productSku = json['productSku'];
    interesrRate = json['interesrRate'];
  }
  String? key;
  dynamic desc;
  String? totalAmount;
  String? subTotalAmount;
  int? noOfItems;
  dynamic totalOfferValue;
  dynamic offerName;
  dynamic offerDetail;
  String? status;
  String? startDate;
  String? statusDate;
  bool? isCheckout;
  String? imgUrl;
  String? orderType;
  dynamic flowStatus;
  String? refCode;
  dynamic custName;
  bool? isOrderHasLoan;
  String? categoryType;
  dynamic totalTax;
  dynamic giftWrapAmount;
  dynamic skuName;
  List<String?>? itemsInfo;
  dynamic offrMsg;
  dynamic currencyCode;
  String? transactionDate;
  bool? isPayNow;
  List<String?>? productName;
  dynamic vendor;
  dynamic productSku;
  dynamic interesrRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['desc'] = desc;
    map['totalAmount'] = totalAmount;
    map['subTotalAmount'] = subTotalAmount;
    map['noOfItems'] = noOfItems;
    map['totalOfferValue'] = totalOfferValue;
    map['offerName'] = offerName;
    map['offerDetail'] = offerDetail;
    map['status'] = status;
    map['startDate'] = startDate;
    map['statusDate'] = statusDate;
    map['isCheckout'] = isCheckout;
    map['imgUrl'] = imgUrl;
    map['orderType'] = orderType;
    map['flowStatus'] = flowStatus;
    map['refCode'] = refCode;
    map['custName'] = custName;
    map['isOrderHasLoan'] = isOrderHasLoan;
    map['categoryType'] = categoryType;
    map['totalTax'] = totalTax;
    map['giftWrapAmount'] = giftWrapAmount;
    map['skuName'] = skuName;
    map['itemsInfo'] = itemsInfo;
    map['offrMsg'] = offrMsg;
    map['currencyCode'] = currencyCode;
    map['transactionDate'] = transactionDate;
    map['isPayNow'] = isPayNow;
    map['productName'] = productName;
    map['vendor'] = vendor;
    map['productSku'] = productSku;
    map['interesrRate'] = interesrRate;
    return map;
  }

}