/// Minimal contract a host application implements so this module's
/// networking layer can attach the host's live session token without
/// depending on any of the host's concrete session/auth types.
///
/// This module never creates, stores, or refreshes a session itself —
/// the host (CitizenOne) owns the session lifecycle. This interface is
/// the only seam between the two.
abstract class SessionTokenProvider {
  /// The current session token, or `null`/empty if there is none.
  ///
  /// Must be synchronous and non-blocking (backed by in-memory state,
  /// never a disk read) because Dio's `onRequest` needs it instantly.
  String? get currentToken;

  /// Called when a response looks like it was rejected due to an
  /// expired/invalid session. The host decides how to react (e.g. show
  /// its own "session expired" UI); this module does not attempt to
  /// handle it itself.
  void reportPossibleExpiry();

  /// Called whenever an authenticated API call from this module
  /// completes successfully. The host treats this as user activity and
  /// restarts its single global inactivity timer — this module has no
  /// timer of its own. Must not be called for failed/expired responses
  /// (see [reportPossibleExpiry] for those).
  void reportActivity();
}
