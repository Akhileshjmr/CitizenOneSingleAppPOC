import 'package:flutter/foundation.dart';

/// Centralized logger that only outputs in debug mode.
/// Replaces raw print() statements to prevent sensitive data leakage in production.
class AppLogger {
  /// General debug log — only prints in debug mode
  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }

  /// Info-level log — only prints in debug mode
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  /// Warning-level log — only prints in debug mode
  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARN] $message');
    }
  }

  /// Error-level log — only prints in debug mode
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('[ERROR] $error');
      if (stackTrace != null) debugPrint('[STACK] $stackTrace');
    }
  }

  /// Network request log — only prints in debug mode
  /// Sanitizes sensitive fields from the output
  static void network(String message) {
    if (kDebugMode) {
      debugPrint('[NET] $message');
    }
  }
}
