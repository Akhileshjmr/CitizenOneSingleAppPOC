import 'CardImage.dart';

class CreditCardReqList {
  CreditCardReqList({
      this.id, 
      this.custName, 
      this.cardReqStatus, 
      this.eligibility, 
      this.status, 
      this.creditReqCode, 
      this.crProductId, 
      this.cardType, 
      this.productName, 
      this.productCode, 
      this.cardVariant, 
      this.minimumIncome,
      this.limitAmount,
      this.cardImage,
      this.customerCode, 
      this.cardRequestDate,
    this.leadId,
    this.lastMsgSendBy,
    this.appType,
    this.chatId,});

  CreditCardReqList.fromJson(dynamic json) {
    id = json['id'];
    custName = json['custName'];
    cardReqStatus = json['cardReqStatus'];
    eligibility = json['eligibility'];
    status = json['status'];
    creditReqCode = json['creditReqCode'];
    crProductId = json['crProductId'];
    cardType = json['cardType'];
    productName = json['productName'];
    productCode = json['productCode'];
    cardVariant = json['cardVariant'];
    limitAmount = json['limitAmount'];
    minimumIncome = json['minimumIncome'];
    cardImage = json['cardImage'] != null ? CardImage.fromJson(json['cardImage']) : null;
    customerCode = json['customerCode'];
    cardRequestDate = json['cardRequestDate'];
    leadId = json['leadId'];
    lastMsgSendBy = json['lastMsgSendBy'];
    appType = json['appType'];
    chatId = json['chatId'];
  }
  int? id;
  String? custName;
  String? cardReqStatus;
  String? eligibility;
  String? status;
  String? creditReqCode;
  dynamic crProductId;
  dynamic cardType;
  String? productName;
  String? productCode;
  String? cardVariant;
  double? minimumIncome;
  CardImage? cardImage;
  String? customerCode;
  String? cardRequestDate;
  double? limitAmount;
  int? leadId;
  String? lastMsgSendBy;
  String? appType;
  int? chatId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['custName'] = custName;
    map['cardReqStatus'] = cardReqStatus;
    map['eligibility'] = eligibility;
    map['status'] = status;
    map['creditReqCode'] = creditReqCode;
    map['crProductId'] = crProductId;
    map['cardType'] = cardType;
    map['productName'] = productName;
    map['productCode'] = productCode;
    map['cardVariant'] = cardVariant;
    map['minimumIncome'] = minimumIncome;
    if (cardImage != null) {
      map['cardImage'] = cardImage?.toJson();
    }
    map['customerCode'] = customerCode;
    map['cardRequestDate'] = cardRequestDate;
    map['limitAmount'] = limitAmount;
    map['leadId'] = leadId;
    map['lastMsgSendBy'] = lastMsgSendBy;
    map['appType'] = appType;
    map['chatId'] = chatId;
    return map;
  }

}