import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text.dart';
import 'package:flutter/material.dart';

import 'package:citizenone_app/modules/agency_banking/theme/app_theme_style.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
/// A single row under "Common Questions", e.g. "Where can I find my loan
/// number?" with a leading icon and trailing chevron.
class CommonQuestionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CommonQuestionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(AppThemeStyle.listTileRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppThemeStyle.listTileRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.secondaryText),
              const SizedBox(width: 14),
              Expanded(
                child: AppText(label, style: AppThemeStyle.listTileText),
              ),
              const Icon(Icons.chevron_right,
                  size: 20, color: AppColors.secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}