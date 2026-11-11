import '../../../common/ch_message.dart';

class PrCalculatorResp {
  PrCalculatorResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.filterVal,
    this.message,
    this.customerName,
    this.tenure,
    this.isEligible,
  });

  PrCalculatorResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    filterVal = json['filterVal'];
    message = json['message'];
    customerName = json['customerName'];
    tenure = json['tenure'];
    isEligible = json['isEligible'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic filterVal;
  String? message;
  dynamic customerName;
  int? tenure;
  bool? isEligible;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['filterVal'] = filterVal;
    map['message'] = message;
    map['customerName'] = customerName;
    map['tenure'] = tenure;
    map['isEligible'] = isEligible;
    return map;
  }
}
