import 'package:flutter/material.dart';
import '../spacing/app_spacing.dart';

/// Predefined Container Types matching UX4G LayoutGrid.png guidelines
enum AppContainerSize {
  /// Desktop - Container 1320px
  desktop1320,

  /// Desktop - Container 1140px
  desktop1140,

  /// Tablet - Container 960px
  tablet960,

  /// Tablet - Container 720px
  tablet720,

  /// Mobile - Container 540px
  mobile540,

  /// Full width / fluid layout
  fluid,
}

/// Device display breakpoint categories
enum AppDisplayBreakpoint {
  mobile,
  tablet,
  desktop,
}

/// Utility for responsive layout grid calculations & container sizing.
class AppLayoutGrid {
  AppLayoutGrid._();

  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;

  /// Resolves current display breakpoint based on BuildContext
  static AppDisplayBreakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return AppDisplayBreakpoint.mobile;
    } else if (width < tabletBreakpoint) {
      return AppDisplayBreakpoint.tablet;
    } else {
      return AppDisplayBreakpoint.desktop;
    }
  }

  /// Resolves pixel width for [AppContainerSize]
  static double getContainerWidth(AppContainerSize size) {
    switch (size) {
      case AppContainerSize.desktop1320:
        return AppSpacing.containerDesktop1320;
      case AppContainerSize.desktop1140:
        return AppSpacing.containerDesktop1140;
      case AppContainerSize.tablet960:
        return AppSpacing.containerTablet960;
      case AppContainerSize.tablet720:
        return AppSpacing.containerTablet720;
      case AppContainerSize.mobile540:
        return AppSpacing.containerMobile540;
      case AppContainerSize.fluid:
        return double.infinity;
    }
  }
}

/// Responsive Container widget enforcing max-width constraints from UX4G LayoutGrid.png.
class AppLayoutContainer extends StatelessWidget {
  final Widget child;
  final AppContainerSize containerSize;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const AppLayoutContainer({
    super.key,
    required this.child,
    this.containerSize = AppContainerSize.desktop1140,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  /// Factory for Mobile 540px container
  const factory AppLayoutContainer.mobile540({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment,
  }) = _AppMobile540Container;

  /// Factory for Tablet 720px container
  const factory AppLayoutContainer.tablet720({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment,
  }) = _AppTablet720Container;

  /// Factory for Tablet 960px container
  const factory AppLayoutContainer.tablet960({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment,
  }) = _AppTablet960Container;

  /// Factory for Desktop 1140px container
  const factory AppLayoutContainer.desktop1140({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment,
  }) = _AppDesktop1140Container;

  /// Factory for Desktop 1320px container
  const factory AppLayoutContainer.desktop1320({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment,
  }) = _AppDesktop1320Container;

  /// Factory for Fluid (Full-width) container
  const factory AppLayoutContainer.fluid({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment,
  }) = _AppFluidContainer;

  @override
  Widget build(BuildContext context) {
    final maxWidth = AppLayoutGrid.getContainerWidth(containerSize);

    return Align(
      alignment: alignment,
      child: Container(
        constraints: maxWidth == double.infinity
            ? null
            : BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

class _AppMobile540Container extends AppLayoutContainer {
  const _AppMobile540Container({
    super.key,
    required super.child,
    super.padding,
    super.alignment,
  }) : super(containerSize: AppContainerSize.mobile540);
}

class _AppTablet720Container extends AppLayoutContainer {
  const _AppTablet720Container({
    super.key,
    required super.child,
    super.padding,
    super.alignment,
  }) : super(containerSize: AppContainerSize.tablet720);
}

class _AppTablet960Container extends AppLayoutContainer {
  const _AppTablet960Container({
    super.key,
    required super.child,
    super.padding,
    super.alignment,
  }) : super(containerSize: AppContainerSize.tablet960);
}

class _AppDesktop1140Container extends AppLayoutContainer {
  const _AppDesktop1140Container({
    super.key,
    required super.child,
    super.padding,
    super.alignment,
  }) : super(containerSize: AppContainerSize.desktop1140);
}

class _AppDesktop1320Container extends AppLayoutContainer {
  const _AppDesktop1320Container({
    super.key,
    required super.child,
    super.padding,
    super.alignment,
  }) : super(containerSize: AppContainerSize.desktop1320);
}

class _AppFluidContainer extends AppLayoutContainer {
  const _AppFluidContainer({
    super.key,
    required super.child,
    super.padding,
    super.alignment,
  }) : super(containerSize: AppContainerSize.fluid);
}

/// Widget building different layouts based on active screen breakpoint.
class AppResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AppResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = AppLayoutGrid.getBreakpoint(context);
    switch (breakpoint) {
      case AppDisplayBreakpoint.desktop:
        return desktop ?? tablet ?? mobile;
      case AppDisplayBreakpoint.tablet:
        return tablet ?? mobile;
      case AppDisplayBreakpoint.mobile:
        return mobile;
    }
  }
}
