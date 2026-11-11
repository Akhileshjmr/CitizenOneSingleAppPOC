import '../../../remote/provider/personal_loan/personal_loan_features_list.dart';
import '../../common/ch_message.dart';

class PlFeaturesResp {
  PlFeaturesResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    required this.personalLoanFeaturesList,
  });

  PlFeaturesResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    otp = json['otp'];
    if (json['personalLoanFeaturesList'] != null) {
      personalLoanFeaturesList = [];
      json['personalLoanFeaturesList'].forEach((v) {
        personalLoanFeaturesList?.add(PersonalLoanFeaturesList.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  dynamic otp;
  List<PersonalLoanFeaturesList>? personalLoanFeaturesList;

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
    if (personalLoanFeaturesList != null) {
      map['personalLoanFeaturesList'] =
          personalLoanFeaturesList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
