// =============================================================================
// Responsive  —  Breakpoint helpers
// -----------------------------------------------------------------------------
// We do not rely on a third-party responsive package. A handful of constants
// + a tiny extension is enough for an enterprise banking app.
// =============================================================================

import 'package:flutter/widgets.dart';

class Breakpoints {
  Breakpoints._();
  static const double phone = 600;
  static const double tablet = 905;
  static const double desktop = 1240;
}

enum DeviceClass { phone, tablet, desktop }

extension ResponsiveContext on BuildContext {
  DeviceClass get deviceClass {
    final w = MediaQuery.sizeOf(this).width;
    if (w >= Breakpoints.desktop) return DeviceClass.desktop;
    if (w >= Breakpoints.tablet) return DeviceClass.tablet;
    return DeviceClass.phone;
  }

  bool get isPhone => deviceClass == DeviceClass.phone;
  bool get isTablet => deviceClass == DeviceClass.tablet;
  bool get isDesktop => deviceClass == DeviceClass.desktop;

  /// Choose a value for the current device class.
  T responsive<T>({required T phone, T? tablet, T? desktop}) {
    switch (deviceClass) {
      case DeviceClass.desktop:
        return desktop ?? tablet ?? phone;
      case DeviceClass.tablet:
        return tablet ?? phone;
      case DeviceClass.phone:
        return phone;
    }
  }
}
