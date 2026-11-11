import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

class AnimatedInputWrapper extends StatefulWidget {
  final Widget child;
  final bool hasError;
  final bool isActive;

  const AnimatedInputWrapper({
    super.key,
    required this.child,
    this.hasError = false,
    this.isActive = false,
  });

  @override
  State<AnimatedInputWrapper> createState() => _AnimatedInputWrapperState();
}

class _AnimatedInputWrapperState extends State<AnimatedInputWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(AnimatedInputWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shakeCtrl.forward().then((_) => _shakeCtrl.reverse());
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return AnimatedBuilder(
      animation: _shakeCtrl,
      builder: (_, child) => Transform.translate(
        offset: Offset(widget.hasError ? _shakeAnim.value : 0, 0),
        child: child,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scaleByDouble(
            widget.isActive ? 1.01 : 1.0,
            widget.isActive ? 1.01 : 1.0,
            widget.isActive ? 1.01 : 1.0,
            1.0,
          ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          boxShadow: widget.isActive
              ? [
                  BoxShadow(
                    color: tokens.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
