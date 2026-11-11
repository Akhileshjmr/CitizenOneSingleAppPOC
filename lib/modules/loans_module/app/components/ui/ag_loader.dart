import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

class AgLoader extends StatelessWidget {
  final double size;

  const AgLoader({super.key, this.size = 98});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}
