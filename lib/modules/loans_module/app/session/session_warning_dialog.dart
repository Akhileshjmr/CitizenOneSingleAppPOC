import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/ui/ag_alert_dialogue.dart';
import 'session_manager.dart';

class SessionWarningDialog {
  static bool _warningVisible = false;

  static Future<void> showWarning(SessionManager sessionManager) async {
    if (_warningVisible || Get.overlayContext == null) {
      return;
    }

    _warningVisible = true;

    // Use dynamic dialog content so remaining time updates reactively
    await AgAlertDialog.showDynamic(
      title: 'Session Expiry Warning',
      content: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your session will expire soon.'),
            const SizedBox(height: 16),
            Text(
              sessionManager.remainingTimeLabel,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      buttonText: 'Continue Session',
      onOk: () {
        unawaited(sessionManager.refreshSession());
      },
    ).whenComplete(() => _warningVisible = false);
  }

  static Future<void> closeWarningIfOpen() async {
    if (!_warningVisible || Get.overlayContext == null) {
      _warningVisible = false;
      return;
    }

    Navigator.of(
      Get.overlayContext!,
      rootNavigator: true,
    ).popUntil((route) => route is! PopupRoute);
    _warningVisible = false;
  }

  static Future<void> showExpiredDialog() async {
    if (Get.overlayContext == null) {
      return;
    }

    await AgAlertDialog.show(
      title: 'Session Expired',
      message: 'Your session has expired.',
      buttonText: 'OK',
      onOk: () {
        final manager = Get.find<SessionManager>();
        manager.acknowledgeExpired();
      },
    );
  }
}
