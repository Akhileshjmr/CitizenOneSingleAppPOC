import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final dynamic icon; // IconData or String
  final Color color;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: label,
      onPressed: onTap,
      variant: AppButtonVariant.outline,
      icon: icon,
      foregroundColor: color,
      backgroundColor: borderColor,
      height: 46,
    );
  }
}
