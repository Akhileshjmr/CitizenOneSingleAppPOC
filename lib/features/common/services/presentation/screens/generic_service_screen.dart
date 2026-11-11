import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/components/shared/mini_service_scaffold.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';

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
    final tokens = context.appTokens;

    return MiniServiceScaffold(
      title: title,
      hero: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [themeColor, themeColor.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              heroTitle,
              style: AppTextStyle.headlineMedium,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            AppText(
              heroSubtitle,
              style: AppTextStyle.bodyMedium,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: themeColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: AppText(
                'Get Started', // TODO: Localize if this is a common button
                style: AppTextStyle.bodySmall,
                fontWeight: FontWeight.w600,
                color: themeColor,
              ),
            ),
          ],
        ),
      ),
      quickActions: [
        QuickActionData(
          icon: AppAssets.iconAdd,
          label: 'Search',
          backgroundColor: themeColor.withValues(alpha: 0.1),
          iconColor: themeColor,
          onTap: () {},
        ),
        QuickActionData(
          icon: AppAssets.iconHistory,
          label: 'History',
          backgroundColor: themeColor.withValues(alpha: 0.1),
          iconColor: themeColor,
          onTap: () {},
        ),
        QuickActionData(
          icon: AppAssets.iconSettings,
          label: 'Settings',
          backgroundColor: themeColor.withValues(alpha: 0.1),
          iconColor: themeColor,
          onTap: () {},
        ),
        QuickActionData(
          icon: AppAssets.iconHealthAndSafety,
          label: 'Help',
          backgroundColor: tokens.surfaceMuted,
          iconColor: tokens.textSecondary,
          onTap: () {},
        ),
      ],
      services: [
        ServiceListData(title: 'Service Option 1', onTap: () {}),
        ServiceListData(title: 'Service Option 2', onTap: () {}),
        ServiceListData(title: 'Support & FAQs', onTap: () {}),
      ],
      aiInsight: null, // No AI for generic yet
    );
  }
}
