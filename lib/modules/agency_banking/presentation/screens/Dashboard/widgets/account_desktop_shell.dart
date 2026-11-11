import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/security/security_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommDialog.dart';
import 'package:flutter/material.dart';
import '../../kyc/kyc_search_screen.dart';
import '../../left_menu_screen/profile/profile_v2_screen.dart';
import 'WebDashboardTopBar.dart';

/// Which entry of [AccountDesktopSidebar] represents the screen currently
/// on-screen — drives the active highlight and the Settings/Security
/// auto-expand, mirroring the mobile [PartnerDrawer]'s menu but for the
/// desktop/web "account" screens (Select Partner, Profile, Security &
/// its sub-screens, KYC Verification & its sub-screens).
enum AccountNavItem {
  profile,
  security,
  selectPartner,
  kyc,
}

/// Stable [RouteSettings.name] tagged on the [BankSelectionScreen] route (the
/// "Select Partner" base screen this whole account cluster is pushed on top
/// of), so the sidebar's "Select Partner" item can always pop back to that
/// exact route with [Navigator.popUntil] — regardless of how many
/// Profile/Security(/Change Password) screens were pushed in between.
const String accountSelectPartnerRouteName = '/account/select-partner';

/// Desktop/web left navigation rail shared by the Select Partner, Profile
/// and Security screens — kept separate from the Dashboard's own
/// [CustomSidebar] (Home/Profile/History/Loans) so restyling this never
/// touches the main dashboard chrome.
class AccountDesktopSidebar extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final AccountNavItem activeItem;

  const AccountDesktopSidebar({
    super.key,
    required this.loginResponse,
    required this.activeItem,
  });

  @override
  State<AccountDesktopSidebar> createState() => _AccountDesktopSidebarState();
}

class _AccountDesktopSidebarState extends State<AccountDesktopSidebar> {
  late bool _settingsExpanded = widget.activeItem == AccountNavItem.security;

  void _openProfile(BuildContext context) {
    if (widget.activeItem == AccountNavItem.profile) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileV2Screen(
          loginResponse: widget.loginResponse,
        ),
      ),
    );
  }

  void _openSecurity(BuildContext context) {
    if (widget.activeItem == AccountNavItem.security) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecurityScreen(loginResponse: widget.loginResponse),
      ),
    );
  }

  void _openKyc(BuildContext context) {
    if (widget.activeItem == AccountNavItem.kyc) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KYCSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool securityActive = widget.activeItem == AccountNavItem.security;

    return Container(
      width: 260,
      color: AppColors.kF0EDEC,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: _SidebarLogo(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _NavItem(
                    icon: Icons.person_outline,
                    title: "Profile",
                    active: widget.activeItem == AccountNavItem.profile,
                    onTap: () => _openProfile(context),
                  ),
                  _NavItem(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    active: securityActive,
                    trailing: Icon(
                      _settingsExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: securityActive ? Colors.white : Colors.grey,
                    ),
                    onTap: () {
                      setState(() => _settingsExpanded = !_settingsExpanded);
                    },
                  ),
                  if (_settingsExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _NavItem(
                        icon: Icons.shield_outlined,
                        title: "Security",
                        dense: true,
                        active: false,
                        highlighted: securityActive,
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: securityActive
                              ? const Color(0xFF6349BE)
                              : AppColors.k868686,
                        ),
                        onTap: () => _openSecurity(context),
                      ),
                    ),
                  _NavItem(
                    icon: Icons.people_alt_outlined,
                    title: "Select Partner",
                    active: widget.activeItem == AccountNavItem.selectPartner,
                    onTap: () {
                      if (widget.activeItem == AccountNavItem.selectPartner) {
                        return;
                      }
                      Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name ==
                                accountSelectPartnerRouteName ||
                            route.isFirst,
                      );
                    },
                  ),
                  // _NavItem(
                  //   icon: Icons.fact_check_outlined,
                  //   title: "KYC Verification",
                  //   active: widget.activeItem == AccountNavItem.kyc,
                  //   onTap: () => _openKyc(context),
                  // ),
                ],
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: _SignOutRow(),
            ),
          ],
        ),
      ),
    );
  }

}

class _SidebarLogo extends StatelessWidget {
  const _SidebarLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/icons/useful_icons/CitizenOneLogo.png",
      fit: BoxFit.fill,
      alignment: Alignment.centerLeft,
      errorBuilder: (context, error, stackTrace) => const AppText(
        'CitizenOne',
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final bool dense;

  /// Light-tint highlight (used for the Security sub-item) as opposed to
  /// the solid [active] highlight used for top-level items.
  final bool highlighted;
  final Widget? trailing;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.active,
    required this.onTap,
    this.dense = false,
    this.highlighted = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final Color? bg = active
        ? AppColors.k613AF5
        : highlighted
            ? const Color(0xFFC2B7F6)
            : null;
    final Color fg = active
        ? Colors.white
        : highlighted
            ? const Color(0xFF6349BE)
            : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: bg ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dense ? 12 : 14,
              vertical: dense ? 10 : 12,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: fg,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  const _SignOutRow();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => showLogoutDialog(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFDE9D9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Color(0xFFF97316), size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            "Sign Out",
            style: TextStyle(
              color: AppColors.kEF4444,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop/web page chrome shared by Select Partner, Profile and Security
/// (+ its sub-screens): fixed [AccountDesktopSidebar] + fixed top bar +
/// a scrollable, centered content area capped at [maxContentWidth] — mirrors
/// the reference web designs' "card in the middle of a light canvas" look.
class AccountDesktopScaffold extends StatelessWidget {
  final LoginUserReqResInfo loginResponse;
  final AccountNavItem activeItem;
  final String pageTitle;
  final String? pageSubtitle;
  final VoidCallback? onBack;
  final Widget child;
  final double maxContentWidth;

  /// Whether the back-chevron is rendered next to [pageTitle]. Defaults to
  /// `true` to preserve every existing caller's behavior; set to `false` for
  /// module-root screens with nothing meaningful to pop back to (e.g. the
  /// KYC search screen).
  final bool showBackButton;

  /// Whether the content area scrolls as a whole (`SingleChildScrollView`,
  /// the default — right for forms/cards). Set to `false` when [child]
  /// manages its own bounded-height scrolling internally (e.g. an
  /// `Expanded(ListView(...))` driving scroll-position pagination), since
  /// nesting that inside a `SingleChildScrollView` gives it unbounded height
  /// and breaks `Expanded`.
  final bool scrollable;

  const AccountDesktopScaffold({
    super.key,
    required this.loginResponse,
    required this.activeItem,
    required this.pageTitle,
    required this.child,
    this.pageSubtitle,
    this.onBack,
    this.maxContentWidth = 815,
    this.showBackButton = true,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackButton)
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 12, top: 2),
              child: Icon(
                Icons.chevron_left,
                size: 24,
                color: Colors.black87,
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pageTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.k0F0F0F,
              ),
            ),
            if (pageSubtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                pageSubtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.k868686,
                ),
              ),
            ],
          ],
        ),
      ],
    );

    final Widget content = scrollable
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: 28),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: child,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: 28),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          );

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: Row(
        children: [
          AccountDesktopSidebar(
            loginResponse: loginResponse,
            activeItem: activeItem,
          ),
          Expanded(
            child: Column(
              children: [
                const WebDashboardTopBar(),
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
