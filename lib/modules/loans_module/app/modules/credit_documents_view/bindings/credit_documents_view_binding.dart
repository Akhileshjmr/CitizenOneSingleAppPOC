import 'package:get/get.dart';

import '../controllers/credit_documents_view_controller.dart';

class CreditDocumentsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditDocumentsViewController>(
      () => CreditDocumentsViewController(),
    );
  }
}
