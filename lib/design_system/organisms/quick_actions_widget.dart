import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';

import '../atoms/app_text.dart';

/// A reusable horizontal Quick Actions component based on the Figma design system.
///
/// Features dynamic section headers, customizable items, horizontal scrolling,
/// and an optional "Add New" action.
class QuickActionsWidget extends StatelessWidget {
  // --- Section Features ---

  /// Dynamic section title. If null, the header is not rendered.
  final String? sectionTitle;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;

  /// Optional subtitle below the section title.
  final String? subtitle;

  /// Optional text for a "View All" action. If null, action is hidden.
  final String? viewAllText;

  /// Callback for "View All" tap.
  final VoidCallback? onViewAllTap;

  /// Custom padding for the entire section.
  final EdgeInsetsGeometry sectionPadding;

  // --- Quick Action Item Features ---

  /// List of items to display.
  final List<QuickActionItem> items;

  /// Number of items to display per row (e.g., 2, 3, or 4). Defaults to 4.
  final int itemsPerRow;

  /// Width of each item. If null, it calculates width dynamically based on itemsPerRow.
  final double? itemWidth;

  /// Spacing between items.
  final double spacing;

  /// Background color for the item cards.
  final Color? defaultItemBackgroundColor;

  /// Background color for the icon containers.
  final Color? defaultIconBackgroundColor;

  /// Border radius of the item cards.
  final double borderRadius;

  /// Shadow elevation for the item cards.
  final double elevation;

  /// Icon size inside the item.
  final double iconSize;

  // --- Add New Item Support ---

  /// Whether to show a special "Add New" action as the first item.
  final bool showAddNew;

  /// Icon for the "Add New" action.
  final dynamic addIcon;

  /// Background color of the "Add New" item.
  final Color? addNewBackgroundColor;

  /// Icon background color for the "Add New" item.
  final Color? addNewIconBackgroundColor;

  /// Callback when "Add New" is tapped.
  final VoidCallback? onAddNewTap;

  /// Title text for "Add New".
  final String addNewTitle;

  /// Whether to show the unified card container background and shadow.
  final bool showContainerBackground;

