// =============================================================================
// AppConfirmationDialog  —  ORGANISM
// -----------------------------------------------------------------------------
// Two-action (Cancel / Confirm) modal for destructive or important actions —
// logout, delete, session-timeout style confirmations. None of these exist
// as concrete call sites in the app yet, but the component is ready: same
// icon/color system as AppAlertBanner/AppMessageDialog (Alert.svg has no
// button-dialog example to copy directly), buttons reuse AppButton.
//
// Usage:
//   final confirmed = await AppConfirmationDialog.show(
//     context,
//     type: AppAlertType.warning,
//     title: 'Log out?',
//     message: 'You will need to sign in again to continue.',
//     confirmLabel: 'Log out',
//     isDestructive: true,
//   );
//   if (confirmed) { ... }
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/app_alert_dialog_shell.dart';

class AppConfirmationDialog {
  AppConfirmationDialog._();

  static Future<bool> show(
    BuildContext context, {
    required AppAlertType type,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppAlertDialogShell(
        type: type,
        title: title,
        message: message,
        actions: [
          AppButton(
            text: confirmLabel,
            variant: isDestructive
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
          const SizedBox(height: 12),
          AppButton(
            text: cancelLabel,
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
