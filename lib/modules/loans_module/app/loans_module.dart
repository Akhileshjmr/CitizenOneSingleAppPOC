library loans_module;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/pl_history/pl_history_args.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/session/module_navigation_coordinator.dart';
import 'package:citizenone_app/modules/loans_module/app/session/services/session_api.dart';
import 'package:citizenone_app/modules/loans_module/app/session/session_manager.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/ag_constants.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import 'app_environment.dart';
import 'data/config/initialize_app.dart';
import 'data/local/store/user_provider.dart';
import 'data/remote/provider/auth_service.dart';

class LoansModule {
  static Future<void> initialize() async {
    ///call below line when other wise asset images won't load
    AppEnvironment.markAsEmbedded();
    await LoansInitializer.initialize();
  }

  static bool isChildApp = true;

  static List<GetPage<dynamic>> get pages => AppPages.routes;
  static final ModuleNavigationObserver navigatorObserver =
      ModuleNavigationObserver();
  static List<NavigatorObserver> get navigatorObservers => [navigatorObserver];

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

  static Future<void> login({required String phoneNumber}) async {
    if (phoneNumber.isEmpty) {
      throw "Phone number is required";
    }

    final sessionManager = Get.find<SessionManager>();
    try {
      final navigationCoordinator = Get.find<ModuleNavigationCoordinator>();
      navigationCoordinator.captureLaunchReferences();
      SessionApi.sessionSecureKey = phoneNumber;
      await sessionManager.createSession(phoneNumber: phoneNumber);

      final didLogin = await AuthService.login(phoneNumber: phoneNumber);
      if (!didLogin) {
        throw "Login failed";
      }
    } catch (e, stack) {
      await sessionManager.handleModuleDetached();
      throw "Login failed, $e, stackTrace: $stack}";
    }
  }

  static Future<void> initLoans({
    required String phoneNumber,
    String? bankCode,
    Color? themeColor,
  }) async {
    final sessionManager = Get.find<SessionManager>();
    try {
      AgConstants.popBackFromLoans = false;
      if (themeColor != null) {
        AppColors.primary = themeColor;
        AppColors.primaryDark = themeColor;
      }

      if (bankCode != null) {
        AgConstants.bankCode = bankCode;
      }
      if (phoneNumber.isNotEmpty) {
        AgConstants.agentMobileNumber = phoneNumber;
      }

      final navigationCoordinator = Get.find<ModuleNavigationCoordinator>();
      navigationCoordinator.captureLaunchReferences();
      SessionApi.sessionSecureKey = phoneNumber;
      await sessionManager.createSession(phoneNumber: phoneNumber);

      Get.toNamed(Routes.LOANS_LOGIN);
    } catch (e, stack) {
      await sessionManager.handleModuleDetached();
      throw "Login failed, $e, stackTrace: $stack}";
    }
  }

  /// Called from Loans to send result
  static Future<void> finish(String result) async {
    await Get.find<SessionManager>().exitModule(result: result);
  }

  /// ✅ Completely close Loans context
  /// ✅ Clean up Loans navigation + controllers
  static Future<void> _cleanupLoansStack() async {
    try {
      await UserProvider.onLogout();
      if (Get.key.currentState?.canPop() ?? false) {
        Get.until((route) => route.isFirst);
      }

      debugPrint('🧹 Loans controllers and routes cleared.');
    } catch (e, st) {
      debugPrint('❌ Error cleaning up Loans stack: $e\n$st');
    }
  }

  static void _deleteIfRegistered<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
      debugPrint('🧩 Deleted controller: $T');
    }
  }

  /// Open PL History for customer phone number search
  static Future<void> openPlHistoryByCustomerPhone({
    required String phoneNumber,
  }) async {
    final sessionManager = Get.find<SessionManager>();
    try {
      AgConstants.popBackFromLoans = true;
      final navigationCoordinator = Get.find<ModuleNavigationCoordinator>();
      navigationCoordinator.captureLaunchReferences();
      SessionApi.sessionSecureKey = phoneNumber;
      await sessionManager.createSession(phoneNumber: phoneNumber);

      Get.toNamed(
        Routes.PL_HISTORY,
        arguments: PlHistoryArgs(
          historyType: PlHistoryType.customerPhoneSearch,
          customerPhoneNumber: phoneNumber,
        ),
      );
    } catch (e) {
      await sessionManager.handleModuleDetached();
      rethrow;
    }
  }

  /// Open PL History for agent phone number search
  static Future<void> openPlHistoryByAgentPhone({
    required String phoneNumber,
  }) async {
    final sessionManager = Get.find<SessionManager>();
    try {
      AgConstants.popBackFromLoans = true;
      final navigationCoordinator = Get.find<ModuleNavigationCoordinator>();
      navigationCoordinator.captureLaunchReferences();
      SessionApi.sessionSecureKey = phoneNumber;
      await sessionManager.createSession(phoneNumber: phoneNumber);

      Get.toNamed(
        Routes.PL_HISTORY,
        arguments: PlHistoryArgs(
          historyType: PlHistoryType.agentPhoneSearch,
          agentPhoneNumber: phoneNumber,
        ),
      );
    } catch (e) {
      await sessionManager.handleModuleDetached();
      rethrow;
    }
  }
}

class LoansInitializer {
  static Future<void> initialize() async {
    await GetStorage.init();
    final GetStorage box = GetStorage();
    print('LoansModule: 🔧 Loans Initialized');
    print('LoansModule: 🌐 API Base: ${box.read('currentIp')}');
    print('LoansModule: 🖼️ Image Base: ${box.read('currentImgIp')}');
    await initializeCoreApp(
      developmentApiBaseUrl: 'http://192.168.3.69:9098/credeze/',
      productionApiBaseUrl: 'http://192.168.3.69:9098/credeze/',
      developmentImageUrl: 'http://192.168.1.81:2048/profitto',
      productionImageUrl: 'http://192.168.1.81:2048/profitto',
      livezyWebUrl: '',
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

// Navigate to Loans’s flow
await Get.to(
() => const OtpView(),
fullscreenDialog: true,
preventDuplicates: false,
);
// Return result asynchronously (when completed)
return _completer!.future;
}

  /// ✅ Called from inside Loans (anywhere)
  static void finish(String result) {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(result);
      debugPrint('✅ LoansLoansModule: Completed with result => $result');
    }
  }
*/
