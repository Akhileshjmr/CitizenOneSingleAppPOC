import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double blur;
  final Color? color;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.blur = 10,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final radius = borderRadius ?? tokens.radiusMd;
    final glassColor = color ?? Colors.white.withValues(alpha: 0.85);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border ??
            Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.0,
            ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [glassColor, glassColor.withValues(alpha: 0.05)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(padding: padding, child: child),
        ),
      ),
    );
  }
}
