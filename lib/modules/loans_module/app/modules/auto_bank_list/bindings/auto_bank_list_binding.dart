import 'package:get/get.dart';

import '../controllers/auto_bank_list_controller.dart';

class AutoBankListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AutoBankListController>(
      () => AutoBankListController(),
    );
  }
}
