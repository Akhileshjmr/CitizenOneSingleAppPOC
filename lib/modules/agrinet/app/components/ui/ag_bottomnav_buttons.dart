import 'package:flutter/material.dart';

import '../../utils/ag_colors.dart';
import 'ag_button.dart';

class BottomNavButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSaveDraft;
  final VoidCallback? onNext;

  const BottomNavButtons({
    super.key,
    this.onBack,
    this.onSaveDraft,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          _bottomBtn("Back", true, onBack),
          _bottomBtn("Save Draft", true, onSaveDraft),
          _bottomBtn("Next", false, onNext),
        ],
      ),
    );
  }

  /// Internal button builder using AgButton
  Widget _bottomBtn(String title, bool isOutlined, VoidCallback? onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: AgButton(
          title: title,
          isOutlined: isOutlined,
          width: double.infinity,
          borderRadius: 14,
          padding: const EdgeInsets.symmetric(vertical: 4),

          /// Colors
          backgroundColor: isOutlined ? Colors.white : AgColors.buttonColor,
          outlineColor: AgColors.buttonColor,
          textStyle: TextStyle(
            color: isOutlined ? AgColors.buttonColor : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),

          onTap: onTap,
        ),
      ),
    );
  }
}
