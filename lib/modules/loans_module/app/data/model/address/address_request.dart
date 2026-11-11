class AddressDropdownRequest {
  String? filterVal;
  String? reqSecureKey;

  AddressDropdownRequest({this.filterVal, this.reqSecureKey});

  @override
  String toString() {
    return 'AddressDropdownRequest{filterVal: $filterVal, reqSecureKey: $reqSecureKey}';
  }

  AddressDropdownRequest.fromJson(Map<String, dynamic> json) {
    filterVal = json['filterVal'];
    reqSecureKey = json['reqSecureKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filterVal'] = filterVal;
    data['reqSecureKey'] = reqSecureKey;
    return data;
  }
}
