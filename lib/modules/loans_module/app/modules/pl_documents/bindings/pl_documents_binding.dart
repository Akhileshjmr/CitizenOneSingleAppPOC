import 'package:get/get.dart';

import '../controllers/pl_documents_controller.dart';

class PlDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlDocumentsController>(
      () => PlDocumentsController(),
    );
  }
}
