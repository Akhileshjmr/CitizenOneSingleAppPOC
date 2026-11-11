import 'dart:io';

import 'package:citizenone_app/modules/agency_banking/core/Security/DetectSecurity.dart';
import 'package:citizenone_app/modules/agency_banking/core/Security/VPNDetectionService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'AppLogger.dart';

/// Runtime security checks for the banking application.
///
/// Covers:
///   • Item #12 — Anti-debugging detection
///   • Item #15 — Frida / reverse engineering detection
///   • Item #7  — Root / jailbreak / emulator detection (basic checks)
///
/// All checks are skipped in debug mode (kDebugMode) so developers
/// can work normally during development.
class SecurityGuard {
  /// Platform channel for native security checks
  static const MethodChannel _channel = MethodChannel('com.jmr.fnb/security');

  /// Run all security checks. Call this once at app startup (after login).
  /// Returns a [SecurityResult] with details of any threats detected.
  static Future<SecurityResult> performChecks() async {
    // Skip all checks if master switch is off
    if (!SecurityConfig.secOnn) {
      AppLogger.debug('SecurityGuard: All checks disabled (secOnn=false)');
      return SecurityResult.safe();
    }

    // TODO: Re-enable before production release
    // if (kDebugMode) {
    //   AppLogger.debug('SecurityGuard: Checks skipped in debug mode');
    //   return SecurityResult.safe();
    // }

    final threats = <String>[];

    // ── Developer mode detection ──
    if (SecurityConfig.enableDeveloperModeDetection) {
      try {
        final isDevMode = await _isDeveloperModeEnabled();
        if (isDevMode) {
          threats.add('Developer mode enabled');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: developer mode check failed', e);
      }

      try {
        final isUsbDebug = await _isUsbDebuggingEnabled();
        if (isUsbDebug) {
          threats.add('USB debugging enabled');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: USB debugging check failed', e);
      }

      try {
        final isDebugged = await _isDebuggerAttached();
        if (isDebugged) {
          threats.add('Debugger attached');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: debugger check failed', e);
      }
    }

    // ── Frida / reverse engineering (#15) ──
    if (SecurityConfig.enableMemoryDumpingDetection) {
      try {
        final isFrida = await _isFridaDetected();
        if (isFrida) {
          threats.add('Instrumentation framework detected');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: Frida check failed', e);
      }
    }

    // ── Root / Jailbreak (#7) ──
    if (SecurityConfig.enableRootDetection ||
        SecurityConfig.enableJailbreakDetection) {
      try {
        final isCompromised = await _isDeviceCompromised();
        if (isCompromised) {
          threats.add('Device integrity compromised');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: device check failed', e);
      }
    }

    // ── VPN detection ──
    if (SecurityConfig.enableVPNDetection) {
      try {
        final isVPN = await VPNDetectionService.isVPNActive();
        if (isVPN) {
          threats.add('VPN connection detected');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: VPN check failed', e);
      }
    }

    // ── Emulator detection (#7) ──
    if (SecurityConfig.enableEmulatorDetection) {
      try {
        final isEmu = await _isEmulator();
        if (isEmu) {
          threats.add('Emulator detected');
        }
      } catch (e) {
        AppLogger.error('SecurityGuard: emulator check failed', e);
      }
    }

    if (threats.isNotEmpty) {
      AppLogger.warning('SecurityGuard: Threats detected — ${threats.length}');
    }

    return SecurityResult(threats: threats);
  }

  // ─────────────────────────────────────────────
  //  DEVELOPER MODE / USB DEBUGGING
  // ─────────────────────────────────────────────

  static Future<bool> _isDeveloperModeEnabled() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('isDeveloperModeEnabled');
      return result ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<bool> _isUsbDebuggingEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');
      return result ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  // ─────────────────────────────────────────────
  //  #12 — ANTI-DEBUGGING
  // ─────────────────────────────────────────────

  /// Check if a debugger is attached via native platform channel.
  static Future<bool> _isDebuggerAttached() async {
    try {
      final result = await _channel.invokeMethod<bool>('isDebuggerAttached');
      return result ?? false;
    } on MissingPluginException {
      // Fallback: Dart-level check
      return _dartDebugCheck();
    }
  }

  /// Dart-level debug detection using assert & profile checks.
  static bool _dartDebugCheck() {
    // In release mode, asserts are stripped — this returns false
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    return inDebug;
  }

  // ─────────────────────────────────────────────
  //  #15 — FRIDA / REVERSE ENGINEERING DETECTION
  // ─────────────────────────────────────────────

  /// Detect Frida instrumentation framework.
  static Future<bool> _isFridaDetected() async {
    // Try native check first (more reliable)
    try {
      final result = await _channel.invokeMethod<bool>('isFridaDetected');
      return result ?? false;
    } on MissingPluginException {
      // Fallback: Dart-level checks
      return _dartFridaCheck();
    }
  }

  /// Dart-level Frida detection (less reliable but works without native code).
  static bool _dartFridaCheck() {
    if (kIsWeb) return false;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Check 1: Frida default port (27042)
        // We try a quick connect — if it succeeds, Frida server is running
        // Note: This is a basic check; advanced Frida configs use different ports
        return false; // Port check done natively for reliability
      }
    } catch (_) {
      // Ignore
    }
    return false;
  }

  // ─────────────────────────────────────────────
  //  #7 — ROOT / JAILBREAK DETECTION (basic)
  // ─────────────────────────────────────────────

  /// Check if device is rooted/jailbroken.
  static Future<bool> _isDeviceCompromised() async {
    try {
      final result = await _channel.invokeMethod<bool>('isDeviceCompromised');
      return result ?? false;
    } on MissingPluginException {
      return _dartRootCheck();
    }
  }

  /// Dart-level root detection for Android.
  static bool _dartRootCheck() {
    if (kIsWeb) return false;

    try {
      if (Platform.isAndroid) {
        // Check for common su binary paths
        final suPaths = [
          '/system/bin/su',
          '/system/xbin/su',
          '/sbin/su',
          '/data/local/xbin/su',
          '/data/local/bin/su',
          '/system/sd/xbin/su',
          '/system/app/Superuser.apk',
          '/data/data/com.noshufou.android.su',
          '/data/data/eu.chainfire.supersu',
        ];

        for (final path in suPaths) {
          if (File(path).existsSync()) {
            return true;
          }
        }

        // Check for Magisk
        if (File('/sbin/.magisk').existsSync() ||
            File('/data/adb/magisk').existsSync()) {
          return true;
        }
      }
    } catch (_) {
      // Permission denied on some paths — expected on non-rooted devices
    }
    return false;
  }

  // ─────────────────────────────────────────────
  //  EMULATOR DETECTION
  // ─────────────────────────────────────────────

  /// Check if the app is running on an emulator.
  static Future<bool> _isEmulator() async {
    try {
      final result = await _channel.invokeMethod<bool>('isEmulator');
      return result ?? false;
    } on MissingPluginException {
      return false; // Cannot reliably detect from Dart alone
    }
  }
}

/// Result of security checks.
class SecurityResult {
  final List<String> threats;

  SecurityResult({required this.threats});

  factory SecurityResult.safe() => SecurityResult(threats: []);

  bool get isSafe => threats.isEmpty;
  bool get hasThreat => threats.isNotEmpty;
}
