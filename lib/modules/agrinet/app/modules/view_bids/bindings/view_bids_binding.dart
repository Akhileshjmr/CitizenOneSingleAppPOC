import 'package:citizenone_app/modules/agrinet/app/modules/publish_ads/controllers/publish_ads_controller.dart';
import 'package:get/get.dart';

import '../controllers/view_bids_controller.dart';

class ViewBidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewBidsController>(() => ViewBidsController(), fenix: true);
    Get.lazyPut<PublishAdsController>(
      () => PublishAdsController(),
      fenix: true,
    );
  }
}
