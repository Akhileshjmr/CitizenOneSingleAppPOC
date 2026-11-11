import '../../../../modules/profile/ProfileStatusResp.dart';
import 'PrdInsurList.dart';

class AutoProdInsuranceResponse {
  AutoProdInsuranceResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.filterVal,
    this.custCode,
    this.requestId,
    this.leadId,
    this.orderId,
    this.prdInsurList,
    this.status,
    this.prodCode,
    this.prodName,
  });

  AutoProdInsuranceResponse.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    filterVal = json['filterVal'];
    custCode = json['custCode'];
    requestId = json['requestId'];
    leadId = json['leadId'];
    orderId = json['orderId'];
    if (json['prdInsurList'] != null) {
      prdInsurList = [];
      json['prdInsurList'].forEach((v) {
        prdInsurList?.add(PrdInsurList.fromJson(v));
      });
    }
    status = json['status'];
    prodCode = json['prodCode'];
    prodName = json['prodName'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic filterVal;
  dynamic custCode;
  dynamic requestId;
  int? leadId;
  dynamic orderId;
  List<PrdInsurList>? prdInsurList;
  String? status;
  String? prodCode;
  String? prodName;

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
    map['custCode'] = custCode;
    map['requestId'] = requestId;
    map['leadId'] = leadId;
    map['orderId'] = orderId;
    if (prdInsurList != null) {
      map['prdInsurList'] = prdInsurList?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    map['prodCode'] = this.prodCode;
    map['prodName'] = this.prodName;
    return map;
  }
}
