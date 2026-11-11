import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/molecules/app_alert_banner.dart';

/// Toast-style notifications, rendered as the AppAlertBanner "toast" shape
/// (Alert.svg) inside a transparent SnackBar. Signature is unchanged from
/// before this migration — every existing call site keeps compiling — with
/// one new optional `type` to pick the Alert.svg color/icon (defaults to
/// [AppAlertType.info], matching the previous neutral look).
class Snack {
  /// Desktop/web toasts are capped to this width and centered in the
  /// viewport (matches AppAlertBanner's own toast maxWidth). Mobile keeps
  /// the full-width bar by leaving [SnackBar.width] unset.
  static const double _desktopWebWidth = 420;

  /// Extra bottom gap added on desktop/web so the floating toast sits
  /// ~24-32px above the bottom edge instead of hugging it (on top of the
  /// SnackBar's own default inset).
  static const double _desktopWebExtraBottomGap = 20;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppAlertType type = AppAlertType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Mirrors AppRouter's own desktop-shell gate (`context.isMobile`), so
    // the toast switches layout at the same breakpoint as the rest of the
    // app's desktop/web vs. mobile chrome.
    final isDesktopWeb = !context.isMobile;

    Widget content = AppAlertBanner(
      type: type,
      shape: AppAlertShape.toast,
      title: title ?? _defaultTitleFor(type),
      message: message,
      onDismiss: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
    );
    if (isDesktopWeb) {
      content = Padding(
        padding: const EdgeInsets.only(bottom: _desktopWebExtraBottomGap),
        child: content,
      );
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: content,
          duration: duration,
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.zero,
          width: isDesktopWeb ? _desktopWebWidth : null,
        ),
      );
  }

  static String _defaultTitleFor(AppAlertType type) {
    switch (type) {
      case AppAlertType.success:
        return 'Success';
      case AppAlertType.warning:
        return 'Warning';
      case AppAlertType.error:
        return 'Error';
      case AppAlertType.info:
        return 'Notice';
    }
  }
}
