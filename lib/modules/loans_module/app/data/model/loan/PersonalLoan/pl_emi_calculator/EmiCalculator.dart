import 'ChMessage.dart';

class EmiCalculator {
  EmiCalculator({
      this.reqSecureKey, 
      this.addiParams, 
      this.chMessage, 
      this.urlDecision, 
      this.value, 
      this.otp, 
      this.loanEmi, 
      this.totalInterest, 
      this.totalPayment,});

  EmiCalculator.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'] != null ? json['addiParams'].cast<String>() : [];
    chMessage = json['chMessage'] != null ? ChMessage.fromJson(json['chMessage']) : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    loanEmi = json['loanEmi'];
    totalInterest = json['totalInterest'];
    totalPayment = json['totalPayment'];
  }
  String? reqSecureKey;
  List<String>? addiParams;
  ChMessage? chMessage;
  String? urlDecision;
  String? value;
  String? otp;
  int? loanEmi;
  int? totalInterest;
  int? totalPayment;

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
    map['loanEmi'] = loanEmi;
    map['totalInterest'] = totalInterest;
    map['totalPayment'] = totalPayment;
    return map;
  }

}