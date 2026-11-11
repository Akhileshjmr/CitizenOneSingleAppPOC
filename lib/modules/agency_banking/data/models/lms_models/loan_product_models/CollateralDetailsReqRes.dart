import '../customer_registration_models/L2lMobMessage.dart';
import 'CollateralPoolNameList.dart';

class CollateralDetailsReqRes {
  String? reqSecureKey;
  L2lMobMessage? chMessage;
  String? collateralType;
  List<CollateralPoolNameList>? lstCollateral;

  CollateralDetailsReqRes({
    this.reqSecureKey,
    this.chMessage,
    this.collateralType,
    this.lstCollateral,
  });

  factory CollateralDetailsReqRes.fromJson(Map<String, dynamic> json) {
    return CollateralDetailsReqRes(
      reqSecureKey: json['reqSecureKey'],
      chMessage: json['chMessage'] != null
          ? L2lMobMessage.fromJson(json['chMessage'])
          : null,
      collateralType: json['collateralType'],
      lstCollateral: (json['lstCollateral'] as List<dynamic>?)
          ?.map((e) => CollateralPoolNameList.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'chMessage': chMessage?.toJson(),
      'collateralType': collateralType,
      'lstCollateral': lstCollateral?.map((e) => e.toJson()).toList(),
    };
  }
}

