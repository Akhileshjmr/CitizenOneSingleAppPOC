import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Final screen of the forgot-password flow. Tapping **Login Now**
/// navigates to `/login` (no auto-authentication) so the user can
/// sign in with their new password.
class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key});

  void _onLoginNow(BuildContext context) {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: tokens.shadowMd,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.check,
                          size: 48,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: AppText(
                        context.l10n.passwordSuccessTitle,
                        style: AppTextStyle.headlineMedium,
                        fontWeight: FontWeight.w800,
                        color: tokens.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: AppText(
                        context.l10n.passwordSuccessBody,
                        style: AppTextStyle.bodyMedium,
                        color: tokens.textSecondary,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: context.l10n.passwordSuccessLogin,
                      onPressed: () => _onLoginNow(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
