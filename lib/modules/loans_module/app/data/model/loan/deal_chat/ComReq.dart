import 'Paging.dart';

class ComReq {
  ComReq({
      this.reqSecureKey, 
      this.filterVal, 
      this.addiParams, 
      this.hKey, 
      this.filterHashKey, 
      this.paging,});

  ComReq.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    filterVal = json['filterVal'];
    addiParams = json['addiParams'];
    hKey = json['hKey'];
    filterHashKey = json['filterHashKey'];
    paging = json['paging'] != null ? Paging.fromJson(json['paging']) : null;
  }
  dynamic reqSecureKey;
  dynamic filterVal;
  dynamic addiParams;
  dynamic hKey;
  dynamic filterHashKey;
  Paging? paging;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['filterVal'] = filterVal;
    map['addiParams'] = addiParams;
    map['hKey'] = hKey;
    map['filterHashKey'] = filterHashKey;
    if (paging != null) {
      map['paging'] = paging?.toJson();
    }
    return map;
  }

}