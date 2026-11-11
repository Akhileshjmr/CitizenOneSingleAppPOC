import 'package:get/get.dart';

import '../controllers/publish_ads_controller.dart';

class PublishAdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublishAdsController>(() => PublishAdsController());
  }
}
