// =============================================================================
// AppMessageDialog  —  ORGANISM
// -----------------------------------------------------------------------------
// A blocking, single-action modal for success/error/warning/info messages —
// the modal counterpart to the inline AppAlertBanner, for spots that need to
// interrupt the user rather than show an inline/toast message. Built on the
// same icon/color system as Alert.svg (via AppAlertIcon) since the SVG
// itself has no dialog example to copy pixel-for-pixel; button uses the
// existing AppButton atom.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/app_alert_dialog_shell.dart';

class AppMessageDialog {
  AppMessageDialog._();

  static Future<void> show(
    BuildContext context, {
    required AppAlertType type,
    required String title,
    required String message,
    String primaryLabel = 'OK',
    VoidCallback? onPrimary,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AppAlertDialogShell(
        type: type,
        title: title,
        message: message,
        actions: [
          AppButton(
            text: primaryLabel,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onPrimary?.call();
            },
          ),
        ],
      ),
    );
  }
}
