class AddressDetailsRequest {
  String? filterVal;
  String? reqSecureKey;
  List<String>? addiParams;

  AddressDetailsRequest({this.filterVal, this.reqSecureKey, this.addiParams});

  @override
  String toString() {
    return 'AddressDetailsRequest{filterVal: $filterVal, reqSecureKey: $reqSecureKey, addiParams: $addiParams}';
  }

  AddressDetailsRequest.fromJson(Map<String, dynamic> json) {
    filterVal = json['filterVal'];
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filterVal'] = filterVal;
    data['reqSecureKey'] = reqSecureKey;
    data['addiParams'] = addiParams;
    return data;
  }
}