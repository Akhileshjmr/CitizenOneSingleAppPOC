import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String label;
  final bool isRequired;
  const FormHeader({super.key, required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: " *",
                  style: TextStyle(color: AppColors.brandRed),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
