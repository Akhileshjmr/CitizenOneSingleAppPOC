import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/design_system/design_system.dart';

// ── Display data model ────────────────────────────────────────────────────────

/// All display data for one role's hero card, resolved once in [build].
/// Keeps the widget free of scattered switch statements.
class _HeroData {
  final String roleIcon;
  final String roleLabel;
  final LinearGradient gradient;
  final Color shadowColor;
  final bool isDark;

  final String? cardTitle;
  final String? metricLabel;
  final String metricValue;
  final String? metricNote;
  final Widget? metricBadge;

  final String primaryBtnLabel;
  final Color primaryBtnBg;
  final Color primaryBtnFg;
  final String date;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final Widget? desktopNote;

  const _HeroData({
    required this.roleIcon,
    required this.roleLabel,
    required this.gradient,
    required this.shadowColor,
    required this.isDark,
    this.cardTitle,
    this.metricLabel,
    required this.metricValue,
    this.metricNote,
    this.metricBadge,
    required this.primaryBtnLabel,
    required this.primaryBtnBg,
    required this.primaryBtnFg,
    required this.date,
    required this.onPrimaryTap,
    this.onSecondaryTap,
    this.desktopNote,
  });

  factory _HeroData.fromRole(UserRole role, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = context.l10n;

    switch (role) {
      case UserRole.agent:
        return _HeroData(
          roleIcon: AppAssets.iconElectricBolt,
          roleLabel: l10n.heroCardAgentLabel,
          gradient: LinearGradient(
            colors: [AppColors.roleAgent, AppColors.roleAgent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shadowColor: AppColors.roleAgent.withValues(alpha: 0.3),
          isDark: true,
          metricLabel: l10n.heroCardAgentCommissionLabel,
          metricValue: 'ZK 450.00',
          primaryBtnLabel: l10n.heroBtnViewTasks,
          primaryBtnBg: Colors.white,
          primaryBtnFg: AppColors.roleAgent,
          date: 'Today',
          onPrimaryTap: () {},
          onSecondaryTap: () {},
        );

      case UserRole.farmer:
        return _HeroData(
          roleIcon: AppAssets.iconAdd,
          roleLabel: l10n.heroCardFarmerLabel,
          gradient: LinearGradient(
            colors: [
              AppColors.roleFarmer,
              AppColors.roleFarmer.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shadowColor: AppColors.roleFarmer.withValues(alpha: 0.3),
          isDark: true,
          metricLabel: l10n.heroCardFarmerRainfallLabel,
          metricValue: l10n.heroCardFarmerRainfallValue,
          metricNote: l10n.heroCardFarmerRainfallNote,
          desktopNote: AppText(
            l10n.heroCardFarmerRainExpectedNote,
            style: AppTextStyle.labelSmall,
            color: Colors.white.withValues(alpha: 0.8),
            overflow: TextOverflow.ellipsis,
          ),
          primaryBtnLabel: l10n.heroBtnViewForecast,
          primaryBtnBg: Colors.white,
          primaryBtnFg: AppColors.roleFarmer,
          date: 'Today',
          onPrimaryTap: () {},
          onSecondaryTap: () {},
        );

      case UserRole.citizen:
        return _HeroData(
          roleIcon: AppAssets.iconAdd,
          roleLabel: l10n.heroCardCitizenLabel,
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.background],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shadowColor: AppColors.textPrimary.withValues(alpha: 0.2),
          isDark: false,
          cardTitle: l10n.heroCardCitizenTitle,
          metricValue: 'ZK 450.00',
          metricBadge: _DueBadge(label: l10n.heroCardCitizenDueTag),
          desktopNote: AppText(
            l10n.heroCardCitizenDueNote,
            style: AppTextStyle.labelSmall,
            color: AppColors.textSecondary,
            overflow: TextOverflow.ellipsis,
          ),
          primaryBtnLabel: l10n.heroBtnPayNow,
          primaryBtnBg: primary,
          primaryBtnFg: Colors.white,
          date: 'Today',
          onPrimaryTap: () {},
        );
    }
  }
}

// ── Widget ────────────────────────────────────────────────────────────────────

class HeroCard extends StatelessWidget {
  final UserRole role;

  const HeroCard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final d = _HeroData.fromRole(role, context);
    final textColor = d.isDark ? Colors.white : AppColors.textPrimary;

    return HeroCardShell(
      gradient: d.gradient,
      shadowColor: d.shadowColor,
      isDark: d.isDark,
      note: d.desktopNote,
      header: HeroRoleChip(
        icon: d.roleIcon,
        label: d.roleLabel,
        isDark: d.isDark,
        date: d.date,
      ),
      metric: HeroMetricBlock(
        title: d.cardTitle,
        metricLabel: d.metricLabel,
        metricValue: d.metricValue,
        note: d.metricNote,
        badge: d.metricBadge,
        textColor: textColor,
      ),
      actions: _HeroActions(data: d),
    );
  }
}

// ── Private helpers (card-scoped, not design-system generic) ──────────────────

class _HeroActions extends StatelessWidget {
  final _HeroData data;

  const _HeroActions({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.onSecondaryTap == null) {
      return AppButton(
        height: 40,
        text: data.primaryBtnLabel,
        onPressed: data.onPrimaryTap,
        backgroundColor: data.primaryBtnBg,
        foregroundColor: data.primaryBtnFg,
        icon: LucideIcons.arrow_right,
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppButton(
            height: 40,
            radius: 8,
            text: data.primaryBtnLabel,
            onPressed: data.onPrimaryTap,
            backgroundColor: data.primaryBtnBg,
            foregroundColor: data.primaryBtnFg,
          ),
        ),
        const SizedBox(width: 12),
        AppIconButton(
          iconSize: 20,
          icon: AppAssets.iconNotificationNone,
          onTap: data.onSecondaryTap,
          iconColor: Colors.white,
          borderColor: Colors.white.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

class _DueBadge extends StatelessWidget {
  final String label;

  const _DueBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        label,
        style: AppTextStyle.caption,
        fontWeight: FontWeight.w500,
        color: AppColors.error,
      ),
    );
  }
}
