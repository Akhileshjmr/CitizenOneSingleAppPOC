import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/theme_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    // Ensure role theme is applied (Fixes theme persistence on Web/Tablet)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = context.read<AuthCubit>().state.selectedRole;
      context.read<ThemeCubit>().setRoleTheme(role.name);
    });

    return Container(
      width: double.infinity,
      color: tokens.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.notificationsTitle,
              style: AppTextStyle.headlineMedium,
              color: tokens.textPrimary,
              letterSpacing: -0.5,
            ),
            const SizedBox(height: 32),
            _buildNotificationCard(
              context: context,
              icon: AppAssets.iconReceiptLong,
              iconBg: const Color(0xFFFFEBEE),
              title: context.l10n.notificationBillTitle,
              description: context.l10n.notificationBillDesc,
              time: context.l10n.notificationTimeHours(2),
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context: context,
              icon: AppAssets.iconSecurity,
              iconBg: const Color(0xFFFFF3E0),
              title: context.l10n.notificationLoginTitle,
              description: context.l10n.notificationLoginDesc,
              time: context.l10n.notificationTimeHours(5),
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context: context,
              icon: AppAssets.iconAccountBalance,
              iconBg: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF7C3AED),
              title: context.l10n.notificationInsightTitle,
              description: context.l10n.notificationInsightDesc,
              time: context.l10n.notificationTimeYesterday,
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              context: context,
              icon: AppAssets.iconNotificationsActive,
              iconBg: const Color(0xFFDCFCE7),
              title: context.l10n.notificationPaymentTitle,
              description: context.l10n.notificationPaymentDesc,
              time: context.l10n.notificationTimeYesterday,
            ),
            const SizedBox(height: 120), // Extra space for FAB and navigation
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required String icon,
    required Color iconBg,
    Color? iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    final tokens = context.appTokens;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: tokens.shadowSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
                const SizedBox(height: 6),
                AppText(
                  description,
                  style: AppTextStyle.bodyMedium,
                  color: tokens.textSecondary,
                ),
                const SizedBox(height: 10),
                AppText(
                  time,
                  style: AppTextStyle.labelSmall,
                  color: tokens.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
