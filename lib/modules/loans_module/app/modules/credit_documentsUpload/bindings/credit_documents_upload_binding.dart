import 'package:get/get.dart';

import '../controllers/credit_documents_upload_controller.dart';

class CreditDocumentsUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditDocumentsUploadController>(
      () => CreditDocumentsUploadController(),
    );
  }
}
