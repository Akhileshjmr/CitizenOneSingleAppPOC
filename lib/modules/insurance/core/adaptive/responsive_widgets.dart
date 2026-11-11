// =============================================================================
// Responsive widgets — additive helpers built on top of the existing
// AdaptiveLayout / AppBreakpoints system (core/adaptive/adaptive_layout.dart,
// core/adaptive/breakpoints.dart). These do NOT introduce a new breakpoint
// scale — they are thin, reusable wrappers so screens stop hand-rolling
// LayoutBuilder/ConstrainedBox boilerplate.
// =============================================================================

import 'package:flutter/widgets.dart';
import 'adaptive_layout.dart';
import 'breakpoints.dart';

/// Rebuilds [builder] whenever the current [AdaptiveSize] tier changes.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, size) => size == AdaptiveSize.mobile
///       ? const _MobileBody()
///       : const _DesktopBody(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, AdaptiveSize size) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final AdaptiveSize size;
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          size = AdaptiveSize.desktop;
        } else if (constraints.maxWidth >= AppBreakpoints.mobile) {
          size = AdaptiveSize.tablet;
        } else {
          size = AdaptiveSize.mobile;
        }
        return builder(context, size);
      },
    );
  }
}

/// Centers [child] and clamps it to [AdaptiveLayout.contentMaxWidth], with
/// horizontal padding scaled per breakpoint via [AdaptiveLayout.horizontalPadding].
///
/// Example:
/// ```dart
/// ResponsiveContainer(
///   maxWidth: 1200, // optional override of the breakpoint default
///   child: const _PageBody(),
/// )
/// ```
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padHorizontal = true,
  });

  final Widget child;
  final double? maxWidth;
  final bool padHorizontal;

  @override
  Widget build(BuildContext context) {
    final resolvedMaxWidth = maxWidth ?? AdaptiveLayout.contentMaxWidth(context);
    final body = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
        child: child,
      ),
    );
    if (!padHorizontal) return body;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AdaptiveLayout.horizontalPadding(context),
      ),
      child: body,
    );
  }
}

/// A [Wrap]-based grid whose item width — and therefore effective column
/// count — varies per breakpoint. Avoids re-deriving `crossAxisCount` math
/// on every screen that needs a responsive card grid.
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   mobileColumns: 1,
///   tabletColumns: 2,
///   desktopColumns: 4,
///   spacing: AppSpacing.lg,
///   children: cards,
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 4,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = AdaptiveLayout.isDesktop(context)
            ? desktopColumns
            : AdaptiveLayout.isTablet(context)
                ? tabletColumns
                : mobileColumns;
        final totalSpacing = spacing * (columns - 1);
        final itemWidth = (constraints.maxWidth - totalSpacing) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

/// A "main content + right rail" layout that sits side-by-side on desktop
/// (`Row` with [mainFlex]/[railFlex]) and stacks vertically — main content
/// first, rail below — on mobile/tablet, where a 7:4 split leaves both
/// panes too narrow to read. This is the standard shape for every Buy
/// Policy step screen (form/step card + QuoteSummaryCard or
/// BestPracticesPanel).
///
/// Example:
/// ```dart
/// ResponsiveTwoPane(
///   main: _CoverageCard(),
///   rail: const BestPracticesPanel(),
/// )
/// ```
class ResponsiveTwoPane extends StatelessWidget {
  const ResponsiveTwoPane({
    super.key,
    required this.main,
    required this.rail,
    this.mainFlex = 7,
    this.railFlex = 4,
    this.spacing = 32,
  });

  final Widget main;
  final Widget rail;
  final int mainFlex;
  final int railFlex;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (AdaptiveLayout.isDesktop(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: mainFlex, child: main),
          SizedBox(width: spacing),
          Expanded(flex: railFlex, child: rail),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        main,
        SizedBox(height: spacing),
        rail,
      ],
    );
  }
}

/// Breakpoint-scaled spacing values, layered on top of [AdaptiveLayout] so
/// screens don't hardcode "bigger gap on desktop" magic numbers.
class ResponsiveSpacing {
  ResponsiveSpacing._();

  static double of(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    switch (AdaptiveLayout.sizeOf(context)) {
      case AdaptiveSize.desktop:
        return desktop ?? tablet ?? mobile;
      case AdaptiveSize.tablet:
        return tablet ?? mobile;
      case AdaptiveSize.mobile:
        return mobile;
    }
  }

  /// Gap between the main content column and a right rail on desktop layouts.
  static double railGap(BuildContext context) =>
      of(context, mobile: 16, desktop: 32);

  /// Standard page padding used by desktop content areas (inside the shell).
  static double pagePadding(BuildContext context) =>
      of(context, mobile: 16, tablet: 24, desktop: 32);
}
