import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/app/shell/shell_utils.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/presentation/widgets/context_toggle.dart';

class WebShell extends StatelessWidget {
  final Widget child;
  final String location;
  final UserRole role;

  const WebShell({
    super.key,
    required this.child,
    required this.location,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: Row(
        children: [
          Container(
            width: 272,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: tokens.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shield, size: 24, color: tokens.primary),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Citizen One',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (role == UserRole.agent) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.agentWorkContext,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: tokens.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const ContextToggle(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ] else
                  const SizedBox(height: 16),
                _WebNavItem(
                  icon: Icons.home_filled,
                  label: context.l10n.navHome,
                  isActive: location == roleBase(role) || location == '/home',
                  onTap: () => context.go(roleBase(role)),
                ),
                _WebNavItem(
                  icon: Icons.grid_view_rounded,
                  label: context.l10n.navServices,
                  isActive: location.contains('/services') || location == '/explore',
                  onTap: () => context.push('${roleBase(role)}/services'),
                ),
                _WebNavItem(
                  icon: Icons.notifications_none_rounded,
                  label: context.l10n.navAlerts,
                  isActive: location.contains('/notifications'),
                  onTap: () => context.push('${roleBase(role)}/notifications'),
                ),
                _WebNavItem(
                  icon: Icons.person_outline_rounded,
                  label: context.l10n.navProfile,
                  isActive: location.contains('/profile'),
                  onTap: () => context.push('${roleBase(role)}/profile'),
                ),
                const Spacer(),
                Divider(color: tokens.outline),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, size: 20, color: tokens.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.settingsLabel,
                        style: TextStyle(
                          color: tokens.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'v1.0.0',
                        style: TextStyle(color: tokens.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: tokens.outline),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: tokens.outline)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.headerDashboard,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            role.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WebNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          hoverColor: tokens.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? tokens.primary.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: isActive ? tokens.primary : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? tokens.primary : tokens.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? tokens.primary : tokens.textPrimary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
