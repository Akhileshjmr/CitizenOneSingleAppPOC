// =============================================================================
// AppNavigation — shared "exit the module back to the parent app" flow.
// -----------------------------------------------------------------------------
// Mirrors the fallback branch already used by the PopScope handler in
// app.dart: when this module has nothing left of its own to pop, control is
// handed back to whichever Navigator hosts this module (the parent app's
// Navigator, reached via rootNavigator: true), or, if there is none, the
// app is closed outright. Both the hardware/browser back button and explicit
// in-app "exit" actions (e.g. Partner Selection) go through this one path so
// the behaviour never drifts between call sites.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNavigation {
  AppNavigation._();

  static void exitToParent(BuildContext context, [Object? result]) {
    final parentNavigator = Navigator.of(context, rootNavigator: true);
    if (parentNavigator.canPop()) {
      parentNavigator.pop(result);
    } else {
      SystemNavigator.pop(animated: true);
    }
  }
}
