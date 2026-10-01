import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class AgencyDashboardScreen extends StatelessWidget {
  const AgencyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Agent Operations Portal',
                        style: AppTypography.title.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'ONLINE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Terminal ID: AGT-99201 | Branch: Main City Terminal',
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Agency Features', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            children: [
              _buildFeatureCard(
                context,
                title: 'Cash Deposit',
                subtitle: 'Instant Deposit to Account',
                icon: Icons.move_to_inbox,
                color: primaryColor,
                onTap: () => context.push('/agency-banking/cash-deposit'),
              ),
              _buildFeatureCard(
                context,
                title: 'Cash Withdrawal',
                subtitle: 'Agent Cash Out Service',
                icon: Icons.outbox,
                color: Colors.teal.shade700,
                onTap: () => _showSnackbar(
                    context, 'Cash Withdrawal feature coming soon'),
              ),
              _buildFeatureCard(
                context,
                title: 'Customer Onboarding',
                subtitle: 'KYC Account Opening',
                icon: Icons.person_add_alt_1,
                color: const Color(0xFF10B981),
                onTap: () => _showSnackbar(
                    context, 'Customer Onboarding feature coming soon'),
              ),
              _buildFeatureCard(
                context,
                title: 'Agency Transactions',
                subtitle: 'Audit Log & History',
                icon: Icons.receipt_long,
                color: Colors.cyan.shade800,
                onTap: () => _showSnackbar(
                    context, 'Transactions Log feature coming soon'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
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
            radius: 26,
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
