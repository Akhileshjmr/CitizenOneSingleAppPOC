import '../common/ch_message.dart';
import '../user/url_decision.dart';
import 'address_det_resp.dart';

class ViewAddressResp {
  String? reqSecureKey;
  List<String>? addiParams;
  late ChMessage chMessage;
  UrlDecision? urlDecision;
  String? value;
  List<AddressDelResp>? credezeAddressDet;

  ViewAddressResp({
    this.reqSecureKey,
    this.addiParams,
    required this.chMessage,
    this.urlDecision,
    this.value,
    this.credezeAddressDet,
  });

  @override
  String toString() {
    return 'ViewAddressResp{reqSecureKey: $reqSecureKey, addiParams: $addiParams, chMessage: $chMessage, urlDecision: $urlDecision, value: $value, credezeAddressDet: $credezeAddressDet}';
  }

  ViewAddressResp.fromJson(Map<String, dynamic> json) {
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
    credezeAddressDet =
        (json['credezeAddressDet'] != null)
            ? List<AddressDelResp>.from(
              json["credezeAddressDet"].map((x) => AddressDelResp.fromJson(x)),
            )
            : [];
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
    if (credezeAddressDet != null) {
      data['credezeAddressDet'] =
          credezeAddressDet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
