// =============================================================================
// AppSpacing  —  Centralized spacing scale (8pt grid)
// -----------------------------------------------------------------------------
// Magic numbers (Padding(EdgeInsets.all(12))) are forbidden in widgets.
// Every gap, padding, margin and SizedBox uses one of these tokens.
//
// Why a class with `static const` rather than top-level constants?
//   * Discoverability — `AppSpacing.md` autocompletes everywhere.
//   * Scoping — does not pollute the global namespace.
//   * Future-proof — we can swap to a runtime ThemeExtension if a brand
//     ever ships a denser variant ("compact mode").
// =============================================================================

import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  // ---------- Raw scale (4pt base, doubling) -----------------------------
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // ---------- Radii ------------------------------------------------------
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  // ---------- Convenience EdgeInsets ------------------------------------
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets pageHorizontal =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets pageVertical = EdgeInsets.symmetric(vertical: lg);

  // ---------- Elevation tokens ------------------------------------------
  static const double elevationNone = 0;
  static const double elevationSm = 1;
  static const double elevationMd = 3;
  static const double elevationLg = 6;
}
