import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('[INFO] ${tag != null ? "[$tag] " : ""}$message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }
}
