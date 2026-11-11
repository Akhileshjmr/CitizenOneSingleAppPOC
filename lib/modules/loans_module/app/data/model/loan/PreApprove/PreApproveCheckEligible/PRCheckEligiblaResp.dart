import '../../../common/ch_message.dart';
import 'BankImage.dart';

class PrCheckEligiblaResp {
  PrCheckEligiblaResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.submittedToBank,
    this.limitApproved,
    this.limitActivated,
    this.currencyCode,
    this.bankImage,
  });

  PrCheckEligiblaResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    submittedToBank = json['submittedToBank'];
    limitApproved = json['limitApproved'];
    limitActivated = json['limitActivated'];
    currencyCode = json['currencyCode'];
    bankImage =
        json['bankImage'] != null
            ? BankImage.fromJson(json['bankImage'])
            : null;
  }
  dynamic reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  bool? submittedToBank;
  bool? limitApproved;
  bool? limitActivated;
  String? currencyCode;
  BankImage? bankImage;

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
    map['submittedToBank'] = submittedToBank;
    map['limitApproved'] = limitApproved;
    map['limitActivated'] = limitActivated;
    map['currencyCode'] = currencyCode;
    if (bankImage != null) {
      map['bankImage'] = bankImage?.toJson();
    }
    return map;
  }
}
