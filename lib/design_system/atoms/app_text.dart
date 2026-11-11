import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

enum AppTextStyle {
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleSmall,
  titleSmallBold,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
  labelSmall,
  displaySmall,
  metricLarge,
  heroValue,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.bodyLarge,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.height,
    this.fontStyle,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle base;
    switch (style) {
      case AppTextStyle.headlineLarge:
        base = AppTypography.headlineLarge(context);
      case AppTextStyle.headlineMedium:
        base = AppTypography.headlineMedium(context);
      case AppTextStyle.headlineSmall:
        base = AppTypography.headlineSmall(context);
      case AppTextStyle.titleSmall:
        base = AppTypography.titleSmall(context);
      case AppTextStyle.titleSmallBold:
        base = AppTypography.titleSmallBold(context);
      case AppTextStyle.bodyLarge:
        base = AppTypography.bodyLarge(context);
      case AppTextStyle.bodyMedium:
        base = AppTypography.bodyMedium(context);
      case AppTextStyle.bodySmall:
        base = AppTypography.bodySmall(context);
      case AppTextStyle.caption:
        base = AppTypography.caption(context);
      case AppTextStyle.labelSmall:
        base = AppTypography.labelSmall(context);
      case AppTextStyle.displaySmall:
        base = AppTypography.displaySmall(context);
      case AppTextStyle.metricLarge:
        base = AppTypography.metricLarge(context);
      case AppTextStyle.heroValue:
        base = AppTypography.heroValue(context);
    }

    final effectiveColor = color ?? context.appTokens.textPrimary;
    final needsOverride =
        color != null ||
        fontWeight != null ||
        fontSize != null ||
        letterSpacing != null ||
        height != null ||
        fontStyle != null ||
        decoration != null;

    final resolved = needsOverride
        ? base.copyWith(
            color: effectiveColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            height: height,
            fontStyle: fontStyle,
            decoration: decoration,
          )
        : base;

    return Text(
      text,
      style: resolved,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
