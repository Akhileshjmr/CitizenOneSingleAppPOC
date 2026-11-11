/*
import 'package:flutter/material.dart';

class UICleanupHelper {
  /// Close dialogs, bottom sheets, loaders & keyboard
  static void cleanUI(BuildContext context) {
    // Close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Close any popup except the main screen
    Future.microtask(() {
      Navigator.of(context, rootNavigator: true)
          .popUntil((route) => route.isFirst);
    });
  }

  /// Clean keyboard when app is resumed
  static void onAppResume() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

abstract class State<T extends StatefulWidget>
    extends State<T> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// Clean all dialogs, sheets, keyboard when screen opens
    Future.delayed(Duration.zero, () {
      UICleanupHelper.cleanUI(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Clean keyboard when app resumes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      UICleanupHelper.onAppResume();
    }
  }
}

*/
