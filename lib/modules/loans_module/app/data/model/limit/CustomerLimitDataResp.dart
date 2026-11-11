

import 'package:citizenone_app/modules/loans_module/app/data/model/common/ch_message.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/CurrLimit.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/deal_chat/Paging.dart';

class CustomerLimitDataResp {
  CustomerLimitDataResp({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value, 
      this.otp, 
      this.paging, 
      this.limitList, 
      this.currLimit, 
      this.loanList,});

  CustomerLimitDataResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    paging = json['paging'] != null ? Paging.fromJson(json['paging']) : null;
    limitList = json['limitList'];
    currLimit = json['currLimit'] != null ? CurrLimit.fromJson(json['currLimit']) : null;
    loanList = json['loanList'];
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  Paging? paging;
  dynamic limitList;
  CurrLimit? currLimit;
  dynamic loanList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['otp'] = otp;
    if (paging != null) {
      map['paging'] = paging?.toJson();
    }
    map['limitList'] = limitList;
    if (currLimit != null) {
      map['currLimit'] = currLimit?.toJson();
    }
    map['loanList'] = loanList;
    return map;
  }

}