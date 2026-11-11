import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

class BankingQuickActions extends StatelessWidget {
  const BankingQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionSpec(
        icon: AppAssets.iconElectricBolt,
        label: context.l10n.serviceHealthActionVitals,
        backgroundColor: AppColors.serviceOrangeBg,
        iconColor: const Color(0xFFF97316),
      ),
      _ActionSpec(
        icon: AppAssets.iconWaterDrop,
        label: context.l10n.serviceHealthActionMedicines,
        backgroundColor: AppColors.serviceBlueBg,
        iconColor: const Color(0xFF3B82F6),
      ),
      _ActionSpec(
        icon: AppAssets.iconMobile,
        label: context.l10n.serviceHealthActionLabs,
        backgroundColor: AppColors.serviceLightPinkBg,
        iconColor: const Color(0xFFEC4899),
      ),
      _ActionSpec(
        icon: AppAssets.iconAdd,
        label: context.l10n.serviceBillPayActionAddNew,
        backgroundColor: AppColors.surfaceBg,
        iconColor: const Color(0xFF6B7280),
      ),
    ];
    return QuickActionsWidget(
      sectionTitle: null,
      showContainerBackground: true,
      sectionPadding: EdgeInsets.zero,
      itemsPerRow: 4,
      items: actions.map((a) {
        return QuickActionItem(
          title: a.label,
          icon: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: a.backgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SvgPicture.asset(
              a.icon,
              colorFilter: ColorFilter.mode(a.iconColor, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
          onTap: () {},
        );
      }).toList(),
    );
  }
}

class _ActionSpec {
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;

  const _ActionSpec({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
  });
}
