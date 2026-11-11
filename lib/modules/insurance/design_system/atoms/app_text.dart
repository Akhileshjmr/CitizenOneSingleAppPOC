import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/typography.dart';

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
  microLabel,
  displaySmall,
  metricLarge,
  heroValue,
}

enum AppTextVariant {
  headline,
  displayLarge,
  subtitle,
  title,
  body,
  bodyStrong,
  caption,
  label,
  error,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final AppTextVariant? variant;
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
  final bool? softWrap;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.bodyLarge,
    this.variant,
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
    this.softWrap,
  });

  const AppText.displayLarge(
    this.text, {
    super.key,
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
    this.softWrap,
  })  : style = AppTextStyle.headlineLarge,
        variant = AppTextVariant.displayLarge;

  const AppText.title(
    this.text, {
    super.key,
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
    this.softWrap,
  })  : style = AppTextStyle.headlineSmall,
        variant = AppTextVariant.title;

  const AppText.caption(
    this.text, {
    super.key,
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
    this.softWrap,
  })  : style = AppTextStyle.caption,
        variant = AppTextVariant.caption;

  const AppText.label(
    this.text, {
    super.key,
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
    this.softWrap,
  })  : style = AppTextStyle.labelSmall,
        variant = AppTextVariant.label;

  const AppText.error(
    this.text, {
    super.key,
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
    this.softWrap,
  })  : style = AppTextStyle.bodySmall,
        variant = AppTextVariant.error;

  const AppText.body(
    this.text, {
    super.key,
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
    this.softWrap,
  })  : style = AppTextStyle.bodyLarge,
        variant = AppTextVariant.body;

  @override
  Widget build(BuildContext context) {
    TextStyle base;
    switch (_effectiveStyle) {
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
      case AppTextStyle.microLabel:
        base = AppTypography.label(context);
      case AppTextStyle.displaySmall:
        base = AppTypography.displaySmall(context);
      case AppTextStyle.metricLarge:
        base = AppTypography.metricLarge(context);
      case AppTextStyle.heroValue:
        base = AppTypography.heroValue(context);
    }

    final effectiveColor = color ?? context.appTokens.textPrimary;
    final needsOverride = color != null ||
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
      softWrap: softWrap,
    );
  }

  AppTextStyle get _effectiveStyle {
    return switch (variant) {
      AppTextVariant.headline => AppTextStyle.headlineMedium,
      AppTextVariant.displayLarge => AppTextStyle.headlineLarge,
      AppTextVariant.subtitle => AppTextStyle.bodyMedium,
      AppTextVariant.title => AppTextStyle.headlineSmall,
      AppTextVariant.body => AppTextStyle.bodyLarge,
      AppTextVariant.bodyStrong => AppTextStyle.bodyMedium,
      AppTextVariant.caption => AppTextStyle.caption,
      AppTextVariant.label => AppTextStyle.labelSmall,
      AppTextVariant.error => AppTextStyle.bodySmall,
      null => style,
    };
  }
}
