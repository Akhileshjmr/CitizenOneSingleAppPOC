import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import 'session_manager.dart';

class ModuleNavigationCoordinator extends GetxService {
  BuildContext? launchContext;
  NavigatorState? launchNavigator;
  Route<dynamic>? launchRoute;
  String? launchRouteName;

  final Set<String> _moduleRouteNames =
      AppPages.routes
          .map((page) => page.name)
          .whereType<String>()
          .toSet();

  bool _isClosingModule = false;

  bool isModuleRoute(Route<dynamic>? route) {
    final routeName = route?.settings.name;
    return routeName != null && _moduleRouteNames.contains(routeName);
  }

  void captureLaunchReferences([BuildContext? context]) {
    final resolvedContext = context ?? Get.context ?? Get.overlayContext;

    if (resolvedContext == null) {
      return;
    }

    launchContext = resolvedContext;
    launchNavigator = Navigator.of(resolvedContext);
    launchRoute = ModalRoute.of(resolvedContext);
    launchRouteName = launchRoute?.settings.name;
  }

  Future<void> closeModule({Object? result}) async {
    // Ensure we don't execute the close logic multiple times concurrently.
    if (_isClosingModule) return;
    _isClosingModule = true;

    try {
      // Use the navigator that was captured at launch time if available.
      // If it is not available (unlikely), fall back to the global Get navigator.
      final NavigatorState? navigator = launchNavigator ?? Get.key.currentState;

      // If we still have no navigator, there is nothing we can safely pop.
      if (navigator == null) {
        return;
      }

      // Pop routes until we reach the first route that is *not* part of the LoansModule.
      // This preserves the parent application's navigation stack.
      navigator.popUntil((Route<dynamic> route) => !isModuleRoute(route));

      // If a result was provided, deliver it to the parent via Get.back.
      if (result != null && (Get.key.currentState?.canPop() ?? false)) {
        Get.back(result: result);
      }
    } finally {
      _isClosingModule = false;
    }
  }

  void handleRouteChanged({
    required Route<dynamic>? previousRoute,
    required Route<dynamic>? currentRoute,
  }) {
    if (_isClosingModule) {
      return;
    }

    // If either route is null we are in the middle of a bulk navigation change
    // (e.g., Get.offAllNamed) and should not treat this as leaving the module.
    if (previousRoute == null || currentRoute == null) {
      return;
    }

    final leftModule =
        isModuleRoute(previousRoute) && !isModuleRoute(currentRoute);

    if (!leftModule || !Get.isRegistered<SessionManager>()) {
      return;
    }

    final sessionManager = Get.find<SessionManager>();
    if (!sessionManager.hasActiveSession) {
      return;
    }

    unawaited(sessionManager.handleModuleDetached());
  }
}

class ModuleNavigationObserver extends NavigatorObserver {
  Route<dynamic>? _currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleChange(previousRoute: previousRoute, currentRoute: route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleChange(previousRoute: route, currentRoute: previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _handleChange(previousRoute: route, currentRoute: previousRoute);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _handleChange(previousRoute: oldRoute, currentRoute: newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _handleChange({
    required Route<dynamic>? previousRoute,
    required Route<dynamic>? currentRoute,
  }) {
    _currentRoute = currentRoute ?? _currentRoute;

    if (!Get.isRegistered<ModuleNavigationCoordinator>()) {
      return;
    }

    Get.find<ModuleNavigationCoordinator>().handleRouteChanged(
      previousRoute: previousRoute,
      currentRoute: currentRoute,
    );
  }
}
