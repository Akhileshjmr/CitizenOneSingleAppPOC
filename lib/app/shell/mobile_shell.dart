import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/app/shell/shell_utils.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/presentation/widgets/context_toggle.dart';

class MobileShell extends StatelessWidget {
  final Widget child;
  final String location;
  final UserRole role;

  const MobileShell({
    super.key,
    required this.child,
    required this.location,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      extendBody: true,
      backgroundColor: tokens.surfaceSoft,
      appBar: shouldHideShellHeader(location)
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: _MobileHeader(role: role),
            ),
      body: child,
      bottomNavigationBar: _MobileBottomNav(role: role, location: location),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  final UserRole role;

  const _MobileHeader({required this.role});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      padding: EdgeInsets.fromLTRB(
        tokens.spacingMd,
        tokens.spacingXs,
        tokens.spacingMd,
        tokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        border: const Border(bottom: BorderSide(color: Colors.white)),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(tokens.radiusXl),
        ),
        boxShadow: tokens.shadowSm,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (role == UserRole.agent)
              const ContextToggle()
            else
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tokens.surfaceMuted,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: tokens.shadowSm,
                    ),
                    child: Center(
                      child: Text(
                        role.displayName[0],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spacingSm),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.headerGreeting,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: tokens.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 10,
                              color: tokens.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              context.l10n.headerLocation,
                              style: TextStyle(
                                fontSize: 10,
                                color: tokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            // _RoleChip(role: role),
          ],
        ),
      ),
    );
  }
}

class _MobileBottomNav extends StatelessWidget {
  final UserRole role;
  final String location;

  const _MobileBottomNav({required this.role, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _BottomNavItem(
                icon: AppAssets.iconHome,
                label: context.l10n.navHome,
                isActive: location == roleBase(role) || location == '/home',
                onTap: () => context.go(roleBase(role)),
              ),
              _BottomNavItem(
                icon: AppAssets.iconGridOn,
                label: context.l10n.navServices,
                isActive:
                    location.contains('/services') || location == '/explore',
                onTap: () => context.go('${roleBase(role)}/services'),
              ),
              // ── PAY BUTTON (Commented out) ──
              /*
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: tokens.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: tokens.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.navPay,
                    style: TextStyle(
                      color: tokens.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              */
              _BottomNavItem(
                icon: AppAssets.iconNotificationNone,
                label: context.l10n.navAlerts,
                isActive: location.contains('/notifications'),
                onTap: () => context.go('${roleBase(role)}/notifications'),
              ),
              _BottomNavItem(
                icon: AppAssets.iconPersonOutline,
                label: context.l10n.navProfile,
                isActive: location.contains('/profile'),
                onTap: () => context.go('${roleBase(role)}/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                isActive ? tokens.primary : tokens.textMuted,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? tokens.primary : tokens.textMuted,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
