import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? valueFontWeight;
  final Widget? valueWidget;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueFontWeight,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, style: AppTextStyle.bodySmall, color: tokens.textSecondary),
          const SizedBox(width: 16),
          Flexible(
            child: valueWidget ??
                AppText(
                  value,
                  style: AppTextStyle.bodySmall,
                  color: valueColor ?? tokens.textPrimary,
                  fontWeight: valueFontWeight ?? FontWeight.w600,
                  textAlign: TextAlign.right,
                ),
          ),
        ],
      ),
    );
  }
}
