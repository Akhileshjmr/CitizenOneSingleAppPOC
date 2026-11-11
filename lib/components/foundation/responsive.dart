import 'package:flutter/widgets.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';

export 'package:citizenone_app/core/adaptive/adaptive_layout.dart'
    show AdaptiveContextX, AdaptiveLayout;
export 'package:citizenone_app/core/adaptive/breakpoints.dart'
    show AppBreakpoints;

class ResponsiveLayout extends AdaptiveLayout {
  const ResponsiveLayout({
    super.key,
    required super.mobile,
    super.tablet,
    super.desktop,
  });

  static bool isMobile(BuildContext context) => AdaptiveLayout.isMobile(context);

  static bool isTablet(BuildContext context) => AdaptiveLayout.isTablet(context);

  static bool isDesktop(BuildContext context) => AdaptiveLayout.isDesktop(context);
}
