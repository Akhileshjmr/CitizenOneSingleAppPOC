import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:citizenone_app/features/auth/domain/entities/session_entity.dart';

part 'session_state.freezed.dart';

/// Lifecycle phases of the global session.
enum SessionStatus {
  /// No session has been established yet (pre-login / after logout).
  idle,

  /// A session is active and well outside the expiry warning window.
  active,

  /// The session is inside the final [SessionCubit.warnBeforeExpirySeconds]
  /// window — the "Session Expiring Soon" sheet should be visible.
  expiringSoon,

  /// The session has expired (or the backend reported it as invalid) —
  /// the "Session Expired" sheet should be visible and no further
  /// authenticated requests should be attempted with the old token.
  expired,
}

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    @Default(SessionStatus.idle) SessionStatus status,
    SessionEntity? session,
    @Default(0) int secondsRemaining,
    @Default(false) bool isRefreshing,
  }) = _SessionState;
}
