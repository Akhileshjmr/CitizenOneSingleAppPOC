class GdbStoreDetails {
  int? storeId;
  String? storeName;

  GdbStoreDetails({this.storeId, this.storeName});

  factory GdbStoreDetails.fromJson(Map<String, dynamic> json) {
    return GdbStoreDetails(
      storeId: json['storeId'],
      storeName: json['storeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
    };
  }
}
