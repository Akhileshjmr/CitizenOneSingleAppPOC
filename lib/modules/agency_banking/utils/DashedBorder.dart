import 'dart:ui';
import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius? borderRadius;

  const DashedBorder({
    required this.child,
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.dashLength = 8.0,
    this.gapLength = 4.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius? borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (borderRadius != null) {
      path.addRRect(borderRadius!.toRRect(rect));
    } else {
      path.addRect(rect);
    }

    final dashPath = _createDashedPath(path, dashLength, gapLength);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path path, double dashLength, double gapLength) {
    final Path dashedPath = Path();
    final PathMetrics pathMetrics = path.computeMetrics();

    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;

      while (distance < pathMetric.length) {
        final double end = distance + dashLength;
        dashedPath.addPath(
          pathMetric.extractPath(distance, end),
          Offset.zero,
        );
        distance = end + gapLength;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
