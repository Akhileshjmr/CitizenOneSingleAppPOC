import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class GenericServiceScreen extends StatelessWidget {
  final String title;
  final String heroTitle;
  final String heroSubtitle;
  final Color themeColor;

  const GenericServiceScreen({
    super.key,
    required this.title,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText(title, style: AppTextStyle.bodyLarge, fontWeight: FontWeight.bold)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: themeColor),
            const SizedBox(height: 16),
            AppText(heroTitle, style: AppTextStyle.headlineMedium, fontWeight: FontWeight.bold),
            AppText(heroSubtitle, style: AppTextStyle.bodyMedium),
          ],
        ),
      ),
    );
  }
}
