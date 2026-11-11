import '../../common/ch_message.dart';
import 'Attrs.dart';
import 'ProductDetails.dart';

class PlCompareProductResp {
  PlCompareProductResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.productDetails,
    this.attrs,
  });

  PlCompareProductResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    if (json['productDetails'] != null) {
      productDetails = [];
      json['productDetails'].forEach((v) {
        productDetails?.add(ProductDetails.fromJson(v));
      });
    }
    if (json['attrs'] != null) {
      attrs = [];
      json['attrs'].forEach((v) {
        attrs?.add(Attrs.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  List<ProductDetails>? productDetails;
  List<Attrs>? attrs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['otp'] = otp;
    if (productDetails != null) {
      map['productDetails'] = productDetails?.map((v) => v.toJson()).toList();
    }
    if (attrs != null) {
      map['attrs'] = attrs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
