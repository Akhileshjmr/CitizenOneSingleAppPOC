import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../../theme/agency_banking_colors.dart';

class AgencyDashboardScreen extends StatelessWidget {
  const AgencyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agency Banking Dashboard'),
        backgroundColor: AgencyBankingColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const ModuleSwitcherBar(currentModuleId: 'agency_banking'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AgencyBankingColors.primary,
                    AgencyBankingColors.secondary
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agent Operations Portal',
                    style: AppTypography.title.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Terminal ID: AGT-99201 | Status: ONLINE',
                    style:
                        AppTypography.caption.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Agency Features', style: AppTypography.title),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              children: [
                _buildFeatureCard(
                  context,
                  title: 'Cash Deposit',
                  icon: Icons.move_to_inbox,
                  color: AgencyBankingColors.primary,
                  onTap: () => context.push('/agency-banking/cash-deposit'),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Cash Withdrawal',
                  icon: Icons.outbox,
                  color: Colors.teal.shade700,
                  onTap: () => _showSnackbar(
                      context, 'Cash Withdrawal feature coming soon'),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Customer Onboarding',
                  icon: Icons.person_add_alt_1,
                  color: const Color(0xFF10B981),
                  onTap: () => _showSnackbar(
                      context, 'Customer Onboarding feature coming soon'),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Agency Transactions',
                  icon: Icons.receipt_long,
                  color: Colors.cyan.shade800,
                  onTap: () => _showSnackbar(
                      context, 'Transactions Log feature coming soon'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ],
),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            radius: 28,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
