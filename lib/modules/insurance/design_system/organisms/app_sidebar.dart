// =============================================================================
// AppSidebar  —  ORGANISM (desktop-only)
// -----------------------------------------------------------------------------
// Permanent left navigation rail shown by AppDesktopShell on tablet/desktop.
// Mirrors the desktop SVG reference: logo block + 5 nav items (Home, Buy
// Policy, Apply Claim [disabled], Pay Premium [disabled], Transactions
// Details). Navigation reuses the existing GoRouter routes — no new routes,
// no business-logic changes.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/app.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

enum AppSidebarDestination {
  home,
  buyPolicy,
  applyClaim,
  payPremium,
  transactions
}

/// Routes that belong to the "Buy Policy" journey — used to highlight the
/// sidebar item while the user is anywhere inside that flow.
const _buyPolicyRoutePrefixes = <String>[
  AppRoutes.motorInsuranceScreen,
  AppRoutes.userDetailScreen,
  AppRoutes.motorInsuranceCreationScreen,
  AppRoutes.noRecordScreen,
  AppRoutes.policyConfirmedPage,
  AppRoutes.motorInsuranceErrorPage,
  AppRoutes.motorInsurancePage,
  AppRoutes.viewPolicyDetailsPage,
  AppRoutes.motorInsuranceOtpScreen,
  '/buy-policy',
];

AppSidebarDestination sidebarDestinationForPath(String path) {
  if (path == AppRoutes.insuranceTransactionScreen) {
    return AppSidebarDestination.transactions;
  }
  if (_buyPolicyRoutePrefixes.any((prefix) => path.startsWith(prefix))) {
    return AppSidebarDestination.buyPolicy;
  }
  return AppSidebarDestination.home;
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key, required this.currentPath});

  final String currentPath;

  static const double expandedWidth = 240;
  static const double compactWidth = 84;

  @override
  Widget build(BuildContext context) {
    final selected = sidebarDestinationForPath(currentPath);
    // Tablet viewports (600-1023px) don't have room for a 260px labeled
    // sidebar without crushing the page content next to it — collapse to an
    // icon-only rail there; desktop keeps the full labeled sidebar.
    final compact = !AdaptiveLayout.isDesktop(context);

    return Container(
      width: compact ? compactWidth : expandedWidth,
      color: AppColors.sidebarBackground,
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 16 : 32,
                32,
                compact ? 16 : 32,
                32,
              ),
              child: compact
                  ? Image.asset(
                      package: AppConfig.packageName,
                      AppAssets.citizenOneLogo,
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      errorBuilder: (context, error, stackTrace) =>
                          const AppText(
                        'CitizenOne',
                        style: AppTextStyle.headlineSmall,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: SvgPicture.asset(
                        package: AppConfig.packageName,
                        AppAssets.citizenOne,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
              child: Column(
                children: [
                  _SidebarItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    compact: compact,
                    isSelected: selected == AppSidebarDestination.home,
                    onTap: () => context.go('/'),
                  ),
                  _SidebarItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Buy Policy',
                    compact: compact,
                    isSelected: selected == AppSidebarDestination.buyPolicy,
                    onTap: () => context.go(AppRoutes.motorInsuranceScreen),
                  ),
                  _SidebarItem(
                    icon: Icons.autorenew,
                    label: 'Apply Claim',
                    compact: compact,
                    isSelected: false,
                    enabled: false,
                  ),
                  _SidebarItem(
                    icon: Icons.paid_outlined,
                    label: 'Pay Premium',
                    compact: compact,
                    isSelected: false,
                    enabled: false,
                  ),
                  _SidebarItem(
                    icon: Icons.swap_horiz,
                    label: 'Transaction Details',
                    compact: compact,
                    isSelected: selected == AppSidebarDestination.transactions,
                    onTap: () =>
                        context.go(AppRoutes.insuranceTransactionScreen),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 12 : 20,
                12,
                compact ? 12 : 20,
                24,
              ),
              child: _SignOutItem(compact: compact),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.compact = false,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool compact;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isSelected
        ? AppColors.sidebarSelectedBg
        : (_hovering
            ? Colors.white.withValues(alpha: 0.6)
            : Colors.transparent);
    final fg = widget.isSelected ? Colors.white : AppColors.sidebarTextDefault;

    final icon = Icon(widget.icon, size: 20, color: fg);

    final Widget row;
    if (widget.compact) {
      row = Stack(
        alignment: Alignment.center,
        children: [
          icon,
          if (widget.isSelected)
            Positioned(
              right: 4,
              top: 0,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.sidebarAccentDot,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      );
    } else {
      row = Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              widget.label,
              style: AppTextStyle.bodyMedium,
              fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
              color: fg,
            ),
          ),
          if (widget.isSelected)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.sidebarAccentDot,
                shape: BoxShape.circle,
              ),
            ),
        ],
      );
    }

    final content = Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment: widget.compact ? Alignment.center : null,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: widget.compact
          ? const EdgeInsets.symmetric(vertical: 14)
          : const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Opacity(opacity: widget.enabled ? 1 : 0.4, child: row),
    );

    final tappable = !widget.enabled
        ? IgnorePointer(child: content)
        : MouseRegion(
            onEnter: (_) => setState(() => _hovering = true),
            onExit: (_) => setState(() => _hovering = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: content,
            ),
          );

    if (!widget.compact) return tappable;
    return Tooltip(message: widget.label, child: tappable);
  }
}

/// Sidebar "Sign Out" entry — visually separated from the nav items above it
/// (pinned to the bottom via the [Spacer] in [AppSidebar]) and styled
/// distinctly from [_SidebarItem] (orange icon-circle, red label) since it's
/// a destructive action rather than a navigation destination. Delegates the
/// actual sign-out work to the host app via [AppShell.onSignOut].
class _SignOutItem extends StatelessWidget {
  const _SignOutItem({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconCircle = Container(
      height: 36,
      width: 36,
      decoration: const BoxDecoration(
        color: AppColors.logoutBg,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.logout, color: AppColors.brandOrange, size: 18),
    );

    final row = compact
        ? iconCircle
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconCircle,
              const SizedBox(width: 10),
              const AppText(
                'Sign Out',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w700,
                color: AppColors.brandRed,
              ),
            ],
          );

    final tappable = InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => AppShell.of(context).onSignOut(),
      child: row,
    );

    if (!compact) return tappable;
    return Tooltip(message: 'Sign Out', child: tappable);
  }
}
