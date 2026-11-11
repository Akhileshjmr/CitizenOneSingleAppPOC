import '../../common_models/HeaderInfo.dart';
import '../../common_models/ServerMessage.dart';
import 'GdbMerchantDisProductPurList.dart';

class GdbMerchantDisProductPurResponse {
  HeaderInfo? headerInfo;
  ServerMessage? resMessage;

  String? responseCode;
  String? responseDesc;

  List<GdbMerchantDisProductPurList>? productPurchaseList;

  GdbMerchantDisProductPurResponse({
    this.headerInfo,
    ServerMessage? resMessage,
    this.responseCode,
    this.responseDesc,
    this.productPurchaseList,
  }) : resMessage = resMessage ?? ServerMessage();

  factory GdbMerchantDisProductPurResponse.fromJson(
      Map<String, dynamic> json) {
    return GdbMerchantDisProductPurResponse(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : ServerMessage(),
      responseCode: json['responseCode'],
      responseDesc: json['responseDesc'],
      productPurchaseList: json['productPurchaseList'] != null
          ? (json['productPurchaseList'] as List)
          .map((e) => GdbMerchantDisProductPurList.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo?.toJson(),
      'resMessage': resMessage?.toJson(),
      'responseCode': responseCode,
      'responseDesc': responseDesc,
      'productPurchaseList':
      productPurchaseList?.map((e) => e.toJson()).toList(),
    };
  }
}

