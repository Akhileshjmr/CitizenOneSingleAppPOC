import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/session/session_expiry_monitor.dart';

import 'module_navigation_coordinator.dart';
import 'services/session_api.dart';
import 'services/session_repository.dart';
import 'services/session_service.dart';
// Deprecated import removed
import 'session_manager.dart';

class SessionBindings {
  static void ensureInitialized() {
    if (!Get.isRegistered<SessionApi>()) {
      Get.put(SessionApi(), permanent: true);
    }
    if (!Get.isRegistered<SessionRepository>()) {
      Get.put(SessionRepository(Get.find<SessionApi>()), permanent: true);
    }
    if (!Get.isRegistered<SessionService>()) {
      Get.put(SessionService(Get.find<SessionRepository>()), permanent: true);
    }
    if (!Get.isRegistered<SessionExpiryMonitor>()) {
      Get.put(SessionExpiryMonitor(), permanent: true);
    }
    if (!Get.isRegistered<ModuleNavigationCoordinator>()) {
      Get.put(ModuleNavigationCoordinator(), permanent: true);
    }
    if (!Get.isRegistered<SessionManager>()) {
      Get.put(
        SessionManager(
          sessionService: Get.find<SessionService>(),
          navigationCoordinator: Get.find<ModuleNavigationCoordinator>(),
        ),
        permanent: true,
      );
    }
  }
}
