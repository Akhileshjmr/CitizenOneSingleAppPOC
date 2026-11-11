import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

class ProgressItem extends StatelessWidget {
  final bool isActive;
  final double height;
  final double radius;

  const ProgressItem({
    super.key,
    this.isActive = false,
    this.height = 6,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
