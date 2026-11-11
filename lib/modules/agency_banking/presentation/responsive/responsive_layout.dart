import 'package:flutter/material.dart';

/// ResponsiveLayout
/// ----------------
/// - mobileLayout          → phones in PORTRAIT, width < 600
/// - tabletWebLayout       → width >= 600 (tablets, web, desktop) OR any
///                           landscape phone that doesn't have a
///                           dedicated [mobileLandscapeLayout]
/// - mobileLandscapeLayout → OPTIONAL. Phones in LANDSCAPE, width < 600.
///                           Supply this if [mobileLayout]'s design
///                           (built for a tall, narrow portrait screen)
///                           wouldn't fit well in a short, wide one.
///                           If omitted, landscape phones fall back to
///                           [tabletWebLayout] instead — a centered,
///                           scrollable "web" layout generally degrades
///                           more gracefully at odd short/wide sizes
///                           than a portrait-only mobile design does.
///
/// This works based on screen WIDTH + ORIENTATION (best practice), NOT
/// platform (kIsWeb is avoided intentionally) — so a resized desktop
/// Chrome window, a folded tablet, or a rotated phone all get the right
/// layout instead of being locked to "web" just because kIsWeb.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget tabletWebLayout;
  final Widget? mobileLandscapeLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletWebLayout,
    this.mobileLandscapeLayout,
  });

  static const double breakpoint = 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;

        // ✅ Tablet / Web / Desktop — width alone decides this,
        // regardless of orientation.
        if (screenWidth >= breakpoint) {
          return tabletWebLayout;
        }

        // Below this point: screenWidth < breakpoint, so we're
        // definitely on a phone-sized viewport. Orientation decides
        // which of the two remaining layouts to use.
        final Orientation orientation = MediaQuery.of(context).orientation;

        if (orientation == Orientation.landscape) {
          // ✅ Landscape phone, still under the width breakpoint (e.g.
          // a compact phone like an iPhone SE, ~568-667px landscape).
          return mobileLandscapeLayout ?? tabletWebLayout;
        }

        // ✅ Portrait phone — the common case.
        return mobileLayout;
      },
    );
  }
}

