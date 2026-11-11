import 'dart:math';

import 'package:flutter/material.dart';

class WindDirectionArrow extends StatelessWidget {
  final int degree; // meteorological direction FROM
  final double size;
  final Color color;

  const WindDirectionArrow({
    super.key,
    required this.degree,
    this.size = 22,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final double rad = ((degree + 180) % 360) * pi / 180;

    return Transform.rotate(
      angle: rad,
      child: Icon(Icons.arrow_upward, size: size, color: color),
    );
  }
}
