import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final activeColor = selectedColor ?? tokens.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor.withValues(alpha: 0.1) : tokens.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? activeColor : tokens.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: selected ? activeColor : tokens.textSecondary),
              const SizedBox(width: 5),
            ],
            AppText(
              label,
              style: AppTextStyle.bodySmall,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? activeColor : tokens.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
