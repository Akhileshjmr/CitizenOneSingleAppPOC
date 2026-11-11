import 'dart:async';

import 'package:flutter/foundation.dart';

class SecurityConfig {
  static const bool enableJailbreakDetection = true;
  static const bool enableRootDetection = true;
  static const bool enableEmulatorDetection = true;
  static const bool enableDeveloperModeDetection = true;
  static const bool secOnn = true;
  static const bool enableMemoryDumpingDetection = true;
  static const bool enableRuntimeMonitoring = true;
  static const bool enableCertificatePinning = false;
  static const bool enableVPNDetection = true;
}

class DetectSecurity {
  String firstTimeInstallKey = "FirstTiMeInstall";

  static void startRuntimeMonitoring() {
    // Stubbed out to avoid missing dependencies
  }

  static void stopRuntimeMonitoring() {
    // Stubbed out
  }

  Future<void> initState() async {
    if (kDebugMode) {
      debugPrint("=== Security Check Bypassed ===");
    }
  }

  static void stopMonitoring() {
    stopRuntimeMonitoring();
  }

  Future<bool> androidRootChecker() async => false;
  Future<bool> developerMode() async => false;
  Future<bool> iosJailbreak() async => false;
}
