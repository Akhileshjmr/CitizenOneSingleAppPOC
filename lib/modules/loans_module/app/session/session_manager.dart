import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/session/services/session_api.dart';

// SessionExpiryMonitor import removed (deprecated)

import '../app_environment.dart';
import '../components/utils/app_snackbar.dart';
import '../data/local/store/user_provider.dart';
import '../routes/app_pages.dart';
import 'models/session_payload.dart';
import 'module_navigation_coordinator.dart';
import 'services/session_service.dart';
import 'session_warning_dialog.dart';

enum SessionTerminationReason {
  expired,
  userExited,
  moduleCleanup,
  unauthorized,
  moduleDetached,
}

class SessionManager extends GetxService {
  // Public method that the expired dialog can call to finalize logout after user presses OK.
  Future<void> acknowledgeExpired() async {
    // This method should only run after the expired dialog has been shown.
    if (!_hasShownExpiredDialog) return;
    // Ensure we only run termination once.
    await _terminateSession(
      reason: SessionTerminationReason.expired,
      returnToParent: true,
      showExpiredDialog: false,
    );
  }

  SessionManager({
    required SessionService sessionService,
    required ModuleNavigationCoordinator navigationCoordinator,
    DateTime Function()? nowProvider,
  }) : _sessionService = sessionService,
       _navigationCoordinator = navigationCoordinator,
       _nowProvider = nowProvider ?? DateTime.now;

  static const Duration warningThreshold = Duration(seconds: 30);

  final SessionService _sessionService;
  final ModuleNavigationCoordinator _navigationCoordinator;
  final DateTime Function() _nowProvider;

  final RxnString _sessionToken = RxnString();
  final Rxn<DateTime> _issuedAt = Rxn<DateTime>();
  final Rxn<DateTime> _expiresAt = Rxn<DateTime>();
  final Rx<Duration> _remainingDuration = Duration.zero.obs;
  final RxBool _isRefreshing = false.obs;
  Timer? _countdownTimer;

  bool get isRefreshing => _isRefreshing.value;

  bool _warningShown = false;
  bool _hasShownExpiredDialog = false;
  bool _isTerminating = false;
  bool _hasExpired = false;

  String? get sessionToken => _sessionToken.value;
  DateTime? get issuedAt => _issuedAt.value;
  DateTime? get expiresAt => _expiresAt.value;
  Duration get remainingDuration => _calculateRemaining();
  Duration get remainingDurationValue => _remainingDuration.value;
  bool get hasActiveSession =>
      sessionToken != null && sessionToken!.isNotEmpty && expiresAt != null;

