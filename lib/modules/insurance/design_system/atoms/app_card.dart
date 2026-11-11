// =============================================================================
// AppCard  —  ATOM
// -----------------------------------------------------------------------------
// Container with consistent radius, surface color, optional border and tap
// handling. The bedrock of every "card-shaped" molecule.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.elevation,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double? elevation;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? AppSpacing.radiusLg);
    final resolvedColor = gradient != null
        ? Colors.transparent
        : (color ?? context.colors.surface);

    final inner = Container(
      padding: padding ?? AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: resolvedColor,
        gradient: gradient,
        borderRadius: radius,
        border: borderColor == null
            ? Border.all(color: context.colors.border)
            : Border.all(color: borderColor!),
        boxShadow: (elevation ?? 0) > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: (elevation ?? 0) * 4,
                  offset: Offset(0, (elevation ?? 0)),
                ),
              ]
            : null,
      ),
      child: child,
    );

    final tappable = onTap == null
        ? inner
        : Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: inner,
            ),
          );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: tappable,
    );
  }
}
