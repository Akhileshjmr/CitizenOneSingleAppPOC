import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/utils/user_prefs.dart';
import '../../../data/remote/providers/auth_provider.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    previousSession();
    // usernameCtrl.text = "0303030303";
    usernameCtrl.text = "abhay";
    passwordCtrl.text = "test12";
  }

  // Text controllers
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  // Loader state
  final isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;

    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    if (username.isEmpty) {
      isLoading.value = false;
      AgAlertDialog.show(title: "Alert", message: "Username is missing");
      return;
    }
    if (password.isEmpty) {
      AgAlertDialog.show(
        title: "Alert",
        message:
            "*Password must be Alfa-numeric (at least 1 numeric digit). "
            "*Password Alfa characters must contain 1 capital letter. "
            "*Password must not be more than 8 digits.",
      );
      return;
    }

    await AuthProvider.login(username: username, password: password);

    isLoading.value = false;
  }

  // -------------------------
  // Dispose controllers
  // -------------------------
  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  Future<void> previousSession() async {
    await UserPrefs.clearLoginResponse();
  }
}