  // Refresh session when user chooses to continue
  Future<void> refreshSession() async {
    if (_isRefreshing.value) return;
    _isRefreshing.value = true;
    try {
      final token = sessionToken;
      if (token == null || token.isEmpty) {
        throw const SessionException('No active session to refresh.');
      }

      // Call service to refresh token
      final newSession = await _sessionService.refreshSession(
        sessionToken: token,
      );

      // Apply new session data and restart timers
      _applySession(newSession);
      // Updated to use timer-based session handling
      stopSessionTimers();
      startSessionTimers(newSession.validitySeconds);

      // Dismiss warning dialog if open
      await SessionWarningDialog.closeWarningIfOpen();
    } on SessionException catch (e, stack) {
      debugPrint('Session refresh failed: $e\n$stack');
      appSnackbar(message: e.message, snackbarState: SnackbarState.warning);
      // If refresh indicates invalid session, terminate
      await _terminateSession(
        reason: SessionTerminationReason.unauthorized,
        returnToParent: true,
        showExpiredDialog: true,
      );
    } catch (e, stack) {
      debugPrint('Unexpected error during session refresh: $e\n$stack');
      appSnackbar(
        message: 'Failed to refresh session.',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      _isRefreshing.value = false;
    }
  }

  String get remainingTimeLabel {
    final totalSeconds = _remainingDuration.value.inSeconds.clamp(0, 359999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Existing create session method remains unchanged
  Future<void> createSession({required String phoneNumber}) async {
    SessionApi.sessionSecureKey = phoneNumber;
    await _prepareForNewSession(phoneNumber: phoneNumber);

    try {
      final session = await _sessionService.createSession();
      _applySession(session);
      // Updated to use timer-based session handling
      startSessionTimers(session.validitySeconds);
    } on SessionException catch (error, stackTrace) {
      _clearSessionState();
      debugPrint('Session creation failed: $error\n$stackTrace');
      appSnackbar(message: error.message, snackbarState: SnackbarState.warning);
      rethrow;
    } catch (error, stackTrace) {
      _clearSessionState();
      debugPrint('Session creation failed: $error\n$stackTrace');
      appSnackbar(
        message: 'Unable to create session.',
        snackbarState: SnackbarState.warning,
      );
      throw const SessionException('Unable to create session.');
    }
  }

  Future<void> deleteSession() async {
    final activeToken = sessionToken;
    if (activeToken == null || activeToken.isEmpty) {
      return;
    }

    try {
      await _sessionService.deleteSession(sessionToken: activeToken);
    } catch (error, stackTrace) {
      debugPrint('Delete session failed: $error\n$stackTrace');
    }
  }

  // -----------------------------------------------------------------
  // Timer based session handling – uses backend `validitySeconds`
  // -----------------------------------------------------------------
  Timer? _warningTimer;
  Timer? _expiryTimer;
  int? _validitySeconds;

  /// Public API to stop session timers
  void stopSessionTimers() {
    _cancelTimers();
  }

  /// Public API to start session timers with given validity seconds
  void startSessionTimers(int validitySeconds) {
    _validitySeconds = validitySeconds;
    _scheduleTimers();
  }

  void _cancelTimers() {
    _warningTimer?.cancel();
    _expiryTimer?.cancel();
    _countdownTimer?.cancel();

    _warningTimer = null;
    _expiryTimer = null;
    _countdownTimer = null;
  }

  void _scheduleTimers() {
    _cancelTimers();

    final secs = _validitySeconds ?? 0;
    if (secs <= 0) return;

    _remainingDuration.value = Duration(seconds: secs);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = Duration(
        seconds: _remainingDuration.value.inSeconds - 1,
      );

      _remainingDuration.value =
          remaining.isNegative ? Duration.zero : remaining;

      if (!_warningShown &&
          _remainingDuration.value.inSeconds <= warningThreshold.inSeconds &&
          _remainingDuration.value.inSeconds > 0) {
        _showWarning();
      }

      if (_remainingDuration.value == Duration.zero) {
        timer.cancel();
      }
    });

    _warningTimer = Timer(
      Duration(seconds: secs - warningThreshold.inSeconds),
      _showWarning,
    );

    _expiryTimer = Timer(Duration(seconds: secs), _expireSession);
  }

  void _showWarning() {
    if (_hasExpired || _warningShown) return;

    _warningShown = true;

    unawaited(SessionWarningDialog.showWarning(this));
  }

  void _expireSession() async {
    if (_hasExpired) return;
    _hasExpired = true;
    _hasShownExpiredDialog = true;
    await SessionWarningDialog.showExpiredDialog();
    // No navigation here – user must press OK which calls acknowledgeExpired()
  }

  Future<void> exitModule({Object? result}) async {
    await _terminateSession(
      reason: SessionTerminationReason.userExited,
      returnToParent: true,
      result: result,
    );
  }

  Future<void> cleanupSession() async {
    await _terminateSession(
      reason: SessionTerminationReason.moduleCleanup,
      returnToParent: false,
    );
  }

  Future<void> handleUnauthorizedResponse({int? statusCode}) async {
    await _terminateSession(
      reason: SessionTerminationReason.unauthorized,
      returnToParent: true,
      showExpiredDialog: true,
    );
  }

  Future<void> handleModuleDetached() async {
    // If the expiry alert (expired or warning) is already displayed, we must not
    // terminate the session again – otherwise the alert gets dismissed.
    if (_hasShownExpiredDialog || _warningShown) {
      debugPrint('handleModuleDetached ignored – alert already shown.');
      return;
    }
    // If a session is active and not yet expired, ignore detach to keep the
    // warning/expiry UI alive.
    if (hasActiveSession && !_hasExpired) {
      debugPrint('handleModuleDetached ignored – active session remains.');
      return;
    }
    // No active session (or already expired without dialog shown), proceed with cleanup.
    await _terminateSession(
      reason: SessionTerminationReason.moduleDetached,
      returnToParent: false,
    );
  }

  void _onMonitorTick(Duration remaining) {
    final sanitized =
        remaining.isNegative
            ? Duration.zero
            : Duration(seconds: remaining.inSeconds);
    _remainingDuration.value = sanitized;

    if (!_warningShown &&
        sanitized.inSeconds > 0 &&
        sanitized.inSeconds <= warningThreshold.inSeconds) {
      _warningShown = true;
      unawaited(SessionWarningDialog.showWarning(this));
    }

    if (sanitized == Duration.zero && !_hasExpired) {
      _hasExpired = true;
      // Mark that we are about to show the expired dialog so the UI knows not to call it again.
      _hasShownExpiredDialog = true;
      unawaited(
        _terminateSession(
          reason: SessionTerminationReason.expired,
          returnToParent: true,
          showExpiredDialog: true,
        ),
      );
    }
  }

  Future<void> _prepareForNewSession({required String phoneNumber}) async {
    if (hasActiveSession || _isTerminating) {
      await _terminateSession(
        reason: SessionTerminationReason.moduleCleanup,
        returnToParent: false,
      );
    }

    await UserProvider.onLogout();
    await UserProvider.saveMobile(phoneNumber);
  }

  void _applySession(SessionPayload session) {
    _sessionToken.value = session.sessionToken;
    _issuedAt.value = session.issuedAt;
    _expiresAt.value = session.expiresAt;
    _remainingDuration.value = _calculateRemaining();
    _warningShown = false;
    _hasExpired = false;
  }

  /// Update session information from a payload returned by any API response.
  /// This refreshes the timers without calling the explicit refresh endpoint.
  void updateSessionFromPayload() {
    stopSessionTimers();
    startSessionTimers(_validitySeconds ?? 60);
  }

  Future<void> _terminateSession({
    required SessionTerminationReason reason,
    required bool returnToParent,
    bool showExpiredDialog = false,
    Object? result,
  }) async {
    if (_isTerminating) {
      return;
    }

    _isTerminating = true;

    try {
      stopSessionTimers();
      await deleteSession();
      _clearSessionState();
      await _closeAllDialogsAndOverlays();

      if (showExpiredDialog) {
        await SessionWarningDialog.showExpiredDialog();
      }

      await UserProvider.onLogout();

      if (AppEnvironment.isEmbeddedInHostApp) {
        if (returnToParent) {
          await _navigationCoordinator.closeModule(result: result);
        }
      } else {
        // Standalone launch: navigate to login screen and clear stack
        Get.offAllNamed(Routes.LOANS_LOGIN);
      }
    } finally {
      _isTerminating = false;
    }
  }

  Future<void> _closeAllDialogsAndOverlays() async {
    Get.closeAllSnackbars();
    await SessionWarningDialog.closeWarningIfOpen();

    final overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      return;
    }

    Navigator.of(
      overlayContext,
      rootNavigator: true,
    ).popUntil((route) => route is! PopupRoute);
  }

  void _clearSessionState() {
    _sessionToken.value = null;
    _issuedAt.value = null;
    _expiresAt.value = null;
    _remainingDuration.value = Duration.zero;
    _warningShown = false;
    _hasExpired = false;
    stopSessionTimers();
  }

  Duration _calculateRemaining() {
    final expiry = expiresAt;
    if (expiry == null) {
      return Duration.zero;
    }

    final remaining = expiry.difference(_nowProvider().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
