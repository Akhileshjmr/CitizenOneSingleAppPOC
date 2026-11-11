import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:flutter_svg/svg.dart';

class ProfileMenuRow {
  final String icon;
  final String label;
  final Color color;
  final String? badge;
  final String? trailing;

  const ProfileMenuRow({
    required this.icon,
    required this.label,
    required this.color,
    this.badge,
    this.trailing,
  });
}

class ProfileMoreGroup {
  final String title;
  final String icon;
  final Color iconColor;
  final List<ProfileMenuRow> items;

  const ProfileMoreGroup({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
  });
}

class ProfileMenuPanel extends StatelessWidget {
  final List<ProfileMenuRow> items;

  const ProfileMenuPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Container(
      color: Colors.transparent,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ProfileMenuItem(item: item),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                  color: tokens.surfaceMuted,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final ProfileMenuRow item;

  const ProfileMenuItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    item.icon,
                    width: 15,
                    height: 15,
                    colorFilter: ColorFilter.mode(item.color, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AppText(
                        item.label,
                        style: AppTextStyle.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppText(
                          item.badge!,
                          style: AppTextStyle.labelSmall,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: item.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: AppText(
                    item.trailing!,
                    style: AppTextStyle.labelSmall,
                    fontSize: 11,
                    color: tokens.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: tokens.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMoreSection extends StatefulWidget {
  final List<ProfileMoreGroup> groups;

  const ProfileMoreSection({super.key, required this.groups});

  @override
  State<ProfileMoreSection> createState() => _ProfileMoreSectionState();
}

class _ProfileMoreSectionState extends State<ProfileMoreSection> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                AppText(
                  context.l10n.profileSectionMore,
                  style: AppTextStyle.labelSmall,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                  height: 16.0 / 13.0,
                  letterSpacing: 0.3,
                  color: AppColors.serviceHeaderTitle,
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: tokens.outline),
          ...widget.groups.asMap().entries.map((entry) {
            final index = entry.key;
            final group = entry.value;
            final isExpanded = _expandedIndex == index;
            return Column(
              children: [
                Material(
                  color: isExpanded
                      ? tokens.surfaceMuted.withValues(alpha: 0.3)
                      : tokens.surface,
                  child: InkWell(
                    onTap: () => setState(
                      () => _expandedIndex = isExpanded ? null : index,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: group.iconColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                group.icon,
                                width: 14,
                                height: 14,
                                colorFilter: ColorFilter.mode(
                                  group.iconColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: AppText(
                                    group.title,
                                    style: AppTextStyle.bodyMedium,
                                    fontWeight: FontWeight.w600,
                                    color: tokens.textPrimary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: tokens.surfaceMuted,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: AppText(
                                      '${group.items.length}',
                                      style: AppTextStyle.labelSmall,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: tokens.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: tokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    children: group.items.asMap().entries.map((itemEntry) {
                      final itemIndex = itemEntry.key;
                      final item = itemEntry.value;
                      return Column(
                        children: [
                          Material(
                            color: tokens.surface,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: item.color.withValues(
                                          alpha: 0.07,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          item.icon,
                                          width: 13,
                                          height: 13,
                                          colorFilter: ColorFilter.mode(
                                            item.color,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: AppText(
                                        item.label,
                                        style: AppTextStyle.bodySmall,
                                        fontWeight: FontWeight.w500,
                                        color: tokens.textSecondary,
                                      ),
                                    ),
                                    if (item.trailing != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: AppText(
                                          item.trailing!,
                                          style: AppTextStyle.labelSmall,
                                          fontSize: 10,
                                          color: tokens.textMuted,
                                        ),
                                      ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 16,
                                      color: tokens.textMuted.withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (itemIndex < group.items.length - 1)
                            Divider(
                              height: 1,
                              indent: 64,
                              endIndent: 14,
                              color: tokens.surfaceMuted,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                  sizeCurve: Curves.easeInOut,
                ),
                if (index < widget.groups.length - 1)
                  Divider(height: 1, color: tokens.surfaceMuted),
              ],
            );
          }),
        ],
      ),
    );
  }
}
