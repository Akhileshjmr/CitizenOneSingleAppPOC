import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:flutter/material.dart';

class AppStatusBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool centerTitle;
  final Color bgColor;
  final Color textIconColor;

  const AppStatusBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.centerTitle = true,
    this.bgColor = AppColors.surface,
    this.textIconColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: AppColors.surface,
      elevation: 0,
      leading: (showBack)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              color: textIconColor,
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox.shrink(),
      title: AppText(
        title,
        style: AppTextStyle.bodyMedium,
        color: textIconColor,
      ),
      automaticallyImplyLeading: showBack,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
