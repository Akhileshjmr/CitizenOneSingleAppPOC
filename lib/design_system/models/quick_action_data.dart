import 'package:flutter/material.dart';

class QuickActionData {
  final String icon;
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const QuickActionData({
    required this.icon,
    required this.label,
    this.color,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });
}
