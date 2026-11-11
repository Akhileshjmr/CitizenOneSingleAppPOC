import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static final SecureStorage _storageClass = SecureStorage._internal();

  factory SecureStorage() {
    return _storageClass;
  }

  SecureStorage._internal();

  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  static const String _keyAccessToken = "access_token";

  // ─────────────────────────────────────────────
  // TOKEN MANAGEMENT
  // ─────────────────────────────────────────────

  /// Initializes token from compile-time environment variable if empty
  Future<void> initializeTokenFromEnvironment() async {
    final existingToken = await getAccessToken();

    if (existingToken.isEmpty) {
      // Reads value injected via --dart-define
      const initialToken = String.fromEnvironment('STATIC_ACCESS_TOKEN');

      if (initialToken.isNotEmpty) {
        await saveAccessToken(initialToken);
      }
    }
  }

  Future<void> saveAccessToken(String token) async {
    await writeSecureData(_keyAccessToken, token);
  }

  Future<String> getAccessToken() async {
    return await readSecureData(_keyAccessToken);
  }

  Future<void> deleteAccessToken() async {
    await deleteSecureData(_keyAccessToken);
  }

  // ─────────────────────────────────────────────
  // GENERIC SECURE STORAGE
  // ─────────────────────────────────────────────

  Future<void> writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    return await storage.read(key: key) ?? "";
  }

  Future<void> deleteSecureData(String key) async {
    await storage.delete(key: key);
  }

  Future<void> deleteAllSecureData() async {
    await storage.deleteAll();
  }

  Future<void> checkFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstInstall = prefs.getBool('first_install') ?? true;

    if (isFirstInstall) {
      await deleteAllSecureData();
      await DataCleaner.clearLegacyData();
      await prefs.setBool('first_install', false);
    }
  }
}

class DataCleaner {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<void> clearLegacyData() async {
    final prefs = await SharedPreferences.getInstance();

    final alreadyCleaned = prefs.getBool("secureCleanupDone") ?? false;
    if (!alreadyCleaned) {
      await prefs.clear();
      await _secureStorage.deleteAll();
      await prefs.setBool("secureCleanupDone", true);
    }
  }
}
