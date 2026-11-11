/// Response DTO for the agent user service `POST /session/create`
/// endpoint. Mirrors the wire contract documented in the Agent Login
/// API integration guide.
///
/// The wire shape is:
///
/// ```json
/// {
///   "reqSecureKey": null,
///   "addiParams": null,
///   "chMessage": { "code": "SUCCESS", "isError": false, ... },
///   "data": {
///     "sessionToken": "..." | null,
///     "issuedAt":     "..." | null,
///     "expiresAt":    "..." | null,
///     "validitySeconds": 180 | 0,
///     "mustChangePassword": true | false
///   }
/// }
/// ```
///
/// The authoritative business-success indicator is `chMessage.code ==
/// 'SUCCESS'` combined with `!chMessage.isError`. The `data` payload
/// may legitimately have `sessionToken: null` (e.g. when the user
/// must change their password before a normal session is issued), so
/// callers MUST NOT treat a missing `sessionToken` as a failure.
class LoginResponseModel {
  final String? reqSecureKey;
  final List<dynamic>? addiParams;
  final ChMessage chMessage;
  final SessionValue? value;

  const LoginResponseModel({
    this.reqSecureKey,
    this.addiParams,
    required this.chMessage,
    this.value,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      reqSecureKey: json['reqSecureKey'] as String?,
      addiParams: json['addiParams'] as List<dynamic>?,
      chMessage: ChMessage.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      // The agent API returns the session payload under `data`, not
      // `value`. (The `value` key was a mis-read of the contract.)
      value: json['data'] == null
          ? null
          : SessionValue.fromJson(
              (json['data'] as Map).cast<String, dynamic>(),
            ),
    );
  }

  /// True when the API reports a successful business outcome.
  ///
  /// This is the only signal that matters — see class docs.
  bool get isSuccess => chMessage.code == 'SUCCESS' && !chMessage.isError;

  /// Convenience: a non-null [SessionValue] whose `sessionToken` is
  /// non-empty. The repository uses this to decide whether to persist
  /// the session to local storage.
  bool get hasAuthenticatedSession {
    final token = value?.sessionToken;
    return token != null && token.isNotEmpty;
  }
}

class ChMessage {
  final String code;
  final String message;
  final String type;
  final String dispType;
  final bool isError;
  final String? subject;
  final List<dynamic>? dataArr;

  const ChMessage({
    required this.code,
    required this.message,
    required this.type,
    required this.dispType,
    required this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
    code: json['code'] as String? ?? '',
    message: json['message'] as String? ?? '',
    type: json['type'] as String? ?? '',
    dispType: json['dispType'] as String? ?? '',
    isError: json['isError'] as bool? ?? false,
    subject: json['subject'] as String?,
    dataArr: json['dataArr'] as List<dynamic>?,
  );
}

class SessionValue {
  /// May be `null` when the API is signalling `mustChangePassword:
  /// true` before a normal session is issued.
  final String? sessionToken;
  final String? issuedAt;
  final String? expiresAt;
  final int? validitySeconds;
  final bool mustChangePassword;
  final String? userType;

  const SessionValue({
    this.sessionToken,
    this.issuedAt,
    this.expiresAt,
    this.validitySeconds,
    this.mustChangePassword = false,
    this.userType,
  });

  factory SessionValue.fromJson(Map<String, dynamic> json) => SessionValue(
    sessionToken: json['sessionToken'] as String?,
    issuedAt: json['issuedAt'] as String?,
    expiresAt: json['expiresAt'] as String?,
    validitySeconds: (json['validitySeconds'] as num?)?.toInt(),
    mustChangePassword: json['mustChangePassword'] as bool? ?? false,
    userType: json['userType'] as String?,
  );
}
