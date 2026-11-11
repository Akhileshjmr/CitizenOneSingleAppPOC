// =============================================================================
// BuildContext extensions  —  Ergonomic theme/access helpers
// -----------------------------------------------------------------------------
// These getters are the canonical way that *every* design system component
// reaches into the theme. Widgets should NOT call `Theme.of(context).
// extension<...>()` directly — they should go through these helpers.
//
// Why? If we ever rename `AppColorsExtension` or restructure how palettes
// are exposed, only this file changes. Every atom keeps working.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;

  /// The active brand palette (light or dark variant already resolved).
  BrandPalette get brand =>
      theme.extension<AppColorsExtension>()?.palette ??
      const DefaultBrandPalette();

  /// Shortcut for `brand` — kept for readability at call sites.
  BrandPalette get colors => brand;

  /// Design system text styles — ALWAYS prefer these over `theme.textTheme`.
  AppTextTheme get text =>
      theme.extension<AppTextTheme>() ?? const AppTextTheme();

  /// Design system layout tokens (radii, max content width).
  AppLayoutExtension get layout =>
      theme.extension<AppLayoutExtension>() ?? const AppLayoutExtension();

  /// Whether dark mode is currently active.
  bool get isDark => theme.brightness == Brightness.dark;
}
