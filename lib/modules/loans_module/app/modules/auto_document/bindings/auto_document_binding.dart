import 'package:get/get.dart';

import '../controllers/auto_document_controller.dart';

class AutoDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoDocumentController>(
      () => AutoDocumentController(),
    );
  }
}
