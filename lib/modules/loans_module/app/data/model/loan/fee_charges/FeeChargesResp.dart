import '../../common/ch_message.dart';
import 'FeesAndCharges.dart';

class FeeChargesResp {
  FeeChargesResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.filterVal,
    this.feesAndCharges,
    this.totalFeeAndCharge,
    this.totalCharge,
  });

  FeeChargesResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    filterVal = json['filterVal'];
    if (json['feesAndCharges'] != null) {
      feesAndCharges = [];
      json['feesAndCharges'].forEach((v) {
        feesAndCharges?.add(FeesAndCharges.fromJson(v));
      });
    }
    totalCharge = json['totalCharge'];
    totalFeeAndCharge = json['totalFeeAndCharge'];
  }
  dynamic reqSecureKey;
  List<String?>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic filterVal;
  List<FeesAndCharges>? feesAndCharges;
  String? totalCharge;
  String? totalFeeAndCharge;

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
    if (feesAndCharges != null) {
      map['feesAndCharges'] = feesAndCharges?.map((v) => v.toJson()).toList();
    }
    map['totalCharge'] = totalCharge;
    map['totalFeeAndCharge'] = totalFeeAndCharge;
    return map;
  }
}
