import 'change_password_response_model.dart' show ChMessage;

/// Response DTO for the agent user service `POST /password/verify-otp`
/// endpoint. The success payload has `data: {}` (empty object), so the
/// `data` field is intentionally optional.
class VerifyOtpResponseModel {
  final String? reqSecureKey;
  final List<dynamic>? addiParams;
  final ChMessage chMessage;
  final Map<String, dynamic>? data;

  const VerifyOtpResponseModel({
    this.reqSecureKey,
    this.addiParams,
    required this.chMessage,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      reqSecureKey: json['reqSecureKey'] as String?,
      addiParams: json['addiParams'] as List<dynamic>?,
      chMessage: ChMessage.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      data: (json['data'] as Map?)?.cast<String, dynamic>(),
    );
  }

  bool get isSuccess => chMessage.code == 'SUCCESS' && !chMessage.isError;

  /// Attempts remaining, reported by the API on both success and
  /// failure payloads. Null when the endpoint doesn't surface it.
  int? get attemptsRemaining => (data?['attemptsRemaining'] as num?)?.toInt();
}
