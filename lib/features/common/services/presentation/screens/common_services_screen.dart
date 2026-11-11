import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CommonServicesScreen extends StatelessWidget {
  const CommonServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final l10n = context.l10n;

    return MiniServiceScaffold(
      title: l10n.commonServicesTitle,
      hero: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(
            0xFF1E293B,
          ), // Keep slate for dark premium feel or use tokens
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.commonServicesSystemOverview,
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetric(
                  context,
                  '99.9%',
                  l10n.commonServicesUptime,
                  const Color(0xFF22C55E),
                ),
                const SizedBox(width: 24),
                _buildMetric(
                  context,
                  '12ms',
                  l10n.commonServicesLatency,
                  const Color(0xFF3B82F6),
                ),
              ],
            ),
          ],
        ),
      ),
      quickActions: [
        QuickActionData(
          icon: AppAssets.iconCurrency,
          label: l10n.commonServicesQuickAnalytics,
          backgroundColor: tokens.surfaceMuted,
          iconColor: tokens.textSecondary,
          onTap: () {},
        ),
        QuickActionData(
          icon: AppAssets.iconMenuBook,
          label: l10n.commonServicesQuickTickets,
          backgroundColor: tokens.primary.withValues(alpha: 0.08),
          iconColor: tokens.primary,
          onTap: () {},
        ),
        QuickActionData(
          icon: AppAssets.iconGrid,
          label: l10n.commonServicesQuickAdmin,
          backgroundColor: const Color(0xFFF3E8FF),
          iconColor: const Color(0xFF9333EA),
          onTap: () {},
        ),
        QuickActionData(
          icon: AppAssets.iconMobile,
          label: l10n.commonServicesQuickSupport,
          backgroundColor: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF16A34A),
          onTap: () {},
        ),
      ],
      services: [
        ServiceListData(title: l10n.commonServicesLogs, onTap: () {}),
        ServiceListData(title: l10n.commonServicesUserMgmt, onTap: () {}),
        ServiceListData(title: l10n.commonServicesSecurity, onTap: () {}),
      ],
      aiInsight: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.primary.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.sparkles, size: 16, color: tokens.primary),
                const SizedBox(width: 8),
                AppText(
                  l10n.commonServicesAiAlert,
                  style: AppTextStyle.labelSmall,
                  fontWeight: FontWeight.bold,
                  color: tokens.textMuted,
                  letterSpacing: 1.0,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppText(
              l10n.commonServicesAiPerf,
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
            ),
            const SizedBox(height: 8),
            AppText(
              l10n.commonServicesAiStatus,
              style: AppTextStyle.bodyMedium,
              color: tokens.textSecondary,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: l10n.commonServicesAiDetails,
              onPressed: () {},
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          value,
          style: AppTextStyle.headlineMedium,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        AppText(
          label,
          style: AppTextStyle.labelSmall,
          fontSize: 10,
          color: Colors.white.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      ],
    );
  }
}
