import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ResponsiveDrawerUtil {
  static bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800;
  }

  static bool isDesktop() {
    return defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  static void handleDrawerLogic({
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required bool drawerOpened,
    required void Function(bool) updateDrawerState,
  }) {
    final wide = isWideScreen(context);
    final desktop = isDesktop();

    if ((wide || (!kIsWeb && desktop)) && !drawerOpened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          scaffoldKey.currentState?.openDrawer();
          updateDrawerState(true);
        } catch (e) {
          if (kDebugMode) debugPrint("Error opening drawer: $e");
        }
      });
    } else if (!wide && drawerOpened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          scaffoldKey.currentState?.closeDrawer();
          updateDrawerState(false);
        } catch (e) {
          if (kDebugMode) debugPrint("Error closing drawer: $e");
        }
      });
    }
  }
}
