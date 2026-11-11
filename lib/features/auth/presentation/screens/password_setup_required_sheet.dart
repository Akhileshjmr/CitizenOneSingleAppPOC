import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Bottom sheet shown after a successful agent login when the API
/// indicates the agent must change their password before accessing
/// the app.
///
/// On `Continue` the sheet dismisses and navigates to
/// `/auth/change-password` with the mobile number + temporary
/// password passed via `extra:`. On `Close` the sheet just dismisses.
class PasswordSetupRequiredSheet extends StatelessWidget {
  final String mobileNumber;
  final String currentPassword;

  const PasswordSetupRequiredSheet({
    super.key,
    required this.mobileNumber,
    required this.currentPassword,
  });

  /// Helper used by `LoginScreen` to show the sheet with the
  /// correct `extra:` payload.
  static Future<T?> show<T>(
    BuildContext context, {
    required String mobileNumber,
    required String currentPassword,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => PasswordSetupRequiredSheet(
        mobileNumber: mobileNumber,
        currentPassword: currentPassword,
      ),
    );
  }

  void _onContinue(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    context.go(
      '/auth/change-password',
      extra: {'mobileNumber': mobileNumber, 'currentPassword': currentPassword},
    );
  }

  void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: tokens.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Shield icon in soft purple circle
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: tokens.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.shield_check,
                    size: 36,
                    color: tokens.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: AppText(
                  context.l10n.passwordSetupRequiredTitle,
                  style: AppTextStyle.headlineSmall,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Body
              Center(
                child: AppText(
                  context.l10n.passwordSetupRequiredBody,
                  style: AppTextStyle.bodyMedium,
                  textAlign: TextAlign.center,
                  color: tokens.textSecondary,
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 24),

              // Continue button (outlined purple)
              PrimaryButton(
                text: context.l10n.passwordSetupRequiredContinue,
                variant: AppButtonVariant.outline,
                textColor: AppColors.primary,
                onPressed: () => _onContinue(context),
              ),
              const SizedBox(height: 8),

              // Close (text button)
              TextButton(
                onPressed: () => _onClose(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: AppText(
                  context.l10n.passwordSetupRequiredClose,
                  style: AppTextStyle.bodyMedium,
                  color: tokens.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
