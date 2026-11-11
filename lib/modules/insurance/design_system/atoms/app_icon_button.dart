import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';

/// A square or circular icon-only button.
class AppIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.size = 48,
    this.iconSize = 20,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final fg = iconColor ?? tokens.textSecondary;
    final border = borderColor ?? tokens.outline;

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border),
            ),
            child: SvgPicture.asset(
              package: AppConfig.packageName,
              icon,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
