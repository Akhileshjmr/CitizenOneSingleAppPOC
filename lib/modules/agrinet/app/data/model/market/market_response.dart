import '../common/ch_message.dart';
import 'market_item.dart';

class MarketResponse {
  final String? reqSecureKey;
  final String? addiParams;
  final ChMessage? chMessage;
  final String? urlDecision;
  final List<MarketItem>? resp;
  final String? status;

  MarketResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.resp,
    this.status,
  });

  factory MarketResponse.fromJson(Map<String, dynamic> json) {
    return MarketResponse(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      resp:
          json['resp'] != null
              ? (json['resp'] as List)
                  .map((e) => MarketItem.fromJson(e))
                  .toList()
              : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reqSecureKey': reqSecureKey,
    'addiParams': addiParams,
    'chMessage': chMessage?.toJson(),
    'urlDecision': urlDecision,
    'resp': resp?.map((e) => e.toJson()).toList(),
    'status': status,
  };
}
