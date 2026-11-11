import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/models/quick_action_data.dart';
import 'package:citizenone_app/design_system/models/service_list_data.dart';
import 'package:citizenone_app/design_system/molecules/service_list_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';
export 'package:citizenone_app/design_system/models/quick_action_data.dart';
export 'package:citizenone_app/design_system/models/service_list_data.dart';

class MiniServiceScaffold extends StatelessWidget {
  final String title;
  final Widget hero;
  final List<QuickActionData> quickActions;
  final List<ServiceListData> services;
  final Widget? aiInsight;

  const MiniServiceScaffold({
    super.key,
    required this.title,
    required this.hero,
    required this.quickActions,
    required this.services,
    this.aiInsight,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          title,
          style: AppTextStyle.headlineSmall,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: false,
        backgroundColor: tokens.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: tokens.outline, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(tokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            hero,
            SizedBox(height: tokens.spacing2xl),
            QuickActionsWidget(
              sectionTitle: 'Quick Actions',
              showContainerBackground: true,
              sectionPadding: EdgeInsets.zero,
              itemsPerRow: 4,
              items: quickActions.map((a) {
                final iconBg =
                    a.backgroundColor ?? tokens.primary.withValues(alpha: 0.1);
                final iconColor = a.iconColor;

                return QuickActionItem(
                  title: a.label,
                  icon: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: SvgPicture.asset(
                      a.icon,
                      colorFilter: iconColor != null
                          ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                          : null,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: a.onTap ?? () {},
                );
              }).toList(),
            ),
            SizedBox(height: tokens.spacing2xl),
            _SectionLabel(text: 'Services'),
            SizedBox(height: tokens.spacingMd),
            ...services.map(
              (s) => ServiceListTile(
                title: s.title,
                subtitle: s.subtitle,
                onTap: s.onTap,
              ),
            ),
            if (aiInsight != null) ...[aiInsight!],
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return AppText(
      text,
      style: AppTextStyle.headlineSmall,
      fontWeight: FontWeight.w700,
      color: tokens.textPrimary,
      letterSpacing: 0.8,
    );
  }
}
