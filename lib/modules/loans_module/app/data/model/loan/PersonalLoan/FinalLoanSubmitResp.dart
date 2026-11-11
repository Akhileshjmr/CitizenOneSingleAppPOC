import '../../common/ch_message.dart';

class FinalLoanSubmitResp {
  FinalLoanSubmitResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.custName,
    this.refNumber,
    this.bankLogo,
    this.bankName,
    this.status,
    this.reqLaonAmount,
  });

  FinalLoanSubmitResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    custName = json['custName'];
    refNumber = json['refNumber'];
    bankLogo = json['bankLogo'];
    bankName = json['bankName'];
    status = json['status'];
    reqLaonAmount = json['reqLaonAmount'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  String? custName;
  String? refNumber;
  String? bankLogo;
  String? bankName;
  String? status;
  int? reqLaonAmount;

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
    map['custName'] = custName;
    map['refNumber'] = refNumber;
    map['bankLogo'] = bankLogo;
    map['bankName'] = bankName;
    map['status'] = status;
    map['reqLaonAmount'] = reqLaonAmount;
    return map;
  }
}
