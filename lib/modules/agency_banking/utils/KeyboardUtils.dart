import 'package:flutter/material.dart';

class KeyboardUtils {

  /// Globally hides the system keyboard no matter what screen is currently active

  /// and without needing a BuildContext.

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

