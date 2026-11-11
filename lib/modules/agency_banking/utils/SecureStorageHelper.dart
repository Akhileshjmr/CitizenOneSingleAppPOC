import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralized secure storage helper that replaces SharedPreferences
/// for sensitive data. Uses Android Keystore / iOS Keychain under the hood.
class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  // Storage keys
  static const String _loginResponseKey = 'loginResponse';
  static const String _selectedBankKey = 'selectedBankJson';
  static const String _bankSelectedKey = 'isBankSelected';
  static const String _tenantsListKey = 'tenantsList';
  static const String _baseUrlKey = 'base_url';

  // --- Login Response ---
  static Future<void> saveLoginResponse(String jsonString) async {
    await _storage.write(key: _loginResponseKey, value: jsonString);
  }

  static Future<String?> getLoginResponse() async {
    return await _storage.read(key: _loginResponseKey);
  }

  static Future<void> removeLoginResponse() async {
    await _storage.delete(key: _loginResponseKey);
  }

  // --- Selected Bank ---
  static Future<void> saveSelectedBank(String jsonString) async {
    await _storage.write(key: _selectedBankKey, value: jsonString);
  }

  static Future<String?> getSelectedBank() async {
    return await _storage.read(key: _selectedBankKey);
  }

  static Future<void> removeSelectedBank() async {
    await _storage.delete(key: _selectedBankKey);
  }

  // --- Bank Selected Flag ---
  static Future<void> setBankSelected(bool value) async {
    await _storage.write(key: _bankSelectedKey, value: value.toString());
  }

  static Future<bool> isBankSelected() async {
    final value = await _storage.read(key: _bankSelectedKey);
    return value == 'true';
  }

  static Future<void> removeBankSelected() async {
    await _storage.delete(key: _bankSelectedKey);
  }

  // --- Tenants List ---
  static Future<void> saveTenantsList(String jsonString) async {
    await _storage.write(key: _tenantsListKey, value: jsonString);
  }

  static Future<String?> getTenantsList() async {
    return await _storage.read(key: _tenantsListKey);
  }

  static Future<void> removeTenantsList() async {
    await _storage.delete(key: _tenantsListKey);
  }

  // --- Base URL ---
  static Future<void> setBaseUrl(String url) async {
    await _storage.write(key: _baseUrlKey, value: url);
  }

  static Future<String?> getBaseUrl() async {
    return await _storage.read(key: _baseUrlKey);
  }

  // --- Clear All ---
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // --- Clear Session Data (keep base_url) ---
  static Future<void> clearSessionData() async {
    await removeLoginResponse();
    await removeSelectedBank();
    await removeBankSelected();
    await removeTenantsList();
  }
}
