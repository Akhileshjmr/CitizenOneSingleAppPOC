import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';

class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final VoidCallback? onTap;
  final double borderRadius;

  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.04,
    this.onTap,
    this.borderRadius = 16,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovering ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: _hovering ? tokens.shadowMd : [],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
