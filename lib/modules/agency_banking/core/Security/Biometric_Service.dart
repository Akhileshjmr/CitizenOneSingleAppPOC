import 'package:flutter/services.dart';

class BiometricService {
  static const MethodChannel _channel = MethodChannel("secure_bio");

  static Future<void> generateKey() async {
    await _channel.invokeMethod("generateKey");
  }

  static Future<String?> authenticateAndSign(String data) async {
    return await _channel.invokeMethod(
      "authenticateAndSign",
      {"data": data},
    );
  }

  static Future<bool> isFridaPresent() async {
    try {
      return await _channel.invokeMethod("isFridaPresent") ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> wipeAll() async {
    await _channel.invokeMethod("wipeCompletely");
  }
}