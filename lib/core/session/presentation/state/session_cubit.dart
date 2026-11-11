import 'dart:async';

import 'package:citizenone_app/core/session/data/datasources/session_remote_data_source.dart';
import 'package:citizenone_app/features/auth/data/mappers/session_value_mapper.dart';
import 'package:citizenone_app/features/auth/domain/entities/session_entity.dart';
import 'package:citizenone_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/insurance/core/session/session_token_provider.dart';

import 'session_state.dart';

/// The single, global owner of the app's session lifecycle.
///
/// CitizenOne creates the session (on login) and this Cubit is the only
/// thing that tracks its expiry, refreshes it, and reacts to backend
/// signals that it's no longer valid. Both CitizenOne's own networking
/// layer and the external Insurance package read the current token
/// from this Cubit (via [SessionTokenProvider]) — neither module keeps
/// its own session state.
class SessionCubit extends Cubit<SessionState> implements SessionTokenProvider {
  final SessionRemoteDataSource _remoteDataSource;
  final AuthRepository _authRepository;

  /// Seconds before expiry at which the "Session Expiring Soon" sheet
  /// should appear. Configurable (not hardcoded) per the spec; backend
  /// `validitySeconds`/`expiresAt` remain the source of truth for the
  /// session's actual lifetime.
  final int warnBeforeExpirySeconds;

  Timer? _countdownTimer;
  DateTime? _expiresAt;
  Future<SessionEntity?>? _inFlightRefresh;

  SessionCubit({
    required SessionRemoteDataSource remoteDataSource,
    required AuthRepository authRepository,
    this.warnBeforeExpirySeconds = 30,
  }) : _remoteDataSource = remoteDataSource,
       _authRepository = authRepository,
       super(const SessionState());

  @override
  String? get currentToken => state.session?.sessionToken;

  /// Starts (or restarts) tracking the given session. Called after a
  /// successful login, after a successful refresh, and at app
  /// bootstrap when a persisted session is hydrated.
  void startSession(SessionEntity session) {
    if (!session.hasToken) return;

    _expiresAt = _resolveExpiresAt(session);
    _countdownTimer?.cancel();

    if (_expiresAt == null) {
      // No way to track expiry — keep the session active without a
      // countdown rather than guessing a duration.
      emit(
        state.copyWith(
          status: SessionStatus.active,
          session: session,
          secondsRemaining: 0,
          isRefreshing: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        session: session,
        isRefreshing: false,
        status: SessionStatus.active,
        secondsRemaining: _secondsUntil(_expiresAt!),
      ),
    );
    _tick();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// "Continue Session" — refreshes the session. Concurrent callers
  /// (e.g. a double-tap, or Insurance and CitizenOne both reacting to
  /// activity at once) all await the same in-flight request instead of
  /// issuing duplicate refresh calls.
  Future<void> continueSession() {
    final existing = _inFlightRefresh;
    if (existing != null) return existing.then((_) {});

    final token = state.session?.sessionToken;
    if (token == null || token.isEmpty) {
      _markExpired();
      return Future.value();
    }

    emit(state.copyWith(isRefreshing: true));
    final refreshFuture = _performRefresh(token);
    _inFlightRefresh = refreshFuture;
    return refreshFuture.then((_) {
      _inFlightRefresh = null;
    });
  }

  Future<SessionEntity?> _performRefresh(String token) async {
    try {
      final response = await _remoteDataSource.refreshSession(sessionToken: token);
      if (!response.isSuccess) {
        _markExpired();
        return null;
      }
      final session = mapSessionValueToEntity(response.value);
      if (!session.hasToken) {
        _markExpired();
        return null;
      }
      await _authRepository.saveSession(session);
      startSession(session);
      return session;
    } catch (_) {
      // Best-guess contract (§ session_remote_data_source.dart): any
      // failure to refresh is treated as the session being gone,
      // rather than distinguishing "expired" from "network blip" —
      // there is no confirmed backend signal to tell them apart yet.
      _markExpired();
      return null;
    }
  }

  /// Called by CitizenOne's and Insurance's networking layers when a
  /// response looks like the session is no longer valid. Idempotent —
  /// N concurrent callers only cause one transition, which is what
  /// keeps exactly one "Session Expired" sheet on screen.
  @override
  void reportPossibleExpiry() {
    if (state.status == SessionStatus.expired) return;
    _markExpired();
  }

  /// Called by CitizenOne's, Insurance's, and Agency Banking's
  /// networking layers whenever *any* authenticated API call they make
  /// succeeds. Restarts the single global inactivity countdown from the
  /// last known `validitySeconds` (whatever login/refresh most recently
  /// returned) — never a hardcoded value, and never the original
  /// login's fixed `expiresAt`, so repeated activity keeps extending
  /// the session by a full window each time instead of only running
  /// out the first window.
  ///
  /// No-ops when there is no active session to extend (idle/expired),
  /// or when the session has no numeric `validitySeconds` to restart
  /// from. Dart's single-threaded event loop means concurrent callers
  /// (CitizenOne/Insurance/Agency Banking APIs resolving around the
  /// same time) are naturally serialized here — each call cancels the
  /// previous timer before starting a new one, so there is always
  /// exactly one active timer using the latest reset.
  @override
  void reportActivity() {
    if (state.status == SessionStatus.idle ||
        state.status == SessionStatus.expired) {
      return;
    }

    final session = state.session;
    final validitySeconds = session?.validitySeconds;
    if (session == null || !session.hasToken) return;
    if (validitySeconds == null || validitySeconds <= 0) return;

    _expiresAt = DateTime.now().add(Duration(seconds: validitySeconds));
    _countdownTimer?.cancel();
    _tick();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// App moved to background/inactive — nothing to do; the countdown
  /// keeps running against wall-clock `expiresAt` regardless (OS timer
  /// throttling is corrected for on resume, see [appResumed]).
  void appBackgrounded() {}

  /// App resumed — recompute from wall-clock time rather than trusting
  /// the possibly-throttled tick counter, so a long background stint
  /// jumps straight to expired instead of showing a stale countdown.
  void appResumed() {
    if (_expiresAt == null || state.status == SessionStatus.idle) return;
    if (state.status == SessionStatus.expired) return;
    _tick();
  }

  /// Resets to a clean slate. Called on logout (including the forced
  /// logout from the Session Expired sheet) so no stale timer/token
  /// survives into the next login.
  void endSession() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _expiresAt = null;
    _inFlightRefresh = null;
    emit(const SessionState());
  }

  void _tick() {
    final expiresAt = _expiresAt;
    if (expiresAt == null) return;

    final remaining = _secondsUntil(expiresAt);
    if (remaining <= 0) {
      _markExpired();
      return;
    }

    final status = remaining <= warnBeforeExpirySeconds
        ? SessionStatus.expiringSoon
        : SessionStatus.active;
    emit(state.copyWith(status: status, secondsRemaining: remaining));
  }

  void _markExpired() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    emit(
      state.copyWith(
        status: SessionStatus.expired,
        secondsRemaining: 0,
        isRefreshing: false,
      ),
    );
  }

  int _secondsUntil(DateTime expiresAt) {
    final diff = expiresAt.difference(DateTime.now()).inSeconds;
    return diff < 0 ? 0 : diff;
  }

  DateTime? _resolveExpiresAt(SessionEntity session) {
    if (session.expiresAt != null) return session.expiresAt;
    final validity = session.validitySeconds;
    if (validity == null || validity <= 0) return null;
    final issuedAt = session.issuedAt ?? DateTime.now();
    return issuedAt.add(Duration(seconds: validity));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
