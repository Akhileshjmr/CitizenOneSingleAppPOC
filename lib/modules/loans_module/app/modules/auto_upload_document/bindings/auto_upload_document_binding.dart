import 'package:get/get.dart';

import '../controllers/auto_upload_document_controller.dart';

class AutoUploadDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoUploadDocumentController>(
      () => AutoUploadDocumentController(),
    );
  }
}
