class TrackOrderRequest {
  String? reqSecureKey;
  String? filterVal;
  List<String>? addiParams;

  TrackOrderRequest({
    this.reqSecureKey,
    this.filterVal,
    this.addiParams,
  });

  @override
  String toString() {
    return 'TrackOrderRequest{reqSecureKey: $reqSecureKey, filterVal: $filterVal, addiParams: $addiParams}';
  }

  TrackOrderRequest.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    filterVal = json['filterVal'];
    addiParams = json["addiParams"] == null
        ? []
        : List<String>.from(json["addiParams"].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reqSecureKey'] = reqSecureKey;
    data['filterVal'] = filterVal;
    data['addiParams'] = addiParams;
    return data;
  }
}
