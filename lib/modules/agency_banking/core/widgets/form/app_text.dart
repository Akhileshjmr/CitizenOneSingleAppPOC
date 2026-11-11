import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final bool isVisible;
  /// NEW: base style to build on top of — e.g. `AppThemeStyle.pageTitle`,
  /// `AppThemeStyle.pageSubtitle`, or any other TextStyle from your
  /// theme. Any of [color]/[fontSize]/[fontWeight]/[fontFamily] passed
  /// alongside [style] wins over the matching field inside it — so you
  /// can do `AppText('Title', style: AppThemeStyle.pageTitle)` for the
  /// style as-is, or `AppText('Title', style: AppThemeStyle.pageTitle,
  /// color: Colors.red)` to reuse the style but tweak just the color.
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? lineHeight;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool underline;
  final double underlineHeight;
  final Color? underlineColor;
  final String? underlineText;
  final Map<String, TextStyle>? highlightParts;
  final String? fontFamily;

  // ------------------------------------------------------
  // Hard fallback defaults — only used when NEITHER `style` NOR the
  // matching individual param (fontSize/fontWeight/...) is provided.
  // ------------------------------------------------------
  static const double _defaultFontSize = 14;
  static const FontWeight _defaultFontWeight = FontWeight.w400;
  static const double _defaultLineHeight = 1.3;

  /// DEFAULT font is Roboto
  static const String _defaultFontFamily = 'Roboto';

  const AppText(
      this.text, {
        super.key,
        this.isVisible = true,
        this.style,
        this.color,
        this.fontSize,
        this.fontWeight,
        this.textAlign = TextAlign.start,
        this.maxLines,
        this.overflow,
        this.lineHeight,
        this.padding,
        this.spacing,
        this.underline = false,
        this.underlineHeight = 1.2,
        this.underlineColor,
        this.underlineText,
        this.highlightParts,
        this.fontFamily,
      });

  // ------------------------------------------------------
  // RESPONSIVE HELPERS
  // Each now takes the already-resolved base value (after the
  // style → individual-param merge) rather than reading `this.fontSize`
  // / `this.lineHeight` directly, since those fields are optional now.
  // ------------------------------------------------------
  double _responsiveFontSize(BuildContext context, double baseFontSize) {
    double width = MediaQuery.of(context).size.width;

    if (width < 400) return baseFontSize;
    if (width < 600) return baseFontSize + 1;
    if (width < 900) return baseFontSize + 2;
    if (width < 1200) return baseFontSize + 3;
    return baseFontSize + 4;
  }

  double _responsiveLineHeight(BuildContext context, double baseLineHeight) {
    double width = MediaQuery.of(context).size.width;

    if (width < 400) return baseLineHeight;
    if (width < 600) return baseLineHeight + 0.05;
    if (width < 900) return baseLineHeight + 0.1;
    if (width < 1200) return baseLineHeight + 0.15;
    return baseLineHeight + 0.2;
  }

  double _responsiveSpacing(BuildContext context) {
    if (spacing != null) return spacing!;

    double width = MediaQuery.of(context).size.width;

    if (width < 400) return 6.0;
    if (width < 600) return 8.0;
    if (width < 900) return 10.0;
    if (width < 1200) return 12.0;
    return 14.0;
  }

  EdgeInsets _responsivePadding(BuildContext context) {
    if (padding != null) return padding as EdgeInsets;

    double width = MediaQuery.of(context).size.width;

    if (width < 400) return const EdgeInsets.only(bottom: 4);
    if (width < 600) return const EdgeInsets.only(bottom: 6);
    if (width < 900) return const EdgeInsets.only(bottom: 8);
    if (width < 1200) return const EdgeInsets.only(bottom: 10);
    return const EdgeInsets.only(bottom: 12);
  }

  // ------------------------------------------------------

  /// Merge order (later wins): hard defaults → [style] → explicit
  /// per-call params (color/fontSize/fontWeight/fontFamily/lineHeight).
  TextStyle _baseTextStyle(Color resolvedColor, BuildContext context) {
    final double baseFontSize =
        fontSize ?? style?.fontSize ?? _defaultFontSize;
    final FontWeight baseFontWeight =
        fontWeight ?? style?.fontWeight ?? _defaultFontWeight;
    final double baseLineHeight =
        lineHeight ?? style?.height ?? _defaultLineHeight;
    final String baseFontFamily =
        fontFamily ?? style?.fontFamily ?? _defaultFontFamily;

    return TextStyle(
      color: resolvedColor,
      fontSize: _responsiveFontSize(context, baseFontSize),
      fontFamily: baseFontFamily,
      fontWeight: baseFontWeight,
      height: _responsiveLineHeight(context, baseLineHeight),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    // Resolution order: explicit `color` param > `style`'s color >
    // theme default.
    final resolvedColor =
        color ?? style?.color ?? AppColors.textPrimaryTextColor;

    return Padding(
      padding: _responsivePadding(context),
      child: Align(
        alignment: textAlign == TextAlign.center
            ? Alignment.center
            : textAlign == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _buildContent(resolvedColor, context),
      ),
    );
  }

  Widget _buildContent(Color resolvedColor, BuildContext context) {
    final effectiveMaxLines = maxLines ?? 99999;
    final effectiveOverflow = overflow ?? TextOverflow.visible;

    // 1) MULTI HIGHLIGHT
    if (highlightParts != null && highlightParts!.isNotEmpty) {
      return RichText(
        textAlign: textAlign,
        softWrap: true,
        textWidthBasis: TextWidthBasis.parent,
        maxLines: effectiveMaxLines,
        overflow: effectiveOverflow,
        text: _buildSpanWithHighlights(resolvedColor, context),
      );
    }

    // 2) PARTIAL UNDERLINE
    if (underlineText != null && underlineText!.isNotEmpty) {
      final idx = text.indexOf(underlineText!);

      if (idx == -1) {
        return Text(
          text,
          textAlign: textAlign,
          maxLines: effectiveMaxLines,
          overflow: effectiveOverflow,
          softWrap: true,
          style: _baseTextStyle(resolvedColor, context),
        );
      }

      return RichText(
        textAlign: textAlign,
        softWrap: true,
        textWidthBasis: TextWidthBasis.parent,
        maxLines: effectiveMaxLines,
        overflow: effectiveOverflow,
        text: TextSpan(children: [
          TextSpan(
            text: text.substring(0, idx),
            style: _baseTextStyle(resolvedColor, context),
          ),
          TextSpan(
            text: underlineText!,
            style: _baseTextStyle(underlineColor ?? resolvedColor, context)
                .copyWith(
              decoration: TextDecoration.underline,
              decorationThickness: underlineHeight,
              decorationColor: underlineColor ?? resolvedColor,
            ),
          ),
          TextSpan(
            text: text.substring(idx + underlineText!.length),
            style: _baseTextStyle(resolvedColor, context),
          ),
        ]),
      );
    }

    // 3) FULL UNDERLINE
    if (underline) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: effectiveMaxLines,
        overflow: effectiveOverflow,
        softWrap: true,
        style: _baseTextStyle(resolvedColor, context).copyWith(
          decoration: TextDecoration.underline,
          decorationThickness: underlineHeight,
          decorationColor: underlineColor ?? resolvedColor,
        ),
      );
    }

    // 4) DEFAULT TEXT
    return Text(
      text,
      textAlign: textAlign,
      maxLines: effectiveMaxLines,
      overflow: effectiveOverflow,
      softWrap: true,
      style: _baseTextStyle(resolvedColor, context),
    );
  }

  TextSpan _buildSpanWithHighlights(Color resolvedColor, BuildContext context) {
    final baseStyle = _baseTextStyle(resolvedColor, context);
    final String textData = text;

    List<TextSpan> spans = [];
    int cursor = 0;

    final keys = highlightParts!.keys.toList();

    while (cursor < textData.length) {
      int nextIndex = textData.length;
      String? nextKey;

      for (final key in keys) {
        if (key.isEmpty) continue;

        final idx = textData.indexOf(key, cursor);

        if (idx >= 0 && idx < nextIndex) {
          nextIndex = idx;
          nextKey = key;
        }
      }

      if (nextKey == null) {
        spans.add(TextSpan(text: textData.substring(cursor), style: baseStyle));
        break;
      }

      if (nextIndex > cursor) {
        spans.add(TextSpan(
          text: textData.substring(cursor, nextIndex),
          style: baseStyle,
        ));
      }

      final provided = highlightParts![nextKey]!;
      final mergedStyle = baseStyle.merge(
        provided.copyWith(
          fontFamily: provided.fontFamily ?? fontFamily,
        ),
      );

      spans.add(TextSpan(text: nextKey, style: mergedStyle));
      cursor = nextIndex + nextKey.length;
    }

    return TextSpan(children: spans);
  }
}

