import 'dart:convert';

import 'package:citizenone_app/modules/loans_module/app/data/model/user/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';
import '../../config/encryption.dart';
import 'local_store.dart';

class UserProvider {
  /// ================= IN-MEMORY STATE =================

  static LoginResponse? _user;
  static String? _authToken;
  static bool _isLoggedIn = false;

  static LoginResponse? get currentUser => _user;
  static String? get authToken => _authToken;
  static bool get isLoggedIn => _isLoggedIn;

  /// ================= SHARED PREF KEYS =================

  static const _kPhone = "UserPhone";
  static const _kEmail = "Email";
  static const _kMPIN = "MPINNumber";
  static const _kFlights = "flights";

  static const _kEmiratesPoints = "custEmiratesRePoints";
  static const _kBasicPoints = "custBasicInfoRePoints";
  static const _kGenderPoints = "custGenderRePoints";
  static const _kDobPoints = "custDobRePoints";
  static const _kMaritalPoints = "custMaritalInfoRePoints";
  static const _kSpecialPoints = "custSpacialDateRePoints";
  static const _kAnniversaryPoints = "custAnniversaryRePoints";

  /// ================= PREF HELPER =================

  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  static Future<void> _saveString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  static Future<String> _getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future<void> _removeKey(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  static String setAuthToken(String token) => _authToken = token;

  /// ================= LOGIN =================

  static Future<void> onLogin(LoginResponse user, String token) async {
    _isLoggedIn = true;
    _user = user;
    _authToken = token;

    LocalStore.userData(
      AppEncryption.encrypt(plainText: jsonEncode(user.toJson())),
    );

    LocalStore.authToken(token);
  }

  static Future<void> onLogout() async {
    _isLoggedIn = false;
    _user = null;
    _authToken = null;

    LocalStore.userData.remove();
    LocalStore.authToken.remove();
  }

  /// ================= LOAD USER =================

  static void loadUser() {
    try {
      final encrypted = LocalStore.userData();

      if (encrypted == null) {
        _isLoggedIn = false;
        return;
      }

      final decrypted = AppEncryption.decrypt(cipherText: encrypted);

      _user = LoginResponse.fromJson(
        jsonDecode(decrypted) as Map<String, dynamic>,
      );

      _authToken = LocalStore.authToken();
      _isLoggedIn = true;
    } catch (_) {
      _isLoggedIn = false;
    }
  }

  static String get initialRoute =>
      (_isLoggedIn && _user != null) ? Routes.HOME : Routes.LOANS_LOGIN;

  /// ================= BASIC INFO =================

  static Future<void> saveMobile(String value) => _saveString(_kPhone, value);

  static Future<String> getMobileNumber() => _getString(_kPhone);

  static Future<void> saveEmail(String value) => _saveString(_kEmail, value);

  static Future<String> getEmail() => _getString(_kEmail);

  static Future<void> saveMPIN(String value) => _saveString(_kMPIN, value);

  static Future<String> getMPIN() => _getString(_kMPIN);

  /// ================= POINTS =================

  static Future<void> saveEmiratesPoints(String v) =>
      _saveString(_kEmiratesPoints, v);

  static Future<String> getEmiratesPoints() => _getString(_kEmiratesPoints);

  static Future<void> saveBasicPoints(String v) =>
      _saveString(_kBasicPoints, v);

  static Future<String> getBasicPoints() => _getString(_kBasicPoints);

  static Future<void> saveGenderPoints(String v) =>
      _saveString(_kGenderPoints, v);

  static Future<String> getGenderPoints() => _getString(_kGenderPoints);

  static Future<void> saveDobPoints(String v) => _saveString(_kDobPoints, v);

  static Future<String> getDobPoints() => _getString(_kDobPoints);

  static Future<void> saveMaritalPoints(String v) =>
      _saveString(_kMaritalPoints, v);

  static Future<String> getMaritalPoints() => _getString(_kMaritalPoints);

  static Future<void> saveSpecialPoints(String v) =>
      _saveString(_kSpecialPoints, v);

  static Future<String> getSpecialPoints() => _getString(_kSpecialPoints);

  static Future<void> saveAnniversaryPoints(String v) =>
      _saveString(_kAnniversaryPoints, v);

  static Future<String> getAnniversaryPoints() =>
      _getString(_kAnniversaryPoints);

  /// ================= CLEAR KEY =================

  static Future<void> clearKey(String key) => _removeKey(key);
}
