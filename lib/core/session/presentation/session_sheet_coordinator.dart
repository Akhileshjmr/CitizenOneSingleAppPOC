import 'package:citizenone_app/core/session/presentation/widgets/session_expired_sheet.dart';
import 'package:citizenone_app/core/session/presentation/widgets/session_expiring_sheet.dart';
import 'package:flutter/material.dart';

/// Centralizes showing/dismissing the global session sheets so
/// "Expiring Soon" and "Expired" never stack, and so a listener that
/// fires multiple times in quick succession (e.g. repeated
/// `reportPossibleExpiry` calls) never opens a second sheet.
class SessionSheetCoordinator {
  bool _sheetOpen = false;

  Future<void> showExpiringSoon(BuildContext rootContext) async {
    if (_sheetOpen) return;
    _sheetOpen = true;
    await showModalBottomSheet<void>(
      context: rootContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => const SessionExpiringSheet(),
    );
    _sheetOpen = false;
  }

  Future<void> showExpired(BuildContext rootContext) async {
    if (_sheetOpen) {
      Navigator.of(rootContext, rootNavigator: true).pop();
    }
    _sheetOpen = true;
    await showModalBottomSheet<void>(
      context: rootContext,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => const SessionExpiredSheet(),
    );
    _sheetOpen = false;
  }

  /// Dismisses whichever sheet is currently open, if any. Used when
  /// the session is cleared out from under the UI (e.g. "Continue
  /// Session" succeeded, or logout happened via some other path).
  void dismissIfOpen(BuildContext rootContext) {
    if (!_sheetOpen) return;
    Navigator.of(rootContext, rootNavigator: true).pop();
    _sheetOpen = false;
  }
}
