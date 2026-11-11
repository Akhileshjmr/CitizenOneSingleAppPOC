import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color = AppColors.black,
    this.radius = 25,
  });

  final Color? color;

  final double radius;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          alignment: Alignment.center,
          height: radius.r,
          width: radius.r,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 2,
          ),
        ),
      );
}
