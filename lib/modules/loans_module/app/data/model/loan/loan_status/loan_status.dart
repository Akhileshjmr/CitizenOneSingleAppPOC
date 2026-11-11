import '../../common/ch_message.dart';
import 'application_submission.dart';

class LoanStatus {
  LoanStatus({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.applicationSubmitted,
  });

  LoanStatus.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    if (json['applicationSubmitted'] != null) {
      applicationSubmitted = [];
      json['applicationSubmitted'].forEach((v) {
        applicationSubmitted!.add(ApplicationSubmitted.fromJson(v));
      });
    }
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  List<ApplicationSubmitted>? applicationSubmitted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    if (applicationSubmitted != null) {
      map['applicationSubmitted'] =
          applicationSubmitted?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
