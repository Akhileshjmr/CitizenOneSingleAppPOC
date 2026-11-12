import 'package:citizenone_app/modules/agency_banking/module/module_entry.dart';
import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/session/presentation/state/session_cubit.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/widgets/insurance_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Post-login landing screen for the agent role — the Citizen One-owned
/// entry point into the agent's two available service lines.
///
/// Reached at `/agent/dashboard`, replacing the old direct hop straight
/// into [InsurancePartnerSelectionScreen]. Insurance keeps using that
/// existing, unchanged screen; Banking launches the embedded Agency
/// Banking module, auto-authenticated via host session token.
///
/// Also hosts the agent drawer ([InsuranceSidebar]) — Profile, Transaction
/// Settings and Sign Out are agent-level concerns, not Insurance-specific,
/// so this common landing page is where they belong.
class AgentServicesDashboardScreen extends StatelessWidget {
  const AgentServicesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      drawer: const InsuranceSidebar(),
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(LucideIcons.menu, color: tokens.textPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: AppText(
          'Services',
          style: AppTextStyle.headlineSmall,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            AppText(
              'What would you like to do?',
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            AppText(
              'Choose a service to continue',
              style: AppTextStyle.bodyMedium,
              color: tokens.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 24),
            _ServiceTile(
              icon: LucideIcons.shield_check,
              title: 'Insurance',
              subtitle: 'Insurance Partners',
              onTap: () => context.push('/agent/partners/insurance'),
            ),
            const SizedBox(height: 16),
            _ServiceTile(
              icon: LucideIcons.landmark,
              title: 'Banking',
              subtitle: 'Agency Banking',
              onTap: () => _openBanking(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openBanking(BuildContext context) async {
    final token = sl<SessionCubit>().currentToken ?? 'jwt_session_token';
    const phone = '0971234567';

    await AgencyBankingModuleEntry.initialize(
      gatewayBaseUrl: sl<AppEnv>().agencyBankingBaseUrl,
      sessionToken: token,
      onSessionActivity: () => sl<SessionCubit>().reportActivity(),
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => AgencyBankingModuleEntry.start(
          agentMobileNumber: phone,
          agentPassword: token,
          onExit: () => Navigator.of(routeContext).pop(),
          onSignOut: () => showLogoutDialog(routeContext),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Material(
      color: tokens.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tokens.outline),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tokens.primary, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      subtitle,
                      style: AppTextStyle.bodySmall,
                      color: tokens.textSecondary,
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevron_right, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
