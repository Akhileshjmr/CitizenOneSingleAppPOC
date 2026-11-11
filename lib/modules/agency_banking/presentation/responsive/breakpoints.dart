/// Shared width breakpoints used to branch layouts between mobile, tablet
/// and desktop/web. Mirrors the ranges already used ad-hoc across the app
/// (e.g. ChangePasswordScreen's `width < 600` check) so new responsive code
/// stays consistent with it.
class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isMobile(double width) => width < tablet;

  static bool isTablet(double width) => width >= tablet && width < desktop;

  static bool isDesktop(double width) => width >= desktop;
}
