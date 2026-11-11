import '../common/ch_message.dart';

class OtpVerificationResponse {
  dynamic reqSecureKey;
  dynamic addiParams;
  dynamic urlDecision;

  String? otpId;
  String? otp;
  bool? isDefaultOtp;

  int? attemptRemaining;
  int? validityTime;

  dynamic expiryTime;
  dynamic lockedTime;

  String? status;
  String? channel;
  String? destination;

  bool? isLocked;
  int? resentCount;

  ChMessage? chMessage;

  OtpVerificationResponse({
    this.reqSecureKey,
    this.addiParams,
    this.urlDecision,
    this.otpId,
    this.otp,
    this.isDefaultOtp,
    this.attemptRemaining,
    this.validityTime,
    this.expiryTime,
    this.lockedTime,
    this.status,
    this.channel,
    this.destination,
    this.isLocked,
    this.resentCount,
    this.chMessage,
  });

  OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    urlDecision = json['urlDecision'];

    otpId = json['otpId']?.toString();
    otp = json['otp']?.toString();
    isDefaultOtp = json['isDefaultOtp'];

    attemptRemaining = json['attemptRemaining'];
    validityTime = json['validityTime'];

    expiryTime = json['expiryTime'];
    lockedTime = json['lockedTime'];

    status = json['status'];
    channel = json['channel'];
    destination = json['destination'];

    isLocked = json['isLocked'];
    resentCount = json['resentCount'];

    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    map['urlDecision'] = urlDecision;

    map['otpId'] = otpId;
    map['otp'] = otp;
    map['isDefaultOtp'] = isDefaultOtp;

    map['attemptRemaining'] = attemptRemaining;
    map['validityTime'] = validityTime;

    map['expiryTime'] = expiryTime;
    map['lockedTime'] = lockedTime;

    map['status'] = status;
    map['channel'] = channel;
    map['destination'] = destination;

    map['isLocked'] = isLocked;
    map['resentCount'] = resentCount;

    if (chMessage != null) {
      map['chMessage'] = chMessage!.toJson();
    }

    return map;
  }
}
