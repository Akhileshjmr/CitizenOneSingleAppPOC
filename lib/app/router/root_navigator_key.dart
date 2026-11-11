import 'package:flutter/widgets.dart';

/// The app's single root [Navigator]. Lets global UI (the Session
/// Expiring Soon / Session Expired sheets) show itself regardless of
/// the current route — including from inside a module (e.g. Insurance)
/// pushed on top of this same Navigator — without needing a
/// [BuildContext] from the current screen.
final rootNavigatorKey = GlobalKey<NavigatorState>();
