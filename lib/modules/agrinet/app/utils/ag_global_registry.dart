import 'package:get/get.dart';

class GlobalRegistry {
  static T register<T>(T controller) {
    if (!Get.isRegistered<T>()) {
      return Get.put<T>(controller);
    }
    return Get.find<T>();
  }
}
