import 'package:flutter/material.dart';
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key}); // ✅ const constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      // 🔥 aligns with card
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
          color: Colors.black54,
        ),
      ),
    );
  }
}
