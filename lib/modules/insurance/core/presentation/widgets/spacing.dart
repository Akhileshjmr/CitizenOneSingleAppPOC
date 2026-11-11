import 'package:flutter/widgets.dart';

class VSpace extends StatelessWidget {
  const VSpace(this.size, {super.key});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}

class HSpace extends StatelessWidget {
  const HSpace(this.size, {super.key});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}