import 'GdbStoreDetails.dart';

class GdbVendorList {
  int? vendorId;
  String? vendorName;
  String? integrationId;
  int? category;
  List<GdbStoreDetails>? storeList;

  GdbVendorList({
    this.vendorId,
    this.vendorName,
    this.integrationId,
    this.category,
    this.storeList,
  });

  factory GdbVendorList.fromJson(Map<String, dynamic> json) {
    return GdbVendorList(
      vendorId: json['vendorId'],
      vendorName: json['vendorName'],
      integrationId: json['integrationId'],
      category: json['category'],
      storeList: (json['storeList'] as List<dynamic>?)
          ?.map((e) => GdbStoreDetails.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'integrationId': integrationId,
      'category': category,
      'storeList': storeList?.map((e) => e.toJson()).toList(),
    };
  }
}
