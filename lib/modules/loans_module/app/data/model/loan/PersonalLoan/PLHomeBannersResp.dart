import '../../common/ch_message.dart';
import 'Banners.dart';

class PlHomeBanners {
  PlHomeBanners({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    required this.banners,
    this.themeType,
    this.dimensions,
  });

  PlHomeBanners.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(Banners.fromJson(v));
      });
    }
    themeType = json['themeType'];
    dimensions = json['dimensions'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  List<Banners>? banners;
  dynamic themeType;
  dynamic dimensions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    if (banners != null) {
      map['banners'] = banners?.map((v) => v?.toJson()).toList();
    }
    map['themeType'] = themeType;
    map['dimensions'] = dimensions;
    return map;
  }
}
