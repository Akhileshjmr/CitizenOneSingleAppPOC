import 'package:flutter/material.dart';

import '../../../../../core/widgets/form/app_text.dart';

/// A small colored pill with an icon and label — e.g. "Due", "Overdue",
/// "Approved". Generic on purpose: this isn't loan-specific, so it's
/// reusable anywhere the app needs a status indicator (KYC status,
/// application status, transaction status, ...).
///
/// TODO: once you add matching tokens to AppColors (e.g.
/// `AppColors.statusAmberBg`/`statusAmberFg`, `statusGreenBg`/`Fg`),
/// swap the hardcoded colors in [AppStatusBadge.amber] / [.green] below
/// for those, so this stays consistent with the "no hardcoded hex"
/// convention the rest of the app follows.
class AppStatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon = Icons.error_outline,
  });

  /// Amber variant — matches the first "Due" pill in the reference
  /// screenshot (loan needs attention soon).
  factory AppStatusBadge.amber(String label) => AppStatusBadge(
        label: label,
        backgroundColor: const Color(0xFFFBEBD0),
        foregroundColor: const Color(0xFFB4690E),
        icon: Icons.error_outline,
      );

  /// Green variant — matches the second "Due" pill in the reference
  /// screenshot (loan is in good standing / due date further out).
  factory AppStatusBadge.green(String label) => AppStatusBadge(
        label: label,
        backgroundColor: const Color(0xFFDFF5E3),
        foregroundColor: const Color(0xFF1E8E3E),
        icon: Icons.check_circle_outline,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          AppText(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
