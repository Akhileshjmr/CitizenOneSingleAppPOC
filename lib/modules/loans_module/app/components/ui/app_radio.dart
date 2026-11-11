import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String title;
  final ValueChanged<T?> onChanged;

  final Color? activeColor;
  final TextStyle? textStyle;
  final double spacing;
  final bool dense;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.title,
    required this.onChanged,
    this.activeColor,
    this.textStyle,
    this.spacing = 6,
    this.dense = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primary;

    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            activeColor: color,
            onChanged: onChanged,
            materialTapTargetSize:
                dense
                    ? MaterialTapTargetSize.shrinkWrap
                    : MaterialTapTargetSize.padded,
            visualDensity:
                dense
                    ? const VisualDensity(horizontal: -4, vertical: -4)
                    : VisualDensity.standard,
          ),
          SizedBox(width: spacing),
          Flexible(
            child: Text(
              title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
