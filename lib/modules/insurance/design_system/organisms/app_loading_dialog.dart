// =============================================================================
// AppLoadingDialog  —  ORGANISM
// -----------------------------------------------------------------------------
// A single shared "processing…" modal, replacing two byte-for-byte identical
// private `_showGlobalLoader` methods that previously lived in
// desktop_payment_panel.dart and motor_insurance_payment_bottom_sheet.dart.
// Visual output is unchanged from the original (centered white rounded box +
// CircularProgressIndicator) — this is a de-duplication, not a redesign.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';

class AppLoadingDialog {
  AppLoadingDialog._();

  static bool _isShowing = false;

  static Future<void> show(BuildContext context) {
    if (_isShowing) return Future<void>.value();
    _isShowing = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const PopScope(
        canPop: false,
        child: _AppLoadingDialogContent(),
      ),
    ).whenComplete(() => _isShowing = false);
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _AppLoadingDialogContent extends StatelessWidget {
  const _AppLoadingDialogContent();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
