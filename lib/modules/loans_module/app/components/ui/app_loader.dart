import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';


/// Circular progress indicator
class AppLoader extends StatelessWidget {
  /// Circular progress indicator
  const AppLoader({
    Key? key,
    this.color = AppColors.black,
    this.radius = 25,
  }) : super(key: key);

  /// Color of the loader
  final Color? color;

  /// Size of the loader
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
