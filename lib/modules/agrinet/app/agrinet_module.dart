library agrinet_module;

import 'dart:async';

import 'package:citizenone_app/modules/agrinet/app/data/services/session_manager.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_environment.dart';
import 'data/config/initialize_app.dart';
import 'data/remote/providers/auth_provider.dart';

class AgrinetModule {
  static Future<void> initialize() async {
    ///call below line when other wise asset images won't load
    AppEnvironment.markAsEmbedded();
    await AgrinetInitializer.initialize();
  }

  static List<GetPage<dynamic>> get pages => AppPages.routes;

  static final StreamController<String> _resultStream =
      StreamController<String>.broadcast();

  /// Listen from Banking
  static Stream<String> get resultStream => _resultStream.stream;

  /*static Future<void> open() async {
    final role = UserPrefs.user?.role;

    if (role == null) {
      throw "User not logged in";
    }

    final isBuyer = role == "Buyer";

    GlobalRegistry.register(isBuyer ? BuyerHomeController() : HomeController());

    Get.toNamed(isBuyer ? Routes.BUYER_HOME : Routes.HOME);
  }*/

  static Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw "Username and password are required";
    }

    try {
      await AuthProvider.login(
        username: username,
        password: password,
        disableBackNavigation: false,
      );
    } catch (e, stack) {
      throw "Login failed, $e, stackTrace: $stack}";
    }
  }

  /// Called from Agrinet to send result
  static void finish(String result) {
    debugPrint('✅ AgrinetModule: Completed with result => $result');

    /// Notify Banking
    if (!_resultStream.isClosed) {
      _resultStream.add(result);
    }

    /// Clean up Agrinet navigation stack and controllers
    _cleanupAgrinetStack();
    SessionManager().forceLogout();
  }

  /// ✅ Completely close Agrinet context
  /// ✅ Clean up Agrinet navigation + controllers
  static Future<void> _cleanupAgrinetStack() async {
    try {
      if (Get.key.currentState?.canPop() ?? false) {
        Get.until((route) => route.isFirst);
      }

      debugPrint('🧹 Agrinet controllers and routes cleared.');
    } catch (e, st) {
      debugPrint('❌ Error cleaning up Agrinet stack: $e\n$st');
    }
  }

  static void _deleteIfRegistered<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
      debugPrint('🧩 Deleted controller: $T');
    }
  }
}

class AgrinetInitializer {
  static Future<void> initialize() async {
    await GetStorage.init();
    final GetStorage box = GetStorage();
    print('AgrinetModule: 🔧 Agrinet Initialized');
    print('AgrinetModule: 🌐 API Base: ${box.read('currentIp')}');
    print('AgrinetModule: 🖼️ Image Base: ${box.read('currentImgIp')}');
    await initializeCoreApp(
      developmentApiBaseUrl: 'http://192.168.1.81:2048/profitto/',
      productionApiBaseUrl: 'http://192.168.1.81:2048/profitto/',
      developmentImageUrl: 'http://192.168.1.81:2048/profitto/',
      productionImageUrl: 'http://192.168.1.81:2048/profitto/',
    );
  }
}

/*

  static Completer<String>? _completer;
static Future<String?> open() async {
// Initialize once
_completer = Completer<String>();

if (!Get.isRegistered<OtpController>()) {
Get.put(OtpController());
}

await Get.find<OtpController>().getOtp();

// Navigate to Agrinet’s flow
await Get.to(
() => const OtpView(),
fullscreenDialog: true,
preventDuplicates: false,
);
// Return result asynchronously (when completed)
return _completer!.future;
}

  /// ✅ Called from inside Agrinet (anywhere)
  static void finish(String result) {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(result);
      debugPrint('✅ AgrinetAgrinetModule: Completed with result => $result');
    }
  }
*/
