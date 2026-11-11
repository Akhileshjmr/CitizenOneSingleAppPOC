import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:flutter/material.dart';

import '../../../../../theme/colors/Appcolors.dart';

class KycAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool centerTitle;
  final Color bgColor;
  final Color textIconColor;

  const KycAppBar(
      {super.key,
      required this.title,
      this.showBack = true,
      this.centerTitle = true,
      this.bgColor = AppColors.white,
      this.textIconColor = AppColors.black});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      leading: (showBack)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              color: textIconColor,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            )
          : const SizedBox.shrink(),
      title: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.fontSize(context, mobile: 14, web: 8),
          fontWeight: FontWeight.bold,
          color: textIconColor,
        ),
      ),
      automaticallyImplyLeading: showBack,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
