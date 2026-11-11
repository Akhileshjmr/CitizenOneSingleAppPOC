// =============================================================================
// ThemeExtensions  —  Custom design system tokens carried on ThemeData
// -----------------------------------------------------------------------------
// Material's ThemeData carries colors/typography for its own widgets, but
// our design system needs more — semantic colors, brand palette pointer,
// and any future tokens (motion, shadows, density). We surface those via
// strongly-typed ThemeExtensions so any widget can do:
//
//     context.colors.success
//     context.text.title
//     context.brand.primary
//
// (See `core/extensions/build_context_x.dart` for those getters.)
// =============================================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Carries the active [BrandPalette] across the widget tree.
///
/// We wrap the palette in a ThemeExtension (rather than handing the palette
/// out via DI) so widgets can react to runtime theme changes (light/dark
/// switches, white-label swaps) through the standard MaterialApp.theme API.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({required this.palette});

  final BrandPalette palette;

  @override
  AppColorsExtension copyWith({BrandPalette? palette}) =>
      AppColorsExtension(palette: palette ?? this.palette);

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    // Palettes are discrete brand identities — interpolating between them
    // produces nonsense ("muddy purple" between blue and pink). We snap
    // instead, which matches user expectations during a brand swap.
    if (other is! AppColorsExtension) return this;
    return t < 0.5 ? this : other;
  }
} 

/// Layout tokens — radii, elevations, max content width — exposed as a
/// ThemeExtension so a "compact" or "TV" variant could override them.
@immutable
class AppLayoutExtension extends ThemeExtension<AppLayoutExtension> {
  const AppLayoutExtension({
    this.radiusSm = 8,
    this.radiusMd = 12,
    this.radiusLg = 16,
    this.cardElevation = 0,
    this.maxContentWidth = 720,
  });

  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double cardElevation;
  final double maxContentWidth;

  @override
  AppLayoutExtension copyWith({
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? cardElevation,
    double? maxContentWidth,
  }) =>
      AppLayoutExtension(
        radiusSm: radiusSm ?? this.radiusSm,
        radiusMd: radiusMd ?? this.radiusMd,
        radiusLg: radiusLg ?? this.radiusLg,
        cardElevation: cardElevation ?? this.cardElevation,
        maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      );

  @override
  AppLayoutExtension lerp(ThemeExtension<AppLayoutExtension>? other, double t) {
    if (other is! AppLayoutExtension) return this;
    return AppLayoutExtension(
      radiusSm: radiusSm + (other.radiusSm - radiusSm) * t,
      radiusMd: radiusMd + (other.radiusMd - radiusMd) * t,
      radiusLg: radiusLg + (other.radiusLg - radiusLg) * t,
      cardElevation: cardElevation + (other.cardElevation - cardElevation) * t,
      maxContentWidth:
          maxContentWidth + (other.maxContentWidth - maxContentWidth) * t,
    );
  }
}
