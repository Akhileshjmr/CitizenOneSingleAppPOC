import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

enum AppChipTone { neutral, primary, success, warning, danger, info }

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;
  final AppChipTone tone;
  final bool showBorder;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.selectedColor,
    this.tone = AppChipTone.neutral,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final activeColor = selectedColor ?? _toneColor(tokens);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor.withValues(alpha: 0.1) : tokens.surface,
          borderRadius: BorderRadius.circular(100),
          border: showBorder
              ? Border.all(
                  color: selected ? activeColor : tokens.outline,
                  width: selected ? 1.5 : 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 14,
                  color: selected ? activeColor : tokens.textSecondary),
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

  Color _toneColor(AppThemeTokens tokens) {
    return switch (tone) {
      AppChipTone.success => tokens.success,
      AppChipTone.warning => tokens.warning,
      AppChipTone.danger => tokens.error,
      AppChipTone.info => tokens.brandBlue,
      AppChipTone.primary => tokens.primary,
      AppChipTone.neutral => tokens.primary,
    };
  }
}
