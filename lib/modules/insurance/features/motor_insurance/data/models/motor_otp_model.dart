class MotorOtpRequestModel {
  final String purpose;
  final String referenceType;
  final List<String> addiParams;

  const MotorOtpRequestModel({
    required this.purpose,
    required this.referenceType,
    required this.addiParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose,
      'referenceType': referenceType,
      'addiParams': addiParams,
    };
  }
}

class MotorOtpVerifyRequestModel {
  final String channel;
  final String destination;
  final String purpose;
  final String referenceType;
  final String otp;

  const MotorOtpVerifyRequestModel({
    required this.channel,
    required this.destination,
    required this.purpose,
    required this.referenceType,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'destination': destination,
      'purpose': purpose,
      'referenceType': referenceType,
      'otp': otp,
    };
  }
}

class MotorOtpResponseModel {
  final MotorOtpMessage? chMessage;
  final MotorOtpData? data;

  const MotorOtpResponseModel({
    this.chMessage,
    this.data,
  });

  factory MotorOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return MotorOtpResponseModel(
      chMessage: json['chMessage'] != null
          ? MotorOtpMessage.fromJson(
              json['chMessage'] as Map<String, dynamic>,
            )
          : null,
      data: json['data'] != null
          ? MotorOtpData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MotorOtpVerifyResponseModel {
  final MotorOtpMessage? chMessage;
  final MotorOtpVerifyData? data;

  const MotorOtpVerifyResponseModel({
    this.chMessage,
    this.data,
  });

  factory MotorOtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return MotorOtpVerifyResponseModel(
      chMessage: json['chMessage'] != null
          ? MotorOtpMessage.fromJson(
              json['chMessage'] as Map<String, dynamic>,
            )
          : null,
      data: json['data'] != null
          ? MotorOtpVerifyData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MotorOtpData {
  final String? otpId;
  final String? otp;
  final String? status;
  final int? attemptRemaining;
  final int? validityTime;
  final String? channel;
  final String? destination;
  final bool isLocked;
  final int? resentCount;
  final bool isDefaultOtp;
  final MotorOtpMessage? chMessage;

  const MotorOtpData({
    this.otpId,
    this.otp,
    this.status,
    this.attemptRemaining,
    this.validityTime,
    this.channel,
    this.destination,
    this.isLocked = false,
    this.resentCount,
    this.isDefaultOtp = false,
    this.chMessage,
  });

  factory MotorOtpData.fromJson(Map<String, dynamic> json) {
    return MotorOtpData(
      otpId: json['otpId']?.toString(),
      otp: json['otp']?.toString(),
      status: json['status'] as String?,
      attemptRemaining: (json['attemptRemaining'] as num?)?.toInt(),
      validityTime: (json['validityTime'] as num?)?.toInt(),
      channel: json['channel'] as String?,
      destination: json['destination']?.toString(),
      isLocked: json['isLocked'] as bool? ?? false,
      resentCount: (json['resentCount'] as num?)?.toInt(),
      isDefaultOtp: json['isDefaultOtp'] as bool? ?? false,
      chMessage: json['chMessage'] != null
          ? MotorOtpMessage.fromJson(
              json['chMessage'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MotorOtpVerifyData {
  final String? status;
  final bool isLocked;
  final int? attemptRemaining;
  final MotorOtpMessage? chMessage;

  const MotorOtpVerifyData({
    this.status,
    this.isLocked = false,
    this.attemptRemaining,
    this.chMessage,
  });

  factory MotorOtpVerifyData.fromJson(Map<String, dynamic> json) {
    return MotorOtpVerifyData(
      status: json['status'] as String?,
      isLocked: json['isLocked'] as bool? ?? false,
      attemptRemaining: (json['attemptRemaining'] as num?)?.toInt(),
      chMessage: json['chMessage'] != null
          ? MotorOtpMessage.fromJson(
              json['chMessage'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MotorOtpMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;
  final String? subject;

  const MotorOtpMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
  });

  factory MotorOtpMessage.fromJson(Map<String, dynamic> json) {
    return MotorOtpMessage(
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool?,
      subject: json['subject'] as String?,
    );
  }
}
