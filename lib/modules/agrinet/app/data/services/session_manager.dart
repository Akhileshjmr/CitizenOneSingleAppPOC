import 'dart:async';

import 'package:citizenone_app/modules/agrinet/app/data/remote/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../agrinet_module.dart';
import '../../components/ui/ag_alert_dialogue.dart';
import '../../components/utils/user_prefs.dart';
import '../model/user/refresh_token_response.dart';

class SessionManager {
  // -----------------------------
  // SINGLETON
  // -----------------------------

  SessionManager._internal();

  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  static int sessionDuration = 2;

  // -----------------------------
  // DYNAMIC CONFIG (RUNTIME SAFE)
  // -----------------------------

  /// Full session timeout
  Duration get sessionTimeout => Duration(minutes: sessionDuration);

  /// Show warning only if session > 20 sec
  Duration get warningBefore =>
      sessionTimeout > const Duration(seconds: 20)
          ? const Duration(seconds: 20)
          : Duration.zero;

  // -----------------------------
  // STATE
  // -----------------------------

  Timer? _sessionTimer;
  Timer? _warningTimer;
  Timer? _countdownTimer;

  bool _isDialogOpen = false;
  int _secondsLeft = 20;

  // -----------------------------
  // PUBLIC API
  // -----------------------------

  void start() => _resetTimers();

  void notifyUserActivity() => _resetTimers();

  void stop() => _cancelAllTimers();

  void forceLogout() => _logout();

  // -----------------------------
  // TIMER MANAGEMENT
  // -----------------------------

  void _resetTimers() {
    _cancelAllTimers();

    // Main session expiry
    _sessionTimer = Timer(sessionTimeout, _onSessionExpired);

    // Warning timer only if > 20 sec
    if (warningBefore > Duration.zero) {
      final warningTime = sessionTimeout - warningBefore;

      if (!warningTime.isNegative) {
        _warningTimer = Timer(warningTime, _showWarningDialog);
      }
    }
  }

  void _cancelAllTimers() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    _countdownTimer?.cancel();

    _sessionTimer = null;
    _warningTimer = null;
    _countdownTimer = null;

    _isDialogOpen = false;
  }

  // -----------------------------
  // WARNING DIALOG
  // -----------------------------

  void _showWarningDialog() {
    if (!UserPrefs.isLoggedIn()) return;
    if (_isDialogOpen) return;
    if (Get.context == null) return;
    if (warningBefore == Duration.zero) return;

    _isDialogOpen = true;
    _secondsLeft = warningBefore.inSeconds;

    Get.dialog(_buildDialog(), barrierDismissible: false);

    _startCountdown();
  }

  Widget _buildDialog() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
      },
      child: StatefulBuilder(
        builder: (context, setState) {
          return AgAlertDialog.confirmWidget(
            title: "Session Expiring",
            message:
                "Your session will expire in $_secondsLeft seconds.\nContinue session?",
            okText: "Yes",
            cancelText: "No",
            onConfirm: () async {
              _closeDialog();
              await _refreshSession();
            },
            onCancel: () {
              _closeDialog();
              _logout();
              AgrinetModule.finish('return_to_guest_user');
            },
          );
        },
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsLeft--;

      if (_secondsLeft <= 0) {
        timer.cancel();
        _logout();
      }

      if (Get.isDialogOpen ?? false) {
        Get.forceAppUpdate();
      }
    });
  }

  void _closeDialog() {
    _countdownTimer?.cancel();
    _countdownTimer = null;

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    _isDialogOpen = false;
  }

  // -----------------------------
  // SESSION HANDLING
  // -----------------------------

  Future<void> _refreshSession() async {
    try {
      final RefreshTokenResponse? response =
          await AuthProvider.refreshSessionToken();

      final token = response?.token;

      if (token != null && token.isNotEmpty) {
        await UserPrefs.updateToken(token);

        // Restart timers
        _resetTimers();
      } else {
        _logout();
      }
    } catch (e) {
      debugPrint('Session refresh failed: $e');
      _logout();
    }
  }

  void _onSessionExpired() {
    AgrinetModule.finish('return_to_guest_user');
    _logout();
  }

  void _logout() {
    stop();
    UserPrefs.clearDataLogout();
  }
}
