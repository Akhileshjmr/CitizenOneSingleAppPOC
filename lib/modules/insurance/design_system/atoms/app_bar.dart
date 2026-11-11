import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:flutter/material.dart';

class AppStatusBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool centerTitle;
  final Color bgColor;
  final Color textIconColor;
  final VoidCallback? onPressed;
  final List<Widget>? actionList;
  final bool exitModule;

  const AppStatusBar(
      {super.key,
      required this.title,
      this.showBack = true,
      this.centerTitle = true,
      this.bgColor = AppColors.surface,
      this.textIconColor = AppColors.black,
      this.onPressed,
      this.actionList,
      this.exitModule = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: AppColors.surface,
      elevation: 0,
      leading: (showBack)
          ? IconButton(
              icon: const Icon(Icons.chevron_left,
                  size: 34, color: AppColors.serviceHeaderTitle),
              color: textIconColor,
              onPressed:
                  onPressed ?? () => exitModule ? context.pop() : context.pop(),
            )
          : const SizedBox.shrink(),
      title: AppText(
        title,
        style: AppTextStyle.bodyMedium,
        color: textIconColor,
        fontSize: 16,
      ),
      automaticallyImplyLeading: showBack,
      centerTitle: centerTitle,
      actions: actionList,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
