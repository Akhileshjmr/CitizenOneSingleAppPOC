import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/atoms/press_scale_widget.dart';
import 'package:flutter_svg/svg.dart';

enum QuickActionStyle { roundedSquare, circle }

class QuickActionButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final QuickActionStyle style;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.bgColor,
    this.iconColor,
    this.onTap,
    this.style = QuickActionStyle.roundedSquare,
  });

  factory QuickActionButton.fromData({
    required String icon,
    required String label,
    Color? color,
    Color? backgroundColor,
    Color? iconColor,
    VoidCallback? onTap,
    QuickActionStyle style = QuickActionStyle.circle,
  }) {
    return QuickActionButton(
      icon: icon,
      label: label,
      bgColor: backgroundColor ?? color ?? const Color(0xFF613AF5),
      iconColor: iconColor,
      onTap: onTap,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final isSquare = style == QuickActionStyle.roundedSquare;
    final boxSize = 52.0;

    return PressScaleWidget(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  : null,
            ),
          ),
          SizedBox(height: isSquare ? 12 : 8),
          SizedBox(
            width: 70,
            child: AppText(
              label,
              style: AppTextStyle.caption,
              fontWeight: FontWeight.w500,
              color: tokens.textPrimary,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
