import '../../common_models/HeaderInfo.dart';
import 'GdbMerchantDisProductList.dart';

class GdbMerchantDisProductPurRequest {
  HeaderInfo? headerInfo;
  String? integrationID;
  String? userName;
  int? storeId;

  String? mobileNumber;
  String? nationalId;
  String? loanBookDate;
  List<GdbMerchantDisProductList>? productList;

  GdbMerchantDisProductPurRequest({
    this.headerInfo,
    this.integrationID,
    this.userName,
    this.storeId,
    this.mobileNumber,
    this.nationalId,
    this.loanBookDate,
    this.productList,
  });

  factory GdbMerchantDisProductPurRequest.fromJson(Map<String, dynamic> json) {
    return GdbMerchantDisProductPurRequest(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      integrationID: json['integrationID'],
      userName: json['userName'],
      storeId: json['storeId'],
      mobileNumber: json['mobileNumber'],
      nationalId: json['nationalId'],
      loanBookDate: json['loanBookDate'],
      productList: json['productList'] != null
          ? (json['productList'] as List)
          .map((e) => GdbMerchantDisProductList.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'integrationID': integrationID,
      'userName': userName,
      'storeId': storeId,
      'mobileNumber': mobileNumber,
      'nationalId': nationalId,
      'loanBookDate': loanBookDate,
      'productList': productList?.map((e) => e.toJson()).toList(),
    };
  }
}

