import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/screens/security_screen.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/get_agent_mobile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/module/module_entry.dart';

/// Sidebar shown from the Agent Services Dashboard's hamburger icon —
/// the common agent-level drawer shared by both the Insurance and
/// Banking service lines. Mirrors agency-banking's `partner_drawer.dart`.
///
/// Per spec, the profile header does **not** call any profile API — it
/// always shows the "Unknown" placeholder. Only the mobile number
/// (needed to open Insurance Transactions) is resolved, via the same
/// [GetAgentMobileUseCase] the rest of the app already uses.
class InsuranceSidebar extends StatelessWidget {
  const InsuranceSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.86,
      backgroundColor: tokens.surfaceSoft,
      elevation: 0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(tokens: tokens),
            Divider(height: 1, color: tokens.outline),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  children: [
                    _MenuRow(
                      icon: Icons.history,
                      title: 'Insurance Transactions',
                      onTap: () => _openInsuranceTransactions(context),
                    ),
                    const SizedBox(height: 4),
                    _SettingsExpansion(tokens: tokens),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: _SignOutRow(onTap: () => showLogoutDialog(context)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openInsuranceTransactions(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffold = Scaffold.of(context);
    final result = await sl<GetAgentMobileUseCase>()();
    final agentMobNo = result.fold((_) => '', (mobile) => mobile);

    scaffold.closeDrawer();
    if (!navigator.mounted) return;

    InsuranceModuleEntry.openInsuranceTransactionScreen(
      navigator.context,
      arguments: {'agentCode': agentMobNo},
    );
  }
}

/// Confirmation dialog for Sign Out. Shared by the sidebar's own "Sign
/// Out" row and the `onSignOut` callback passed into
/// `InsuranceModuleEntry.start()` — both routes must use CitizenOne's
/// existing logout flow (session clear + navigate to `/login`), never a
/// bespoke one.
Future<void> showLogoutDialog(BuildContext context) async {
  final tokens = context.appTokens;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: tokens.surface,
      title: AppText(
        'Sign Out',
        style: AppTextStyle.headlineSmall,
        fontWeight: FontWeight.w700,
        color: tokens.textPrimary,
      ),
      content: AppText(
        'Are you sure you want to sign out?',
        style: AppTextStyle.bodyMedium,
        color: tokens.textSecondary,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: AppText(
            'Cancel',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
            color: tokens.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: AppText(
            'Sign Out',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w700,
            color: tokens.error,
          ),
        ),
      ],
    ),
  );

  if (confirmed != true) return;
  if (!context.mounted) return;

  await context.read<AuthCubit>().logout();
  if (!context.mounted) return;
  context.go('/login');
}

class _Header extends StatelessWidget {
  final AppThemeTokens tokens;
  const _Header({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: tokens.surfaceMuted,
            child: Icon(LucideIcons.user, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),
          AppText(
            'Unknown',
            style: AppTextStyle.headlineSmall,
            fontWeight: FontWeight.w700,
            color: tokens.textPrimary,
          ),
          const SizedBox(height: 6),
          AppText(
            'User ID | Unknown',
            style: AppTextStyle.bodyMedium,
            color: tokens.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _CircleIcon(icon: icon, tokens: tokens),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                title,
                style: AppTextStyle.bodyLarge,
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsExpansion extends StatelessWidget {
  final AppThemeTokens tokens;
  const _SettingsExpansion({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: EdgeInsets.zero,
        iconColor: tokens.textMuted,
        collapsedIconColor: tokens.textMuted,
        leading: _CircleIcon(icon: LucideIcons.settings, tokens: tokens),
        title: AppText(
          'Settings',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 68, right: 18),
            leading: Icon(
              LucideIcons.shield,
              color: tokens.textPrimary,
              size: 20,
            ),
            title: AppText(
              'Security',
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
              color: tokens.textPrimary,
            ),
            trailing: Icon(LucideIcons.chevron_right, color: tokens.textMuted),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SecurityScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  final VoidCallback onTap;
  const _SignOutRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: tokens.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.log_out, color: tokens.error, size: 20),
            ),
            const SizedBox(width: 12),
            AppText(
              'Sign Out',
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.w700,
              color: tokens.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final AppThemeTokens tokens;
  const _CircleIcon({required this.icon, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: tokens.textPrimary, size: 20),
    );
  }
}
