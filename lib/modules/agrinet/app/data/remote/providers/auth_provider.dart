import 'dart:developer';

import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/services/session_manager.dart';
import 'package:dio/dio.dart' as client;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../model/user/login_response.dart';
import '../../model/user/refresh_token_response.dart';
import '../api_service/ApiEndPoints.dart';
import '../api_service/init_api_service.dart';

class AuthProvider {
  static Future<LoginResponse?> login({
    required String username,
    required String password,
    bool disableBackNavigation = true,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.login,
        data: {
          "profittoUser": {'userName': username, 'password': password},
        },
      );

      final loginResponse = LoginResponse.fromJson(response?.data ?? {});

      if (loginResponse.chMessage?.code == "SUCCESS") {
        await UserPrefs.saveLoginResponse(loginResponse);

        SessionManager.sessionDuration = int.parse(
          loginResponse.sessionTime ?? '1',
        );

        SessionManager().start();

        final route =
            loginResponse.role == "Buyer" ? Routes.BUYER_HOME : Routes.HOME;

        if (disableBackNavigation) {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }

        return loginResponse;
      } else if (loginResponse.chMessage?.code == "FAILURE") {
        Get.defaultDialog(
          title: "Login Failed",
          middleText: loginResponse.chMessage?.message ?? "Invalid login.",
        );
        return null;
      }
      return null;
    } catch (e) {
      log("Login Exception: $e");
      return null;
    }
  }

  static Future<RefreshTokenResponse?> refreshSessionToken() async {
    try {
      final response = await APIService.get(
        path: ApiEndPoints.refreshToken,
        options: client.Options(extra: {'noAuth': true}),
      );

      if (response?.data != null) {
        return RefreshTokenResponse.fromJson(response!.data!);
      }

      return null;
    } catch (e) {
      debugPrint("Refresh error: $e");
      return null;
    }
  }
}
