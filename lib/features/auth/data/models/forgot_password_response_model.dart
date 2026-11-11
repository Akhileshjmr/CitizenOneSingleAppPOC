import 'change_password_response_model.dart' show ChMessage;

/// Response DTO for the agent user service `POST /password/forgot`
/// endpoint.
///
/// The `data` field is intentionally typed as a nullable dynamic value
/// because the wire contract varies across the agent API: older flows
/// returned a human-readable `String`, while the current contract
/// returns a structured object carrying the OTP timer / cooldown /
/// attempts metadata the UI needs to drive the OTP screen.
///
/// Wire contract:
/// ```json
/// {
///   "chMessage": { "code": "SUCCESS", "isError": false, ... },
///   "data": {
///     "otpExpiresInSeconds": 600,
///     "resendCooldownSeconds": 90,
///     "maxAttempts": 5,
///     "attemptsRemaining": 5
///   }
/// }
/// ```
class ForgotPasswordResponseModel {
  final ChMessage chMessage;
  final dynamic data;

  const ForgotPasswordResponseModel({required this.chMessage, this.data});

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      chMessage: ChMessage.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      // `data` may be a String (legacy), a Map (current), or null/absent.
      // We keep it as `dynamic` so the parser never throws on a
      // unexpected shape — the call site can branch on `data.runtimeType`
      // if it needs the structured view.
      data: json['data'],
    );
  }

  /// True when the API reports a successful business outcome.
  ///
  /// The authoritative indicators are `chMessage.code == 'SUCCESS'` and
  /// `chMessage.isError == false`. A missing/null `data` does NOT mean
  /// failure — some successful responses omit it.
  bool get isSuccess => chMessage.code == 'SUCCESS' && !chMessage.isError;

  /// Structured view of `data` when the API returned the timer object.
  /// Returns `null` when `data` is not a Map.
  ForgotPasswordTimerData? get timerData {
    final raw = data;
    if (raw is Map) {
      return ForgotPasswordTimerData.fromJson(raw.cast<String, dynamic>());
    }
    return null;
  }
}

/// Timer / cooldown / attempts metadata returned by
/// `POST /password/forgot` and `POST /password/resend-otp`.
class ForgotPasswordTimerData {
  final int? otpExpiresInSeconds;
  final int? resendCooldownSeconds;
  final int? maxAttempts;
  final int? attemptsRemaining;

  const ForgotPasswordTimerData({
    this.otpExpiresInSeconds,
    this.resendCooldownSeconds,
    this.maxAttempts,
    this.attemptsRemaining,
  });

  factory ForgotPasswordTimerData.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordTimerData(
        otpExpiresInSeconds: (json['otpExpiresInSeconds'] as num?)?.toInt(),
        resendCooldownSeconds: (json['resendCooldownSeconds'] as num?)?.toInt(),
        maxAttempts: (json['maxAttempts'] as num?)?.toInt(),
        attemptsRemaining: (json['attemptsRemaining'] as num?)?.toInt(),
      );
}
