import '../../modules/profile/ProfileStatusResp.dart';
import 'otp/url_decision.dart';

class CredezeCommonResp {
  String? reqSecureKey;
  List<String>? addiParams;
  late ChMessage chMessage;
  UrlDecision? urlDecision;
  String? value;

  @override
  String toString() =>
      'CredezeCommonResp{reqSecureKey: $reqSecureKey, addiParams: $addiParams, chMessage: $chMessage, urlDecision: $urlDecision, value: $value}';

  CredezeCommonResp.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json["addiParams"] == null
            ? []
            : List<String>.from(json["addiParams"].map((x) => x));
    chMessage = ChMessage.fromJson(json['chMessage']);
    urlDecision =
        json['urlDecision'] != null
            ? UrlDecision.fromJson(json['urlDecision'])
            : null;
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reqSecureKey'] = this.reqSecureKey;
    data['addiParams'] = addiParams;
    data['chMessage'] = this.chMessage.toJson();
    if (urlDecision != null) {
      data['urlDecision'] = urlDecision!.toJson();
    }
    data['value'] = this.value;
    return data;
  }
}
