import 'package:get/get.dart';

import '../controllers/service_enquiry_controller.dart';

class ServiceEnquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceEnquiryController>(() => ServiceEnquiryController());
  }
}
