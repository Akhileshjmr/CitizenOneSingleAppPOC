import 'package:get/get.dart';

import '../controllers/p_r_document_list_controller.dart';

class PRDocumentListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PRDocumentListController>(
      () => PRDocumentListController(),
    );
  }
}
