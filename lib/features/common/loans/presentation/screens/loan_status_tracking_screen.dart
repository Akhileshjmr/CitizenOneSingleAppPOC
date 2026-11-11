import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/dimensions.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class LoanStatusTrackingScreen extends StatelessWidget {
  final String? referenceId;

  const LoanStatusTrackingScreen({super.key, this.referenceId});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrow_left, color: tokens.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/loans');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              l10n.loansStatusTitle,
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.w600,
              color: tokens.textPrimary,
            ),
            AppText(
              l10n.loansAppRef(referenceId ?? 'LN-2026-7797'),
              style: AppTextStyle.labelSmall,
              color: tokens.textMuted,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tokens.surfaceMuted),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Zanaco',
                            style: AppTextStyle.bodyLarge,
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            l10n.loanCategoryPersonal,
                            style: AppTextStyle.bodySmall,
                            color: tokens.textSecondary,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppText(
                          l10n.loansStatusSubmitted,
                          style: AppTextStyle.labelSmall,
                          fontWeight: FontWeight.w600,
                          color: tokens.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            l10n.loansLabelAmountHeader,
                            style: AppTextStyle.labelSmall,
                            color: tokens.textMuted,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            'ZK 5,000',
                            style: AppTextStyle.bodyMedium,
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            l10n.loansLabelDateHeader,
                            style: AppTextStyle.labelSmall,
                            color: tokens.textMuted,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            '2026-02-06',
                            style: AppTextStyle.bodyMedium,
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tracking History
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tokens.surfaceMuted),
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
                  AppText(
                    l10n.loansLabelTrackingHistory,
                    style: AppTextStyle.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: tokens.textPrimary,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineItem(
                    icon: LucideIcons.clock,
                    iconColor: tokens.primary,
                    iconBgColor: tokens.primary.withValues(alpha: 0.08),
                    title: l10n.loansStatusSubmitted,
                    subtitle: 'Received on 12 Feb 2024',
                    isActive: true,
                    isLast: false,
                    tokens: tokens,
                  ),
                  _buildTimelineItem(
                    icon: LucideIcons.file_search,
                    iconColor: tokens.textMuted,
                    iconBgColor: tokens.surfaceMuted,
                    title: l10n.loansStatusCreditScoring,
                    subtitle: 'Analyzing credit history',
                    isActive: false,
                    isLast: false,
                    tokens: tokens,
                  ),
                  _buildTimelineItem(
                    icon: LucideIcons.circle_check_big,
                    iconColor: tokens.textMuted,
                    iconBgColor: tokens.surfaceMuted,
                    title: l10n.loansStatusEligibility,
                    subtitle: 'Verifying income and documents',
                    isActive: false,
                    isLast: false,
                    tokens: tokens,
                  ),
                  _buildTimelineItem(
                    icon: LucideIcons.check_check,
                    iconColor: tokens.textMuted,
                    iconBgColor: tokens.surfaceMuted,
                    title: l10n.loansStatusApproval,
                    subtitle: 'Sanction letter generated',
                    isActive: false,
                    isLast: true,
                    tokens: tokens,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Required Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tokens.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: tokens.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.info, size: 20, color: tokens.primary),
                      const SizedBox(width: 8),
                      AppText(
                        l10n.loansLabelActionRequired,
                        style: AppTextStyle.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: tokens.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    'We might need additional documents regarding your employment.',
                    style: AppTextStyle.bodySmall,
                    color: tokens.primary,
                    height: 1.5,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: l10n.loansActionUploadDocs,
                    onPressed: () {},
                    variant: AppButtonVariant.outline,
                    height: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: AppDimensions.scrollBottomPadding,
            ), // Extra padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isLast,
    required dynamic tokens,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: tokens.surfaceMuted,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.bodySmall,
                  fontWeight: FontWeight.w600,
                  color: isActive ? tokens.textPrimary : tokens.textMuted,
                ),
                const SizedBox(height: 4),
                AppText(
                  subtitle,
                  style: AppTextStyle.labelSmall,
                  color: tokens.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
