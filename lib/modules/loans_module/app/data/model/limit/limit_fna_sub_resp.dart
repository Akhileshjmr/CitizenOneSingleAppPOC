import '../common/ch_message.dart';

class LimitFnaSubResp {
  final String? reqSecureKey;
  final String? firstName;
  final int? monthlyIncome;
  final List<String> addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final dynamic value;
  final String? otp;
  final dynamic downPayment;
  final String? status;
  final String? flowStatus;

  const LimitFnaSubResp({
    this.reqSecureKey,
    this.firstName,
    this.monthlyIncome,
    this.addiParams = const [],
    this.chMessage,
    this.urlDecision,
    this.value,
    this.otp,
    this.downPayment,
    this.status,
    this.flowStatus,
  });

  factory LimitFnaSubResp.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LimitFnaSubResp();

    return LimitFnaSubResp(
      reqSecureKey: json['reqSecureKey'] as String?,
      firstName: json['firstName'] as String?,
      monthlyIncome: json['monthlyIncome'] as int?,
      addiParams:
          json['addiParams'] != null
              ? List<String>.from(json['addiParams'])
              : const [],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'])
              : null,
      urlDecision: json['urlDecision'],
      value: json['value'],
      otp: json['otp'] as String?,
      downPayment: json['downPayment'],
      status: json['status'] as String?,
      flowStatus: json['flowStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'reqSecureKey': reqSecureKey,
    'firstName': firstName,
    'monthlyIncome': monthlyIncome,
    'addiParams': addiParams,
    'chMessage': chMessage?.toJson(),
    'urlDecision': urlDecision,
    'value': value,
    'otp': otp,
    'downPayment': downPayment,
    'status': status,
    'flowStatus': flowStatus,
  };
}
