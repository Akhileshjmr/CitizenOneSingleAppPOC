// =============================================================================
// AuthTemplate  —  TEMPLATE
// -----------------------------------------------------------------------------
// Centered, scroll-safe layout used by all auth pages (sign-in, sign-up,
// forgot password). Owns the brand mark + tagline; the actual form is a
// slot.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class AuthTemplate extends StatelessWidget {
  const AuthTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    this.brandMark,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget? brandMark;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: context.layout.maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    brandMark ?? _DefaultBrandMark(),
                    const AppSpacer.lg(),
                    AppText(title,
                        variant: AppTextVariant.headline,
                        textAlign: TextAlign.center),
                    const AppSpacer.sm(),
                    AppText(subtitle,
                        variant: AppTextVariant.body,
                        color: context.colors.textSecondary,
                        textAlign: TextAlign.center),
                  ],
                ),
                const AppSpacer.xl(),
                form,
                if (footer != null) ...[
                  const AppSpacer.xl(),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultBrandMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Icon(Icons.account_balance_rounded,
          color: c.onPrimary, size: 32),
    );
  }
}
