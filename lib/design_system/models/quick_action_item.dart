import 'package:flutter/material.dart';

/// Model representing a single item within the [QuickActionsWidget].
/// 
/// Contains dynamic properties to fully customize each action item's appearance and behavior.
class QuickActionItem {
  /// The title displayed below the icon.
  final String title;

  /// The icon to display. Can be an [IconData] or a [String] representing an SVG asset path.
  final dynamic icon;

  /// The callback executed when the item is tapped.
  final VoidCallback onTap;

  /// The background color behind the icon itself.
  final Color? iconBackgroundColor;

  /// The background color of the entire item card.
  final Color? itemBackgroundColor;

  /// The color of the title text.
  final Color? textColor;

  /// The color of the icon.
  final Color? iconColor;

  /// Whether the item is disabled (grayed out and non-clickable).
  final bool isDisabled;

  /// An optional count/badge to display over the icon.
  final int? badgeCount;

  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconBackgroundColor,
    this.itemBackgroundColor,
    this.textColor,
    this.iconColor,
    this.isDisabled = false,
    this.badgeCount,
  });
}
