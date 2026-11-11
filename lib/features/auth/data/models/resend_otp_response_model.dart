import 'change_password_response_model.dart' show ChMessage;

/// Response DTO for the agent user service `POST /password/resend-otp`
/// endpoint. The success payload has `data` containing the timer/
/// cooldown/attempts metadata the UI uses to drive the resend button.
class ResendOtpResponseModel {
  final String? reqSecureKey;
  final List<dynamic>? addiParams;
  final ChMessage chMessage;
  final ResendOtpData? data;

  const ResendOtpResponseModel({
    this.reqSecureKey,
    this.addiParams,
    required this.chMessage,
    this.data,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      reqSecureKey: json['reqSecureKey'] as String?,
      addiParams: json['addiParams'] as List<dynamic>?,
      chMessage: ChMessage.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      data: json['data'] == null
          ? null
          : ResendOtpData.fromJson(
              (json['data'] as Map).cast<String, dynamic>(),
            ),
    );
  }

  bool get isSuccess => chMessage.code == 'SUCCESS' && !chMessage.isError;
}

class ResendOtpData {
  final int? otpExpiresInSeconds;
  final int? resendCooldownSeconds;
  final int? maxAttempts;
  final int? attemptsRemaining;

  const ResendOtpData({
    this.otpExpiresInSeconds,
    this.resendCooldownSeconds,
    this.maxAttempts,
    this.attemptsRemaining,
  });

  factory ResendOtpData.fromJson(Map<String, dynamic> json) => ResendOtpData(
    otpExpiresInSeconds: (json['otpExpiresInSeconds'] as num?)?.toInt(),
    resendCooldownSeconds: (json['resendCooldownSeconds'] as num?)?.toInt(),
    maxAttempts: (json['maxAttempts'] as num?)?.toInt(),
    attemptsRemaining: (json['attemptsRemaining'] as num?)?.toInt(),
  );
}
