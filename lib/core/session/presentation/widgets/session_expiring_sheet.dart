import 'package:citizenone_app/core/session/presentation/state/session_cubit.dart';
import 'package:citizenone_app/core/session/presentation/state/session_state.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Global "Session Expiring Soon" bottom sheet — shown by
/// [SessionSheetCoordinator] regardless of the current screen
/// (including from inside the Insurance module). Not the Insurance
/// module's own UI; this is CitizenOne's global session chrome.
class SessionExpiringSheet extends StatelessWidget {
  const SessionExpiringSheet({super.key});

  Future<void> _onLogout(BuildContext context) async {
    // Mirrors `insurance_sidebar.dart`'s `showLogoutDialog` — the one
    // canonical logout sequence, reused rather than reinvented. The
    // explicit `context.go('/login')` (not a reliance on `AuthGate`)
    // matters here because this sheet can be shown from routes that
    // sit outside the authenticated `ShellRoute`/`AuthGate` subtree
    // (e.g. from inside the Insurance module).
    Navigator.of(context, rootNavigator: true).pop();
    await context.read<AuthCubit>().logout();
    if (context.mounted) context.go('/login');
  }

  String _formatCountdown(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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

              // Clock icon in soft amber circle
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: tokens.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.clock, size: 36, color: tokens.warning),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: AppText(
                  'Session Expiring Soon',
                  style: AppTextStyle.headlineSmall,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: AppText(
                  'Your session is about to expire due to inactivity. '
                  'Click Continue Session to remain signed in, or Logout '
                  'to end your session.',
                  style: AppTextStyle.bodyMedium,
                  textAlign: TextAlign.center,
                  color: tokens.textSecondary,
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: BlocBuilder<SessionCubit, SessionState>(
                  buildWhen: (p, c) => p.secondsRemaining != c.secondsRemaining,
                  builder: (context, state) => AppText(
                    _formatCountdown(state.secondsRemaining),
                    style: AppTextStyle.headlineMedium,
                    fontWeight: FontWeight.w700,
                    color: tokens.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Logout',
                      variant: AppButtonVariant.outline,
                      textColor: tokens.primary,
                      onPressed: () => _onLogout(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BlocBuilder<SessionCubit, SessionState>(
                      buildWhen: (p, c) => p.isRefreshing != c.isRefreshing,
                      builder: (context, state) => AppButton(
                        text: 'Continue Session',
                        isLoading: state.isRefreshing,
                        onPressed: () => context.read<SessionCubit>().continueSession(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
