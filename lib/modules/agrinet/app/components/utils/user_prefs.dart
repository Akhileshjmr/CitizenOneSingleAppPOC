import 'dart:convert';

import 'package:citizenone_app/modules/agrinet/app/app_environment.dart';
import 'package:citizenone_app/modules/agrinet/app/data/services/session_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user/login_response.dart';
import '../../routes/app_pages.dart';
import '../ui/ag_alert_dialogue.dart';

class UserPrefs {
  static const _loginKey = "login_response";
  static LoginResponse? user;

  /// Check if user is logged in
  static bool isLoggedIn() {
    return user != null;
  }

  /// Save LoginResponse object as JSON string
  static Future<void> saveLoginResponse(LoginResponse data) async {
    user = data;
    final prefs = await SharedPreferences.getInstance();

    // Convert object → Map → JSON string
    final jsonString = jsonEncode(data.toJson());

    await prefs.setString(_loginKey, jsonString);
  }

  /// Retrieve LoginResponse object from SharedPreferences
  static Future<LoginResponse?> getLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_loginKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> map = jsonDecode(jsonString);

    return LoginResponse.fromJson(map);
  }

  /// Clear login data
  static Future<void> clearLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }

  static Future<void> updateUser(LoginResponse updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    user = updatedData;
    final jsonString = jsonEncode(updatedData.toJson());
    await prefs.setString(_loginKey, jsonString);
  }

  static Future<void> logout() async {
    AgAlertDialog.confirm(
      title: "ALERT",
      message: "Are you sure? Do you want to logout?",
      cancelText: "Cancel",
      okText: "Yes",
      onConfirm: () async {
        SessionManager().forceLogout();
      },
    );
  }

  static Future<void> clearDataLogout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_loginKey);
    user = null;

    if (!AppEnvironment.isEmbeddedInHostApp) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  static Future<void> updateToken(String newToken) async {
    final login = await getLoginResponse();

    if (login == null) return;
    login.token = newToken;

    await updateUser(login);
  }
}
