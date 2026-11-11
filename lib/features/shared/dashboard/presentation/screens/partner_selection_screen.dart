import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:flutter_svg/svg.dart';

class PartnerSelectionScreen extends StatelessWidget {
  const PartnerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Select Partner',
            style: AppTextStyle.headlineSmall,
            fontWeight: FontWeight.w700,
          ),
          AppText(
            'Choose assigned partner to access operations.',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w700,
            color: tokens.textSecondary,
          ),
          const SizedBox(height: 24),
          AppTextField(
            hintText: 'Search partners...',
            prefixIcon: AppAssets.iconSearch,
          ),
          const SizedBox(height: 24),
          StaggeredEntryList(
            children: [
              _PartnerSection(
                title: 'Bank/FI Partners',
                count: 2,
                children: [
                  _PartnerItem(
                    name: 'Citizen Bank',
                    subtitle: 'National Bank',
                    icon: AppAssets.iconAccountBalance,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0099FF),
                    onTap: () => context.read<AuthCubit>().setPartner(
                      'Citizen Bank',
                      LucideIcons.landmark,
                      'Bank',
                    ),
                  ),
                  _PartnerItem(
                    name: 'Rural Algo Bank',
                    subtitle: 'Microfinance',
                    icon: AppAssets.iconAccountBalance,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFFEDF7E6),
                    onTap: () => context.read<AuthCubit>().setPartner(
                      'Rural Algo Bank',
                      LucideIcons.landmark,
                      'Bank',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PartnerSection(
                title: 'Insurance Partners',
                count: 1,
                children: [
                  _PartnerItem(
                    name: 'SafeGuard Life',
                    subtitle: 'Life & Health',
                    icon: AppAssets.iconShield,
                    iconBg: const Color(0xFFFEE2E2),
                    iconColor: const Color(0xFFEF4444),
                    onTap: () => context.read<AuthCubit>().setPartner(
                      'SafeGuard Life',
                      LucideIcons.shield_check,
                      'Insurance',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PartnerSection(
                title: 'MNO Partners',
                count: 1,
                children: [
                  _PartnerItem(
                    name: 'ConnectZambia',
                    subtitle: 'Telecom',
                    icon: AppAssets.iconMobile,
                    iconBg: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF9333EA),
                    onTap: () => context.read<AuthCubit>().setPartner(
                      'ConnectZambia',
                      LucideIcons.smartphone,
                      'MNO',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartnerSection extends StatelessWidget {
  final String title;
  final int count;
  final List<Widget> children;

  const _PartnerSection({
    required this.title,
    required this.count,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.outline),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F212121),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Row(
            children: [
              AppText(
                title,
                style: AppTextStyle.caption,
                fontWeight: FontWeight.bold,
                color: tokens.textSecondary,
                letterSpacing: 0.5,
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}

class _PartnerItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _PartnerItem({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFDDDDDD).withValues(alpha: 0.6),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: PressScaleWidget(
            onPressed: onTap,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
              ),
              title: AppText(
                name,
                style: AppTextStyle.bodyLarge,
                fontWeight: FontWeight.bold,
              ),
              subtitle: AppText(subtitle, style: AppTextStyle.bodySmall),
              trailing: Icon(
                Icons.chevron_right,
                color: tokens.textMuted,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
