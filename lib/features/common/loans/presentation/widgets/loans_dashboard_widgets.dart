import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/features/common/loans/domain/entities/loan_application.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';


class LoanCategorySpec {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const LoanCategorySpec({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });
}

class LoansPromoBanner extends StatelessWidget {
  const LoansPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      padding: EdgeInsets.all(tokens.spacingXl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(tokens.radiusXl),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.loansPromoTitle,
                  style: AppTextStyle.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                AppText(
                  context.l10n.loansPromoSubtitle,
                  style: AppTextStyle.bodyMedium,
                  color: Colors.white70,
                ),
                SizedBox(height: tokens.spacingMd),
                AppButton(
                  text: context.l10n.loansPromoAction,
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4F46E5),
                  width: null,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ],
            ),
          ),
          if (!context.isMobile) ...[
            SizedBox(width: tokens.spacingMd),
            Icon(
              LucideIcons.shield_check,
              size: 80,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ],
        ],
      ),
    );
  }
}

class LoanCategoriesSection extends StatelessWidget {
  final List<LoanCategorySpec> categories;

  const LoanCategoriesSection({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              context.l10n.loansCategoriesHeader,
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.bold,
              color: tokens.textPrimary,
            ),
            AppButton(
              text: context.l10n.loansCategoriesViewAll,
              onPressed: () {},
              variant: AppButtonVariant.ghost,
              foregroundColor: tokens.brandBlue,
              width: null,
            ),
          ],
        ),
        SizedBox(height: tokens.spacingMd),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = context.isDesktop
                ? 4
                : context.isTablet
                    ? 4
                    : 2;
            const spacing = 12.0;
            final totalSpacing = spacing * (crossAxisCount - 1);
            final itemWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: 20,
              children: categories
                  .map(
                    (category) => _LoanCategoryCard(
                      width: itemWidth,
                      title: category.title,
                      icon: category.icon,
                      color: category.color,
                      iconColor: category.iconColor,
                      onTap: category.onTap,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class LoansUtilityCards extends StatelessWidget {
  const LoansUtilityCards({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push('/tools/emi-calculator'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(tokens.radiusSm),
              border: Border.all(color: tokens.outline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.calculator,
                    color: Color(0xFFF97316),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.loansEmiCalcTitle,
                        style: AppTextStyle.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: tokens.textPrimary,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        context.l10n.loansEmiCalcSubtitle,
                        style: AppTextStyle.labelSmall,
                        color: tokens.textSecondary,
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: tokens.spacing2xl),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(tokens.radiusSm),
            border: Border.all(color: tokens.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                context.l10n.loansWhyChooseHeader,
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
              SizedBox(height: tokens.spacingMd),
              _BenefitItem(
                number: '1',
                title: context.l10n.loansBenefit1Title,
                subtitle: context.l10n.loansBenefit1Subtitle,
              ),
              const SizedBox(height: 12),
              _BenefitItem(
                number: '2',
                title: context.l10n.loansBenefit2Title,
                subtitle: context.l10n.loansBenefit2Subtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoanApplicationsSection extends StatelessWidget {
  final List<LoanApplication> applications;

  const LoanApplicationsSection({
    super.key,
    required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.loansMyAppsHeader,
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.w600,
          color: tokens.textPrimary,
        ),
        SizedBox(height: tokens.spacingSm),
        ...applications.map((app) => LoanApplicationCard(application: app)),
      ],
    );
  }
}

class LoanApplicationCard extends StatelessWidget {
  final LoanApplication application;

  const LoanApplicationCard({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    Color statusColor;
    Color statusBgColor;

    switch (application.status) {
      case 'Approved':
        statusColor = const Color(0xFF16A34A);
        statusBgColor = const Color(0xFFDCFCE7);
        break;
      case 'Credit Scoring':
        statusColor = const Color(0xFF9333EA);
        statusBgColor = const Color(0xFFF3E8FF);
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusBgColor = const Color(0xFFF1F5F9);
    }

    return GestureDetector(
      onTap: () => context.push('/application/status?ref=${application.referenceNumber}'),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          border: Border.all(color: tokens.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  application.loanType,
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: tokens.textPrimary,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: AppText(
                    application.status,
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            AppText(
              '${application.bankName} - ZK ${application.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: AppTextStyle.bodySmall,
              color: tokens.textSecondary,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: application.progressPercentage,
                backgroundColor: tokens.outline,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  context.l10n.loansAppRef(application.referenceNumber),
                  style: AppTextStyle.labelSmall,
                  color: tokens.textMuted,
                  fontSize: 11,
                ),
                AppText(
                  context.l10n.loansAppLastUpdate('${application.lastUpdate.year}-${application.lastUpdate.month.toString().padLeft(2, '0')}-${application.lastUpdate.day.toString().padLeft(2, '0')}'),
                  style: AppTextStyle.labelSmall,
                  color: tokens.textMuted,
                  fontSize: 11,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final double width;

  const _LoanCategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            AppText(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _BenefitItem({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFDBEAFE),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AppText(
              number,
              style: AppTextStyle.bodySmall,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2563EB),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
              const SizedBox(height: 2),
              AppText(
                subtitle,
                style: AppTextStyle.labelSmall,
                color: const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
