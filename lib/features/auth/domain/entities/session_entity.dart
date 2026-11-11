/// Domain entity representing the result of a successful login.
///
/// Returned by [AuthRepository.login] on success. The token is the
/// `sessionToken` from the agent user service `POST /session/create`
/// endpoint. Other session metadata (expiry, mustChangePassword) is
/// preserved so the presentation layer can react to them.
///
/// When the API reports `mustChangePassword: true`, the session is
/// returned without a real `sessionToken` (the token is issued only
/// after the agent has completed the change-password flow). The
/// `sessionToken` is therefore nullable; the `mustChangePassword`
/// flag is the source of truth for "is the agent authenticated yet?".
class SessionEntity {
  final String? sessionToken;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final int? validitySeconds;
  final bool mustChangePassword;
  final String? userType;

  const SessionEntity({
    this.sessionToken,
    this.issuedAt,
    this.expiresAt,
    this.validitySeconds,
    this.mustChangePassword = false,
    this.userType,
  });

  /// True when the API actually returned a real (non-empty) session
  /// token. False for the `mustChangePassword: true` case where the
  /// agent still needs to complete the change-password flow.
  bool get hasToken => sessionToken != null && sessionToken!.isNotEmpty;
}
