import 'package:get/get.dart';

import '../controllers/p_r_upload_document_controller.dart';

class PRUploadDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PRUploadDocumentController>(
      () => PRUploadDocumentController(),
    );
  }
}
