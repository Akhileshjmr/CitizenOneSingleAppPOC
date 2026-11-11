import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class HeroMetricBlock extends StatelessWidget {
  final String? title;
  final String? metricLabel;
  final String metricValue;
  final String? note;
  final Widget? badge;
  final Color textColor;
  final Color? secondaryTextColor;

  const HeroMetricBlock({
    super.key,
    this.title,
    this.metricLabel,
    required this.metricValue,
    this.note,
    this.badge,
    required this.textColor,
    this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final subColor = secondaryTextColor ?? textColor.withValues(alpha: 0.75);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          AppText(
            title!,
            style: AppTextStyle.displaySmall,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: -0.5,
          ),
          const SizedBox(height: 10),
        ],
        if (metricLabel != null) ...[
          AppText(metricLabel!, style: AppTextStyle.bodySmall, color: subColor),
          const SizedBox(height: 4),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              metricValue,
              style: AppTextStyle.metricLarge,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
            if (badge != null) ...[const SizedBox(width: 10), badge!],
          ],
        ),
        if (note != null) ...[
          const SizedBox(height: 4),
          AppText(note!, style: AppTextStyle.bodySmall, color: subColor),
        ],
      ],
    );
  }
}
