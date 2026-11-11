import 'package:flutter/foundation.dart';
import 'logging_policy.dart';

class AppLogger {
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('[DEBUG] $prefix${LoggingPolicy.redactString(message)}');
    }
  }

  static void info(String message, [String? tag]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('[INFO] $prefix${LoggingPolicy.redactString(message)}');
  }

  static void warning(String message, [String? tag]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('[WARN] $prefix${LoggingPolicy.redactString(message)}');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace, String? tag]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('[ERROR] $prefix${LoggingPolicy.redactString(message)}');
    if (error != null) {
      debugPrint('Error: ${LoggingPolicy.redactString(error.toString())}');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('StackTrace: $stackTrace');
    }
  }
}
