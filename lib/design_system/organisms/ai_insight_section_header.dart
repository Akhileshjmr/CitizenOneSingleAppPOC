import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class AiInsightSectionHeader extends StatelessWidget {
  final String label;

  const AiInsightSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Row(
      children: [
        Icon(LucideIcons.sparkles, size: 16, color: tokens.accent),
        const SizedBox(width: 8),
        AppText(
          label.toUpperCase(),
          style: AppTextStyle.caption,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: tokens.accent,
        ),
      ],
    );
  }
}
