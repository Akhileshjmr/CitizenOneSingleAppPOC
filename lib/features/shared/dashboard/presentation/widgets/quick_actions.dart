import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

class QuickActions extends StatelessWidget {
  final UserRole role;

  const QuickActions({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return QuickActionsWidget(
      sectionTitle:
          null, // Title is already handled by SuperHomeScreen's SectionHeader
      showContainerBackground: true,
      sectionPadding: EdgeInsets.zero,
      itemsPerRow: 4,
      items: _actionsForRole(context, role).map((a) {
        return QuickActionItem(
          title: a.label,
          icon: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: a.bgColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SvgPicture.asset(
              a.icon,
              colorFilter: a.iconColor != null
                  ? ColorFilter.mode(a.iconColor!, BlendMode.srcIn)
                  : null,
            ),
          ),
          onTap: () {
            if (a.route != null) {
              context.push(a.route!);
            }
          },
        );
      }).toList(),
    );
  }

  List<_ActionSpec> _actionsForRole(BuildContext context, UserRole role) {
    final tokens = context.appTokens;
    final l10n = context.l10n;

    if (role == UserRole.farmer) {
      return [
        // _ActionSpec(
        //   l10n.quickActionAgriLoan,
        //   AppAssets.sprout,
        //   tokens.brandGreen.withValues(alpha: 0.1),
        //   iconColor: tokens.brandGreen,
        //   route: '/common/loans',
        // ),
        // _ActionSpec(
        //   l10n.quickActionWeather,
        //   AppAssets.cloud,
        //   tokens.brandBlue.withValues(alpha: 0.1),
        //   iconColor: tokens.brandBlue,
        // ),
        // _ActionSpec(
        //   l10n.quickActionMarket,
        //   AppAssets.shopping_cart,
        //   tokens.brandOrange.withValues(alpha: 0.1),
        //   iconColor: tokens.brandOrange,
        //   route: '/customer/services/market',
        // ),
        // _ActionSpec(
        //   l10n.quickActionSupport,
        //   AppAssets.life_buoy,
        //   tokens.brandGreen.withValues(alpha: 0.1),
        //   iconColor: tokens.brandGreen,
        // ),
      ];
    }
    if (role == UserRole.agent) {
      return [
        _ActionSpec(
          l10n.quickActionOnboard,
          AppAssets.iconPersonAddAlt,
          tokens.brandIndigo.withValues(alpha: 0.1),
          // iconColor: tokens.brandIndigo,
          route: '/agent/customers',
        ),
        _ActionSpec(
          l10n.quickActionCollect,
          AppAssets.iconAccountBalanceWallet,
          tokens.brandGreen.withValues(alpha: 0.1),
          // iconColor: tokens.brandGreen,
          route: '/agent/collections',
        ),
        _ActionSpec(
          l10n.quickActionTodayTasks,
          AppAssets.iconNote,
          tokens.warning.withValues(alpha: 0.1),
          // iconColor: tokens.warning,
          route: '/agent/tasks',
        ),
        _ActionSpec(
          l10n.quickActionSupport,
          AppAssets.iconSupport,
          tokens.brandIndigo.withValues(alpha: 0.1),
          // iconColor: tokens.brandIndigo,
        ),
      ];
    }
    return [
      _ActionSpec(
        l10n.quickActionPay,
        AppAssets.iconSend,
        tokens.primary.withValues(alpha: 0.1),
        // iconColor: tokens.primary,
        route: '/customer/services/bills',
      ),
      _ActionSpec(
        l10n.quickActionScanQr,
        AppAssets.iconQrCode,
        tokens.brandPurple.withValues(alpha: 0.1),
        // iconColor: tokens.brandPurple,
      ),
      _ActionSpec(
        l10n.quickActionApplyLoan,
        AppAssets.iconCurrency,
        tokens.brandOrange.withValues(alpha: 0.1),
        // iconColor: tokens.brandOrange,
        route: '/common/loans',
      ),
      _ActionSpec(
        l10n.quickActionSupport,
        AppAssets.iconSupport,
        tokens.brandGreen.withValues(alpha: 0.1),
        // iconColor: AppColors.serviceMobileBg,
      ),
    ];
  }
}

class _ActionSpec {
  final String label;
  final String icon;
  final Color bgColor;
  final Color? iconColor;
  final String? route;

  const _ActionSpec(
    this.label,
    this.icon,
    this.bgColor, {
    this.iconColor,
    this.route,
  });
}
