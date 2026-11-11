import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import 'app_loader.dart';

/// App button
class AppButton extends StatelessWidget {
  /// App button
  const AppButton({
    this.label = '',
    required this.onTap,
    this.isLoading = false,
    Key? key,
    this.backgroundColor,
    this.foregroundColor = AppColors.kffffff,
    this.labelStyle,
    this.buttonSize,
    this.elevation,
    this.shape,
    this.margin = EdgeInsets.zero,
    this.child,
  }) : super(key: key);

  /// Background color of the button
  final Color? backgroundColor;

  /// Foreground color of the button. Gets applied to the text and
  /// the circular loader
  final Color? foregroundColor;

  /// Callback when the button is pressed
  final VoidCallback onTap;

  /// Button label
  final String label;

  /// If the button is loading or not
  final bool isLoading;

  /// If the button is loading or not
  final TextStyle? labelStyle;

  /// button size
  /// Default: Size(320.w,40.h)
  final Size? buttonSize;

  /// Button elevation
  final double? elevation;

  /// Button Shape
  final OutlinedBorder? shape;

  /// Button margin
  final EdgeInsetsGeometry margin;

  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: margin,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor,
        fixedSize: buttonSize ?? Size(320.w, 40.h),
        elevation: elevation ?? 0,
        shape:
            shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        if (!isLoading) {
          onTap();
        }
      },
      child:
          isLoading ? _buildLoader() : child ?? Text(label, style: labelStyle),
    ),
  );

  AppLoader _buildLoader() => AppLoader(color: foregroundColor, radius: 15);
}
