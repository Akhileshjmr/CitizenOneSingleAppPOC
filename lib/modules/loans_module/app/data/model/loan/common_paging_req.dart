import 'package:citizenone_app/modules/loans_module/app/data/model/loan/paging_req.dart';

class CommonPagingReq {
  PagingReq? paging = PagingReq();
  String? reqSecureKey;
  String? filterVal;
  List<String>? addiParams;
  int? filterHashKey;
  int? hKey;

  CommonPagingReq({
    this.paging,
    this.reqSecureKey,
    this.filterVal,
    this.addiParams,
    this.filterHashKey,
    this.hKey,
  });

  @override
  String toString() {
    return 'CommonPagingReq{paging: $paging, reqSecureKey: $reqSecureKey, filterVal: $filterVal, addiParams: $addiParams, filterHashKey: $filterHashKey, hKey: $hKey}';
  }

  CommonPagingReq.fromJson(Map<String, dynamic> json) {
    paging = PagingReq.fromJson(json['paging']);
    reqSecureKey = json['reqSecureKey'];
    filterVal = json['filterVal'];
    addiParams =
        json["addiParams"] == null
            ? []
            : List<String>.from(json["addiParams"].map((x) => x));
    filterHashKey = json['filterHashKey'];
    hKey = json['hKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (paging != null) {
      data['paging'] = paging!.toJson();
    }
    data['reqSecureKey'] = reqSecureKey;
    data['filterVal'] = filterVal;
    data['addiParams'] = addiParams;
    data['filterHashKey'] = filterHashKey;
    data['hKey'] = hKey;
    return data;
  }
}
