import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import '../../../auth/presentation/state/agent_banking_credential_holder.dart';

class InsuranceSidebar extends StatelessWidget {
  const InsuranceSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final holder = AgentBankingCredentialHolder.instance;
    final phone = holder.mobileNumber ?? '0971234567';

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: AppColors.surfaceSoft,
      elevation: 0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              color: AppColors.surface,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: const Icon(
                      LucideIcons.user_check,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Authorized Agent',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Active Session',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.outline),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                children: [
                  _SidebarItem(
                    icon: LucideIcons.shield_check,
                    title: 'Insurance Partners',
                    subtitle: 'Sanlam, Hollard, Madison',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/agent/partners/insurance');
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.landmark,
                    title: 'Agency Banking',
                    subtitle: 'Cash Deposit & Withdrawal',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/agency-banking');
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.clipboard_list,
                    title: 'Agent Tasks',
                    subtitle: 'KYC Verifications & Visits',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/agent/tasks');
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.users,
                    title: 'Customer Directory',
                    subtitle: 'Enrolled Citizens & Farmers',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/agent/customers');
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.wallet,
                    title: 'Cash Collections',
                    subtitle: 'Daily Reconciliation & Receipts',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/agent/collections');
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.outline),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.file_text,
                    title: 'Insurance Transactions',
                    subtitle: 'Policies Issued & Claims',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/insurance/claims');
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.settings,
                    title: 'Settings & Security',
                    subtitle: 'App & Biometric Preferences',
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings is up to date.')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Sign Out Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showLogoutDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(LucideIcons.log_out, color: AppColors.error, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.outline),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 18,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}

Future<void> showLogoutDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Sign Out',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
      content: const Text(
        'Are you sure you want to sign out from CitizenOne?',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Sign Out'),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    // Clear credentials in memory
    AgentBankingCredentialHolder.instance.clear();
    // Perform symmetrical session teardown across all modules
    await context.read<AuthCubit>().logout();
    if (context.mounted) {
      context.go('/login');
    }
  }
}
