import '../common/ch_message.dart';

class SaveEmiResp {
  SaveEmiResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.bankProductId,
    this.bankId,
    this.loanCalculatorId,
  });

  SaveEmiResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    bankProductId = json['bankProductId'];
    bankId = json['bankId'];
    loanCalculatorId = json['loanCalculatorId'];
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  int? bankProductId;
  int? bankId;
  int? loanCalculatorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['bankProductId'] = bankProductId;
    map['bankId'] = bankId;
    map['loanCalculatorId'] = loanCalculatorId;
    return map;
  }
}
