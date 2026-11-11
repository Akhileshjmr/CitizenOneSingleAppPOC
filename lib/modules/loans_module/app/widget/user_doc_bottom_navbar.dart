import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

typedef UploadDocCallback = void Function();

class UserDocBottomNavBar extends StatelessWidget {
  final UploadDocCallback onPressedUploadDoc;

  bool isBottom;
  UserDocBottomNavBar({
    required this.isBottom,
    required this.onPressedUploadDoc,
  });

  @override
  Widget build(BuildContext context) {
    if (isBottom == true) {
      return Container(
        height: 44,

        margin: EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: MaterialButton(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0.1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          onPressed: () {
            onPressedUploadDoc();
          },
          child: Text("Upload Document", style: kw500White14),
        ),
      );
    } else {
      return Container(height: 0);
    }
  }
}
