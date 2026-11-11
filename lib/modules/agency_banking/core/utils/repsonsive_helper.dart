import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  Responsive._();

  static const double _mobileBreak = 600;
  static const double _tabletBreak = 1024;

  static double _width(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static bool isMobile(BuildContext context) =>
      _width(context) < _mobileBreak;

  static bool isTablet(BuildContext context) =>
      _width(context) >= _mobileBreak && _width(context) < _tabletBreak;

  static bool isWeb(BuildContext context) =>
      _width(context) >= _tabletBreak;

  /// Returns a value based on current screen size.
  /// Falls back to smaller breakpoint if not provided.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? web,
  }) {
    if (isWeb(context)) return web ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  static double fontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? web,
  }) =>
      value(context, mobile: mobile, tablet: tablet, web: web).sp;

  static double contentMaxWidth(BuildContext context) =>
      value(context, mobile: double.infinity, tablet: 520, web: 600);

  static double horizontalPadding(BuildContext context) =>
      value<double>(context, mobile: 16, tablet: 20, web: 24).w;
}