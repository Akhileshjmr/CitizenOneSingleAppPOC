import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Global "Session Expired" bottom sheet — shown by
/// [SessionSheetCoordinator] regardless of the current screen
/// (including from inside the Insurance module). Non-dismissible: the
/// user must explicitly tap "Log In Again" (no tap-outside, swipe, or
/// back-button dismissal).
class SessionExpiredSheet extends StatelessWidget {
  const SessionExpiredSheet({super.key});

  Future<void> _onLoginAgain(BuildContext context) async {
    // Same canonical logout sequence as `SessionExpiringSheet`/
    // `insurance_sidebar.dart`'s `showLogoutDialog` — clears the
    // expired session, then returns explicitly to CitizenOne login.
    Navigator.of(context, rootNavigator: true).pop();
    await context.read<AuthCubit>().logout();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return PopScope(
      canPop: false,
      child: Container(
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
                // Drag handle (decorative only — enableDrag is false)
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

                // Lock icon in soft amber circle
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: tokens.warning.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.lock, size: 36, color: tokens.warning),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: AppText(
                    'Session Expired',
                    style: AppTextStyle.headlineSmall,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                Center(
                  child: AppText(
                    'Your session has expired. Please sign in again to '
                    'continue using the application.',
                    style: AppTextStyle.bodyMedium,
                    textAlign: TextAlign.center,
                    color: tokens.textSecondary,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 24),

                AppButton(
                  text: 'Log In Again',
                  onPressed: () => _onLoginAgain(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
