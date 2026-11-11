
import 'package:citizenone_app/modules/loans_module/app/data/model/common/ch_message.dart';

import 'CardImage.dart';

class FinalCcFormSumbitResp {
  FinalCcFormSumbitResp({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.smsVendorResp, 
      this.creditCardCode, 
      this.customerCode, 
      this.applicationStatus, 
      this.reqLimitAmount, 
      this.productName, 
      this.bankName, 
      this.activatedDate, 
      this.cardImage,});

  FinalCcFormSumbitResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    smsVendorResp = json['smsVendorResp'];
    creditCardCode = json['creditCardCode'];
    customerCode = json['customerCode'];
    applicationStatus = json['applicationStatus'];
    reqLimitAmount = json['reqLimitAmount'];
    productName = json['productName'];
    bankName = json['bankName'];
    activatedDate = json['activatedDate'];
    cardImage = json['cardImage'] != null ? CardImage.fromJson(json['cardImage']) : null;
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic smsVendorResp;
  String? creditCardCode;
  String? customerCode;
  String? applicationStatus;
  dynamic reqLimitAmount;
  String? productName;
  String? bankName;
  dynamic activatedDate;
  CardImage? cardImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['smsVendorResp'] = smsVendorResp;
    map['creditCardCode'] = creditCardCode;
    map['customerCode'] = customerCode;
    map['applicationStatus'] = applicationStatus;
    map['reqLimitAmount'] = reqLimitAmount;
    map['productName'] = productName;
    map['bankName'] = bankName;
    map['activatedDate'] = activatedDate;
    if (cardImage != null) {
      map['cardImage'] = cardImage?.toJson();
    }
    return map;
  }

}