// =============================================================================
// ProgressRingLoader — the global circular gradient indicator shown at the
// top of the Transaction/Policy Processing screen while any processing is
// in flight. Represents the overall workflow, independent of the per-card
// step indicators below it.
// =============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';

class ProgressRingLoader extends StatefulWidget {
  const ProgressRingLoader({super.key, this.size = 84});

  final double size;

  @override
  State<ProgressRingLoader> createState() => _ProgressRingLoaderState();
}

class _ProgressRingLoaderState extends State<ProgressRingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          painter: _RingPainter(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    const strokeWidth = 5.0;
    const sweepAngle = math.pi * 2 * 0.82;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.45),
          color.withValues(alpha: 0.75),
          color.withValues(alpha: 0.35),
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.0),
        ],
        stops: const [
          0.00,
          0.12,
          0.35,
          0.55,
          0.74,
          0.82,
          1.00,
        ],
      ).createShader(rect);

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      0,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
