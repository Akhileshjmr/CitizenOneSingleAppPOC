import 'package:get/get.dart';

import '../controllers/pl_upload_documents_controller.dart';

class PlUploadDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlUploadDocumentsController>(
      () => PlUploadDocumentsController(),
    );
  }
}
