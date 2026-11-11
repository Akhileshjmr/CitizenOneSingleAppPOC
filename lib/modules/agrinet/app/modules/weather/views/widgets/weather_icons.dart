import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;
  final Color? color; // <--- ADD THIS

  const WeatherIcon({
    super.key,
    required this.iconCode,
    this.size = 90,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (iconCode.isEmpty) {
      return Icon(Icons.cloud, size: size, color: color ?? Colors.white);
    }

    final url = "https://openweathermap.org/img/wn/${iconCode}@2x.png";

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder:
          (_, __, ___) =>
              Icon(Icons.cloud, size: size, color: color ?? Colors.white),
    );
  }
}
