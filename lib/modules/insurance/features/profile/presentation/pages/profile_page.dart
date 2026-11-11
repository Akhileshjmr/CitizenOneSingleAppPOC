// =============================================================================
// ProfilePage  —  Profile feature
// -----------------------------------------------------------------------------
// Reuses InfoTile, AppAvatar, AppCard, AppText etc. from the design system
// to compose a clean, on-brand profile screen. No business logic — toggles
// (theme, brand) are wired through the AppShell ValueNotifier passed from
// AppShell.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../app.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../design_system/atoms/atoms.dart';
import '../../../../design_system/molecules/molecules.dart';
import '../../../dashboard/domain/entities/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final settings = AppShell.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                AppAvatar(
                  size: AppAvatarSize.xl,
                ),
                const AppSpacer.lg(),
                AppText.title(user.fullName),
                const AppSpacer.xs(),
                AppText.caption(user.email),
                const AppSpacer.xs(),
                AppText.caption(user.phone),
                const AppSpacer.lg(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppChip(
                      label: 'Verified',
                      icon: Icons.verified_rounded,
                      tone: AppChipTone.success,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    AppChip(label: 'Premium', tone: AppChipTone.primary),
                  ],
                ),
              ],
            ),
          ),
          const AppSpacer.xl(),
          const AppText.label('PREFERENCES'),
          const AppSpacer.sm(),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                _SwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark mode',
                  subtitle: 'Toggle the app theme',
                  value: settings.themeMode.value == ThemeMode.dark,
                  onChanged: (v) => settings.themeMode.value =
                      v ? ThemeMode.dark : ThemeMode.light,
                ),
                const AppDivider(
                    indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                _SwitchTile(
                  icon: Icons.palette_outlined,
                  title: 'Bank Beta brand',
                  subtitle: 'Demonstrate white-label theme switching',
                  value: settings.useAlternateBrand.value,
                  onChanged: (v) => settings.useAlternateBrand.value = v,
                ),
              ],
            ),
          ),
          const AppSpacer.xl(),
          const AppText.label('ACCOUNT'),
          const AppSpacer.sm(),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                InfoTile(
                  leadingIcon: Icons.shield_outlined,
                  title: 'Security',
                  subtitle: 'Biometrics, 2FA, devices',
                  onTap: () {},
                ),
                const AppDivider(
                    indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                InfoTile(
                  leadingIcon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  subtitle: 'Data sharing & permissions',
                  onTap: () {},
                ),
                const AppDivider(
                    indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                InfoTile(
                  leadingIcon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  subtitle: '24/7 chat, email, phone',
                  onTap: () {},
                ),
                const AppDivider(
                    indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                InfoTile(
                  leadingIcon: Icons.logout_rounded,
                  title: 'Sign out',
                  subtitle: 'End your secure session',
                  iconBackground: context.colors.error.withValues(alpha: 0.12),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InfoTile(
      leadingIcon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: context.colors.primary,
      ),
      onTap: () => onChanged(!value),
    );
  }
}
