// =============================================================================
// AppAlertBanner  —  MOLECULE
// -----------------------------------------------------------------------------
// The single reusable alert card described by Alert.svg, in its two shapes:
//   - AppAlertShape.banner — wide, page-embedded, neutral-dark title, no
//     close button (used for persistent/inline alerts, e.g. a fetch-failed
//     banner with a Retry action).
//   - AppAlertShape.toast  — compact, colored title, has a close (X) button
//     (used for ephemeral notifications — this is what Snack.show() renders
//     inside a SnackBar).
// Both shapes share the same icon system (AppAlertIcon), color tokens
// (AppColors.alert*), 8px radius, 1px accent border, and optional
// "Learn more" link — all sampled from Alert.svg.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

enum AppAlertShape { banner, toast }

class AppAlertBanner extends StatelessWidget {
  const AppAlertBanner({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.shape = AppAlertShape.banner,
    this.learnMoreText,
    this.onLearnMore,
    this.onDismiss,
    this.trailing,
  });

  final AppAlertType type;
  final String title;
  final String message;
  final AppAlertShape shape;
  final String? learnMoreText;
  final VoidCallback? onLearnMore;
  final VoidCallback? onDismiss;

  /// Optional custom action row below the message (e.g. a Retry button on
  /// the fetch-failed banner). Not part of Alert.svg but kept as an
  /// explicit slot so existing call sites with an action don't lose it.
  final Widget? trailing;

  bool get _isToast => shape == AppAlertShape.toast;

  @override
  Widget build(BuildContext context) {
    final palette = AppAlertIcon.paletteFor(type);
    final titleColor = _isToast ? palette.accent : AppColors.alertTitleNeutral;

    final card = Semantics(
      container: true,
      liveRegion: true,
      label: '$title. $message',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: palette.accent),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(palette.icon, color: palette.accent, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          title,
                          style: AppTextStyle.bodyMedium,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      if (_isToast && onDismiss != null)
                        _CloseButton(onTap: onDismiss!),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    message,
                    style: AppTextStyle.bodySmall,
                    color: AppColors.alertBodyText,
                    height: 1.4,
                  ),
                  if (learnMoreText != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: onLearnMore,
                      child: AppText(
                        learnMoreText!,
                        style: AppTextStyle.bodySmall,
                        color: palette.link,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                  if (trailing != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    trailing!,
                  ],
                ],
              ),
            ),
            if (!_isToast && onDismiss != null) _CloseButton(onTap: onDismiss!),
          ],
        ),
      ),
    );

    if (!_isToast) return card;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: card,
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Dismiss',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.close, size: 18, color: AppColors.alertBodyText),
          ),
        ),
      ),
    );
  }
}
