
import 'package:citizenone_app/modules/loans_module/app/data/model/common/ch_message.dart';

import 'CreditCardBenefitOptionsList.dart';

class BenefitsListResp {
  BenefitsListResp({
      this.reqSecureKey, 
      this.addiParams, 
      required this.chMessage,
      this.urlDecision, 
      this.smsVendorResp, 
      this.creditCardBenefitOptionsList,});

  BenefitsListResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage = (json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null)!;
    urlDecision = json['urlDecision'];
    smsVendorResp = json['smsVendorResp'];
    if (json['creditCardBenefitOptionsList'] != null) {
      creditCardBenefitOptionsList = [];
      json['creditCardBenefitOptionsList'].forEach((v) {
        creditCardBenefitOptionsList?.add(CreditCardBenefitOptionsList?.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage?chMessage;
  dynamic urlDecision;
  dynamic smsVendorResp;
  List<CreditCardBenefitOptionsList>? creditCardBenefitOptionsList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['smsVendorResp'] = smsVendorResp;
    if (creditCardBenefitOptionsList != null) {
      map['creditCardBenefitOptionsList'] = creditCardBenefitOptionsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}