  const QuickActionsWidget({
    super.key,
    this.sectionTitle,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.subtitle,
    this.viewAllText,
    this.onViewAllTap,
    this.sectionPadding = const EdgeInsets.symmetric(
      vertical: 24.0,
      horizontal: 16.0,
    ),
    required this.items,
    this.itemsPerRow = 4,
    this.itemWidth,
    this.spacing = 16.0,
    this.defaultItemBackgroundColor,
    this.defaultIconBackgroundColor,
    this.borderRadius = 8.0,
    this.elevation = 4.0,
    this.iconSize = 24.0,
    this.showAddNew = false,
    this.addIcon = Icons.add,
    this.addNewBackgroundColor,
    this.addNewIconBackgroundColor,
    this.onAddNewTap,
    this.addNewTitle = 'Add New',
    this.showContainerBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTitleColor = titleColor ?? AppColors.horizantalHeaderTitle;
    final effectiveItemBg = defaultItemBackgroundColor ?? theme.cardColor;
    final effectiveIconBg =
        defaultIconBackgroundColor ?? theme.primaryColor.withValues(alpha: 0.1);

    // The item width is calculated dynamically inside the LayoutBuilder below.

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sectionPadding.vertical / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sectionTitle != null)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sectionPadding.horizontal / 2,
              ),
              child: _buildHeader(context, effectiveTitleColor),
            ),

          if (sectionTitle != null) const SizedBox(height: 28),

          Padding(
            padding: showContainerBackground
                ? EdgeInsets.symmetric(
                    horizontal: sectionPadding.horizontal / 2,
                  )
                : const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: showContainerBackground
                  ? const EdgeInsets.all(16.0)
                  : EdgeInsets.zero,
              decoration: showContainerBackground
                  ? BoxDecoration(
                      color: effectiveItemBg,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: elevation > 0
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: elevation * 2,
                                offset: Offset(0, elevation),
                              ),
                            ]
                          : [],
                    )
                  : null,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final dynamicWidth =
                      itemWidth ??
                      ((availableWidth - ((itemsPerRow - 1) * spacing)) /
                              itemsPerRow) -
                          0.01;

                  final allItems = <Widget>[];

                  allItems.addAll(
                    items.map(
                      (item) => _buildActionItem(
                        context,
                        item,
                        dynamicWidth,
                        Colors.transparent,
                        effectiveIconBg,
                      ),
                    ),
                  );

                  if (showAddNew) {
                    allItems.add(
                      _buildAddNewItem(
                        context,
                        dynamicWidth,
                        Colors.transparent,
                        effectiveIconBg,
                      ),
                    );
                  }
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: allItems,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color titleColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                sectionTitle!,
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.w700,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4.0),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: titleColor.withValues(alpha: 0.6),
                    fontSize: (titleFontSize ?? 18.0) * 0.75,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (viewAllText != null)
          GestureDetector(
            onTap: onViewAllTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  viewAllText!,
                  style: AppTextStyle.titleSmall,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Icon(
                  LucideIcons.arrow_right,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAddNewItem(
    BuildContext context,
    double width,
    Color fallbackBg,
    Color fallbackIconBg,
  ) {
    return _QuickActionCard(
      title: addNewTitle,
      icon: addIcon,
      onTap: onAddNewTap,
      width: width,
      itemBackgroundColor: addNewBackgroundColor ?? fallbackBg,
      iconBackgroundColor: addNewIconBackgroundColor ?? fallbackIconBg,
      textColor: Theme.of(context).primaryColor,
      iconColor: Theme.of(context).primaryColor,
      borderRadius: borderRadius,
      elevation: 0.0,
      iconSize: iconSize,
      showContainerBackground: showContainerBackground,
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    QuickActionItem item,
    double width,
    Color fallbackBg,
    Color fallbackIconBg,
  ) {
    return _QuickActionCard(
      title: item.title,
      icon: item.icon,
      onTap: item.onTap,
      isDisabled: item.isDisabled,
      badgeCount: item.badgeCount,
      width: width,
      itemBackgroundColor: item.itemBackgroundColor ?? fallbackBg,
      iconBackgroundColor: item.iconBackgroundColor ?? fallbackIconBg,
      textColor: item.textColor ?? Colors.black,
      iconColor: item.iconColor ?? Theme.of(context).primaryColor,
      borderRadius: borderRadius,
      elevation: 0.0,
      iconSize: iconSize,
      showContainerBackground: showContainerBackground,
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final dynamic icon;
  final VoidCallback? onTap;
  final bool isDisabled;
  final int? badgeCount;
  final double width;
  final Color itemBackgroundColor;
  final Color iconBackgroundColor;
  final Color? textColor;
  final Color iconColor;
  final double borderRadius;
  final double elevation;
  final double iconSize;
  final bool showContainerBackground;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    this.onTap,
    this.isDisabled = false,
    this.badgeCount,
    required this.width,
    required this.itemBackgroundColor,
    required this.iconBackgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.borderRadius,
    required this.elevation,
    required this.iconSize,
    required this.showContainerBackground,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveElevation = isDisabled ? 0.0 : elevation;
    final effectiveOpacity = isDisabled ? 0.5 : 1.0;

    return Opacity(
      opacity: effectiveOpacity,
      child: SizedBox(
        width: width,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: itemBackgroundColor == Colors.transparent
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: itemBackgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: effectiveElevation > 0
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: effectiveElevation * 2,
                              offset: Offset(0, effectiveElevation),
                            ),
                          ]
                        : [],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      icon is Widget
                          ? _buildIcon()
                          : Container(
                              width: 52,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: iconBackgroundColor,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: _buildIcon(),
                            ),
                      if (badgeCount != null && badgeCount! > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              badgeCount! > 99 ? '99+' : badgeCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.87,
                    fontWeight: FontWeight.w500,
                    height: 14.49 / 10.87,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon as IconData, color: iconColor, size: iconSize);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon as String,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        width: iconSize,
        height: iconSize,
      );
    } else if (icon is Widget) {
      return icon as Widget;
    }
    return SizedBox(width: iconSize, height: iconSize);
  }
}
