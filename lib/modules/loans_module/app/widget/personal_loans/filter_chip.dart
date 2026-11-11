import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../theme/ag_text_styles.dart';

class FilterChipWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FilterChipWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kC6C6C6),
        ),
        child: Center(child: Text(title, style: kw500Black12)),
      ),
    );
  }
}
