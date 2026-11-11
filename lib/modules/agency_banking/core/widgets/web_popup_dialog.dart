import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

/// Web-only (>=600px) centered modal for showCustomBottomPopup, styled to
/// match the Desktop-16/26 designs — close (X) top-right, icon in a soft
/// tinted circle, title + description, outlined pill "Continue" button.
/// Kept separate from _MobileBottomPopupContent (bottom sheet, purple
/// outline) so mobile's design/behavior is never touched while editing this.
class WebPopupDialog extends StatelessWidget {
  const WebPopupDialog({
    super.key,
    required this.message,
    required this.isSessionError,
    required this.isPasswordExpired,
    required this.isFirstTimeLogin,
    required this.onConfirm,
    required this.onClose,
  });

  final String? message;
  final bool isSessionError;
  final bool isPasswordExpired;
  final bool isFirstTimeLogin;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  ({IconData icon, Color iconColor, Color iconBg, String? title}) get _content {
    if (isPasswordExpired) {
      return (
        icon: Icons.shield_outlined,
        iconColor: AppColors.kF59E0B,
        iconBg: AppColors.kFFF8E1,
        title: "Password Expired",
      );
    }
    if (isSessionError) {
      return (
        icon: Icons.timer_off_outlined,
        iconColor: AppColors.k613AF5,
        iconBg: AppColors.kEEF2FF,
        title: "Session Expired",
      );
    }
    if (isFirstTimeLogin) {
      return (
        icon: Icons.shield_outlined,
        iconColor: AppColors.kF59E0B,
        iconBg: AppColors.kFFF8E1,
        title: "Password Setup Required",
      );
    }
    return (
      icon: Icons.error_outline,
      iconColor: AppColors.appPrimaryRedColor,
      iconBg: AppColors.kFEF2F2,
      title: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _content;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isSessionError)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 18),
                    color: AppColors.textSecondary,
                    style: IconButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderLight),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: c.iconBg, shape: BoxShape.circle),
                child: Icon(c.icon, size: 34, color: c.iconColor),
              ),
              const SizedBox(height: 20),
              if (c.title != null) ...[
                Text(
                  c.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: AppColors.textPrimary),
                  ),
                  onPressed: onConfirm,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
