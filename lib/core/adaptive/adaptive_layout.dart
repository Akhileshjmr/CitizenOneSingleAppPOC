import 'package:flutter/material.dart';
import 'package:citizenone_app/core/adaptive/breakpoints.dart';

enum AdaptiveSize { mobile, tablet, desktop }

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static AdaptiveSize sizeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.desktop) return AdaptiveSize.desktop;
    if (width >= AppBreakpoints.mobile) return AdaptiveSize.tablet;
    return AdaptiveSize.mobile;
  }

  static bool isMobile(BuildContext context) => sizeOf(context) == AdaptiveSize.mobile;

  static bool isTablet(BuildContext context) => sizeOf(context) == AdaptiveSize.tablet;

  static bool isDesktop(BuildContext context) => sizeOf(context) == AdaptiveSize.desktop;

  static double horizontalPadding(BuildContext context) {
    switch (sizeOf(context)) {
      case AdaptiveSize.mobile:
        return 16;
      case AdaptiveSize.tablet:
        return 24;
      case AdaptiveSize.desktop:
        return 32;
    }
  }

  static double contentMaxWidth(BuildContext context) {
    switch (sizeOf(context)) {
      case AdaptiveSize.mobile:
        return double.infinity;
      case AdaptiveSize.tablet:
        return 960;
      case AdaptiveSize.desktop:
        return AppBreakpoints.maxContentWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= AppBreakpoints.mobile) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

extension AdaptiveContextX on BuildContext {
  AdaptiveSize get adaptiveSize => AdaptiveLayout.sizeOf(this);

  bool get isMobile => AdaptiveLayout.isMobile(this);

  bool get isTablet => AdaptiveLayout.isTablet(this);

  bool get isDesktop => AdaptiveLayout.isDesktop(this);

  double get adaptiveHorizontalPadding => AdaptiveLayout.horizontalPadding(this);

  double get adaptiveContentMaxWidth => AdaptiveLayout.contentMaxWidth(this);
}
